# Enterprise HR Analytics Platform: End-to-End Talent & Compensation Pipeline

## 📌 Project Overview
This repository contains an end-to-end enterprise HR Analytics solution that transforms millions of raw, unstructured workforce records into an executive-grade strategic dashboard. The project bridges the gap between data engineering and business strategy by moving organizations from reactive reporting to proactive talent management. 

By combining **Python** for robust data engineering, **SQL** for centralized data modeling, and **Power BI (DAX)** for predictive visualization, this platform delivers deep business insights into workforce scale, market pay equity, predictive attrition risk, and system data quality.

---

## 📁 Project Structure

```text
hr-analytics/
│
├── raw/
│   └── hr_raw.csv
│
├── dashboard/
│   └── hr_analytics.pbix
│
├── scripts/
│   ├── data_cleaning_pandas.ipynb
│   ├── create_schema.sql
│   └── create_views.sql
│
└── dax_measure.md
│
└── README.md
```

---

## 🏗️ Architecture & Data Pipeline
The project follows a standard three-tier data architecture to ensure data integrity and dashboard performance:

1. **Ingestion & Data Engineering (Python):** Processed millions of raw transactional rows, handled missing values, enforced data types, and executed structural logic checks (e.g., age-to-tenure consistency).
2. **Data Modeling (SQL):** Consolidated cleaned tables into a single, comprehensive 45-column "Gold" master table (`hr_record`) and created a 29-column master view (`vw_hr_workforce`). This flat-table design eliminated many-to-many relationship risks and optimized query performance within Power BI.
3. **Analytical Layer (DAX):** Developed dynamic business metrics featuring time-intelligence tracking, data-quality rates, and scenario-based budget parameters.

---

## 🛠️ Tech Stack & Skills Showcased
* **Languages:** Python (NumPy, Pandas, SQLAlchemy), SQL
* **BI & Analytics:** Power BI Desktop, DAX (Data Analysis Expressions)
* **Methodologies:** Data Modeling (Star Schema/Flat-Table Optimization), ETL/ELT Pipelines, Quantitative HR Research, Portfolio Governance

---

## 📈 Dashboard Architecture & Insights

The finalized Power BI dashboard is segmented into four dedicated, highly targeted pages designed for cross-functional business leaders:

### Page 1: Workforce Overview
*Target Audience: Executive Leadership & Operations*
* **Core Metrics:** Total Headcount, Active Headcount, Average Years of Service, Experience Mix, and New Hires (Last 90 Days).
* **Key Visuals:** Staffing Distribution by Department (Donut Chart), Employee Experience & Tenure Breakdown (Clustered Bar Chart), and Global Employee Locations (Geographic Map).

### Page 2: Compensation & Internal Equity
*Target Audience: Comp & Benefits, CFO, HR Business Partners*
* **Core Metrics:** Average Salary, Market Pay Alignment Index (Target Compa-Ratio: 1.0), and Percentage of Workforce Below Market Pay Rate.
* **Key Visuals:** Detailed Salary Review by Role and Level (Conditional Formatting Matrix), Internal Salaries vs. Market Value (Clustered Column Chart), and Underpaid Staff Concentration (Donut Chart).

### Page 3: Talent Risk & Attrition (Predictive Zone)
*Target Audience: Chief Human Resources Officer (CHRO) & Business Unit Directors*
* **Core Metrics:** Overall Turnover Risk Rate, High-Risk Headcount, and Urgent: High-Performing Employees at Risk (Regrettable Loss Count).
* **Key Visuals:** Employee Performance vs. Resignation Risk (9-Box Matrix Grid), Turnover Risk by Years of Service (Column Chart), and **Pay Compression Impact: Correlation Between Compensation Gaps and Flight Risk (Scatter Plot)**.

### Page 4: Data Quality & Integrity (The Audit Room)
*Target Audience: HR Operations & Data Governance Teams*
* **Core Metrics:** Overall System Data Accuracy Score, Incomplete Employee Files, and Missing Performance Reviews.
* **Key Visuals:** Data Clean-Up List (Actionable Detailed Log for HRIS updates) and Missing Appraisals by Department (Bar Chart).

---

## ⚙️ Technical Governance & AI Co-Piloting
This project was developed using a modern, AI-augmented software engineering workflow. Generative AI was leveraged as an architectural co-pilot for rapid structural prototyping, framework drafting, and DAX optimization.

To ensure enterprise-grade reliability, a strict **Human-in-the-Loop validation** methodology was applied:
* **Code Ownership:** Every script, schema layout, and pipeline calculation was independently reviewed, refactored, and verified.
* **Defensive Debugging:** Actively diagnosed and resolved syntax limitations (e.g., overriding nested summary tables to construct a single high-performance "Gold" view) to guarantee data accuracy.
* **Business Strategy Alignment:** Customized abstract parameters into specialized corporate KPIs (such as converting turnover counts into *Turnover Financial Exposure* metrics based on a 1.5x salary placement cost benchmark), proving data viability to C-suite stakeholders.

---

## 🚀 How to Review This Project
1. **Data Pipeline Logic:** Review the `/scripts` directory to inspect the Python cleaning logic and SQL view execution scripts.
2. **Data Model:** Open the `.pbix` file to examine the data architecture and see how the `vw_hr_workforce` flat view interacts seamlessly with the canvas.
3. **DAX Portfolio:** Navigate to the `/dax_measures.md` file for an indexed library of all calculated measures used across the dashboard pages.
