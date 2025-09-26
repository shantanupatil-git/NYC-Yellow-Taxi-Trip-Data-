
# 🚖 NYC Yellow Taxi Data ETL & Analytics Dashboard

## 📌 Project Overview
The **NYC Yellow Taxi Data ETL & Analytics Dashboard** project processes over **77 million** taxi trip records from **JUNE 2019 to MAY 2021**.  
It performs **data extraction, transformation, and loading (ETL)** using **AWS Glue** and **PySpark**, stores the cleaned data in Amazon S3, and visualizes key transportation insights through an **interactive Power BI dashboard**.

The project is designed for **data-driven decision-making** by the **NYC Government** to improve transportation planning, policy-making, and public accessibility of taxi trip data.

---

## 🚀 Features
- **Data Volume**: Handles **77M+** rows of Yellow Taxi trip data
- **Automated ETL Pipeline**: Built with **AWS Glue** and **Terraform** for full CI/CD automation
- **Data Storage**: Raw and cleaned data stored in **Amazon S3**
- **Data Transformation**:
  - Null value filtering
  - Mapping location IDs to zones
  - Feature engineering (**Tip %**, **Distance Bucket**)
- **Interactive Dashboard** in **Power BI** with:
  - Monthly trip trends
  - Passenger count analysis
  - Tip percentage distribution
  - Zone-to-zone trip flow

---

## 🛠️ Tech Stack
**Data Processing**
- AWS Glue (**PySpark**)
- Amazon S3
- AWS EMR (for exploratory big data processing)

**Automation**
- Terraform
- GitHub Actions (**CI/CD**)

**Visualization**
- Power BI

---

## 📂 Data Sources
- **NYC TLC Yellow Taxi Trip Data** (2016–2022)  
  Public dataset provided by NYC Taxi & Limousine Commission.  
  🔗 [NYC TLC Trip Record Data](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)  
  Stored in a cross-account S3 bucket for processing.

---

## 📄 Dataset Information

| Column Name              | Data Type   | Description |
|--------------------------|-------------|-------------|
| **DOLocationID**         | long        | ID of the drop-off location, based on the NYC Taxi Zone lookup table. |
| **PULocationID**         | long        | ID of the pickup location, based on the NYC Taxi Zone lookup table. |
| **passenger_count**      | integer     | Number of passengers in the trip. |
| **extra**                | double      | Miscellaneous charges (e.g., for extra services or fees). |
| **tip_amount**           | double      | Amount of tip given by the passenger. |
| **fare_amount**          | double      | Base fare for the trip (excluding tips, tolls, and extras). |
| **total_amount**         | double      | Total amount charged to the passenger (including fare, tip, tolls, etc.). |
| **mta_tax**              | double      | MTA tax applicable to the trip. |
| **trip_distance**        | double      | Distance traveled in miles. |
| **VendorID**             | long        | ID of the taxi vendor (e.g., 1 = Creative Mobile Technologies, 2 = VeriFone Inc.). |
| **tpep_pickup_datetime** | timestamp   | Date and time when the trip started. |
| **tpep_dropoff_datetime**| timestamp   | Date and time when the trip ended. |
| **improvement_surcharge**| double      | Additional surcharge applied to the trip. |
| **payment_type**         | long        | Numeric code for payment type (e.g., 1 = Credit card, 2 = Cash). |
| **RatecodeID**           | integer     | ID representing the rate code (pricing category) used for the trip. |
| **tolls_amount**         | double      | Total tolls paid during the trip. |
| **week_of_month**        | integer     | Week number within the month for the pickup date. |
| **day_name**             | string      | Name of the day when the trip occurred (e.g., Monday). |
| **time_of_day**          | string      | Time category of the trip (e.g., Morning, Afternoon, Evening, Night). |
| **pickup_zone**          | string      | Human-readable name of the pickup location. |
| **pickup_borough**       | string      | NYC borough where the pickup occurred. |
| **dropoff_zone**         | string      | Human-readable name of the drop-off location. |
| **dropoff_borough**      | string      | NYC borough where the drop-off occurred. |
| **Id**                   | integer     | Unique identifier for the record (ETL-generated). |
| **distance_bucket**      | string      | Categorized trip distance (e.g., 0–2 miles, 2–5 miles). |
| **payment_type_desc**    | string      | Description of payment type (e.g., Credit Card, Cash). |
| **ratecode_desc**        | string      | Description of the rate code used. |
| **vendor_desc**          | string      | Description of the taxi vendor. |
| **year**                 | integer     | Year in which the trip occurred. |

---

## 📊 ETL Workflow
1. **Extract**  
   - Read raw Yellow Taxi data from public/cross-account S3 bucket.
   
2. **Transform**  
   - Remove null/invalid values
   - Map `PULocationID` and `DOLocationID` to zone names
   - Calculate new fields:
   -tip_percentage` = `(tip_amount / fare_amount) * 100`
   -distance_bucket` (0–1 mile / 1–5 mile / 5–10 mile / 10+ mile)
   
3. **Load**  
   - Store cleaned, transformed data into the processed S3 bucket.
   - Automatically update Glue Data Catalog via crawler.

4. **Visualize**  
   - Connect **Power BI** to processed S3 data (via **Athena**) for dashboard creation.

---

## ⚙️ Infrastructure Automation
- **Terraform** provisions:
  - Glue jobs
  - Glue crawlers
  - Glue database
  - S3 bucket configurations
- **GitHub Actions** triggers:
  - Upload ETL scripts to S3
  - Deploy Glue pipeline
  - Run ETL jobs automatically

---

## Team Members
- Gyandeep Yadav
- Varsha Pal
- Megha Dave
- Amrapali Makrand
- Pranav Patil
- Shantanu Patil
- Saurabh Bhangale
- Kunal Rahangdale
