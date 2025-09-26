# Declare a region
variable "region" {
  default = "us-east-1"
}

# Declare a bucket name prefix
variable "bucket_name_prefix" {
  default = "third-glue-bkt-grp-three-nyc"
}

# Declare a Glue job name
variable "glue_job_name" {
  default = "glue-etl-job"
}

# Declare a crawler name
variable "glue_crawler_name" {
  default = "my-etl-crawler"
}

variable "glue_role_arn" {
  description = "IAM role ARN to use for Glue Job"
  type        = string
}
