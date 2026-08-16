# Healthcare Analytics Pipeline: From SQL Warehouse to Power BI

## 📌 Project Overview
This project demonstrates an end-to-end data analytics solution designed to optimize financial performance and uncover patient demographics within a regional healthcare network. By consolidating disparate clinical and financial records into a centralized relational data warehouse, this pipeline enables deep diagnostic analysis and automated reporting for executive decision-making. 

## 🛠️ Tech Stack & Tools
*   **Database Management:** SQL Server (SSMS)
*   **Data Analysis & EDA:** Python (Pandas, NumPy, Matplotlib, Seaborn)
*   **Business Intelligence:** Power BI
*   **Concepts Applied:** Data Warehousing, ETL, Relational Database Design, Statistical Analysis, Data Visualization.

## 🗄️ Dataset Architecture
The data relies on a fully relational healthcare schema comprising five core tables:
*   `patients`: Patient demographics and geospatial data.
*   `encounters`: Clinical visit logs, timestamps, and financial claims.
*   `procedures`: Specific medical treatments administered during encounters.
*   `payers`: Insurance providers and coverage details.
*   `organizations`: Hospital and clinic facility information.

## 🚀 Project Execution Steps

### Step 1: Data Understanding & Pre-EDA
*   Profiled raw CSV files to identify primary and foreign key relationships.
*   Validated data types, focusing on ISO8601 UTC timestamps and financial integrity.

### Step 2: Data Warehousing (SQL Server)
*   Engineered the database schema utilizing DDL statements with strict primary and foreign key constraints.
*   Imported raw datasets into SSMS.
*   Developed a centralized, denormalized master view via SQL `JOIN`s to streamline downstream BI reporting and minimize dashboard processing load.

### Step 3: EDA & Deep Business Analysis (Python)
*   Analyzed the out-of-pocket financial burden on patients by evaluating claim costs versus insurance coverage across different demographics.
*   Identified operational bottlenecks by calculating average encounter durations across various clinical classes.
*   Investigated treatment cost variances to identify instances of consistent insurance under-coverage.

### Step 4: Executive Dashboard (Power BI)
*   Built an interactive dashboard for hospital management to track KPIs (Total Encounters, Total Claim Costs, Average Patient Age).
*   Created decomposition trees to break down revenue streams by payer and encounter class.
*   Implemented geospatial mapping using patient and facility coordinates to evaluate regional access to care.

## 📊 Key Business Insights
(working.......)

## 📁 Repository Structure
*   `/SQL_Scripts` - DDL statements, table creation, and master view queries.
*   `/Python_Notebooks` - Jupyter notebooks containing data profiling and EDA.
*   `/Dashboard` - The final `.pbix` Power BI file and PDF exports.
*   `/Dataset` - Data dictionary and schema documentation (Note: Raw data excluded due to size/privacy constraints).

## 💡 How to Run This Project
1. Clone the repository to your local machine.
2. Execute the scripts in the `/SQL_Scripts` folder within SSMS to generate the schema.
3. Open the Jupyter Notebook to review the statistical analysis.
4. Open the `.pbix` file in Power BI Desktop and update the SQL Server data source credentials to interact with the dashboard.
