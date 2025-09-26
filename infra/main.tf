# Local timestamp variable
locals {
  timestamp       = formatdate("YYYY-MM-DD-hh-mm-ss", timestamp())
  glue_role_arn   = var.glue_role_arn
  script_s3_path  = "s3://${aws_s3_bucket.etl_bucket.bucket}/scripts/etl-glue-script.py"
}

# Create bucket with timestamp suffix
resource "aws_s3_bucket" "etl_bucket" {
  bucket        = "${var.bucket_name_prefix}-${local.timestamp}"
  force_destroy = true
}

# Enable ACLs by setting object ownership
resource "aws_s3_bucket_ownership_controls" "acl_control" {
  bucket = aws_s3_bucket.etl_bucket.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

# Set ACL for the bucket
resource "aws_s3_bucket_acl" "etl_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.acl_control]
  bucket     = aws_s3_bucket.etl_bucket.id
  acl        = "public-read" # Change to "public-read" if needed
}

# Disable Block Public Access
resource "aws_s3_bucket_public_access_block" "disable_block" {
  bucket = aws_s3_bucket.etl_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket policy to allow Glue role read/write
resource "aws_s3_bucket_policy" "glue_access" {
  bucket = aws_s3_bucket.etl_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowGlueReadWrite"
        Effect    = "Allow"
        Principal = {
          AWS = var.glue_role_arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.etl_bucket.arn,
          "${aws_s3_bucket.etl_bucket.arn}/*"
        ]
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.disable_block]
}

# Glue database
resource "aws_glue_catalog_database" "etl_db" {
  name = "nyc-taxi-trip-db-${local.timestamp}"
}

# Upload Glue ETL script to S3
resource "aws_s3_object" "glue_script" {
  bucket = aws_s3_bucket.etl_bucket.bucket
  key    = "scripts/etl-glue-script.py"
  source = "${path.module}/../etl/etl-glue-script.py"
  etag   = filemd5("${path.module}/../etl/etl-glue-script.py")
}

# Glue job
resource "aws_glue_job" "etl_job" {
  name     = "${var.glue_job_name}-${local.timestamp}"
  role_arn = local.glue_role_arn

  command {
    name            = "glueetl"
    script_location = local.script_s3_path
    python_version  = "3"
  }

  glue_version      = "4.0"
  number_of_workers = 2
  worker_type       = "G.1X"
  depends_on        = [aws_s3_object.glue_script]
}

# Glue crawler
resource "aws_glue_crawler" "etl_crawler" {
  name          = "${var.glue_crawler_name}-${local.timestamp}"
  role          = local.glue_role_arn
  database_name = aws_glue_catalog_database.etl_db.name

  s3_target {
    path = "s3://raw-data-grp-3/cleaned-data/transformeddata/"
  }

  depends_on = [aws_glue_job.etl_job]
}
