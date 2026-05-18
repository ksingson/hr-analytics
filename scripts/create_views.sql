-- /* 
-- VIEW: vw_hr_workforce
-- PURPOSE: Provides a comprehensive profile of every employee record.
-- SIGNIFICANCE: 
-- - Includes both 'performance_rating_raw' (for audit) and 'performance_rating_clean' (for BI tools).
-- - Combines identity, compensation, and risk metrics in one row for rapid lookup.
-- */
DROP VIEW IF EXISTS vw_hr_workforce;

CREATE OR REPLACE VIEW vw_hr_workforce AS
SELECT
    employee_id, full_name, department, job_title, job_level,
    country, city, work_mode, hire_date, status, age,
    prev_exp_year, tenure_total, tenure_active, tenure_band,
    salary, benchmark_salary, compa_ratio, compa_flag,
    performance_rating_raw,      -- Kept to track the original source data
    performance_rating_clean,    -- Standardized 'Unrated' for dashboard consistency
    performance_missing_flag,
    attrition_risk_score, attrition_risk_flag,
	age_validation_flag,
    data_quality_score, data_quality_flag,
    pipeline_version, load_timestamp
FROM hr_record;



-- /* 
-- VIEW: vw_hr_current_workforce
-- PURPOSE: Filters out historical or terminated records.
-- SIGNIFICANCE: 
-- - Essential for 'Point-in-Time' reporting. 
-- - Prevents over-counting headcount by excluding former employees.
-- */
DROP VIEW IF EXISTS vw_hr_current_workforce;

CREATE OR REPLACE VIEW vw_hr_current_workforce AS
SELECT *
FROM hr_record
WHERE status = 'Active';



-- /* 
-- VIEW: vw_hr_attrition_risk
-- PURPOSE: Aggregates rule-based risk signals by Department and Level.
-- SIGNIFICANCE: 
-- - Uses 'attrition_risk_score' to show the intensity of risk.
-- - High-risk clusters in specific departments may indicate leadership or cultural issues.
-- */
DROP VIEW IF EXISTS vw_hr_attrition_risk;

CREATE OR REPLACE VIEW vw_hr_attrition_risk AS
SELECT
    department, job_level,
    COUNT(employee_id) AS total_employees,
    SUM(CASE WHEN attrition_risk_flag = 'High Risk' THEN 1 ELSE 0 END) AS high_risk_count,
    SUM(CASE WHEN attrition_risk_flag = 'Medium Risk' THEN 1 ELSE 0 END) AS medium_risk_count,
    SUM(CASE WHEN attrition_risk_flag = 'Low Risk' THEN 1 ELSE 0 END) AS low_risk_count,
    ROUND(AVG(attrition_risk_score)::NUMERIC, 2) AS avg_risk_score
FROM hr_record
GROUP BY department, job_level;



-- /* 
-- VIEW: vw_hr_compensation_analysis
-- PURPOSE: Compares actual salary against the internal 'benchmark_salary' (median).
-- SIGNIFICANCE: 
-- - 'avg_compa_ratio': A value < 1.0 suggests the department is paid below the internal median.
-- - 'underpaid_count': Flags individuals at risk of leaving for better pay elsewhere.
-- */
DROP VIEW IF EXISTS vw_hr_compensation_analysis;

CREATE OR REPLACE VIEW vw_hr_compensation_analysis AS
SELECT
    department, job_level,
    COUNT(employee_id) AS headcount,
    ROUND(AVG(salary)::NUMERIC, 2),
    ROUND(AVG(benchmark_salary)::NUMERIC, 2) AS avg_benchmark,
    SUM(CASE WHEN compa_flag = 'Underpaid' THEN 1 ELSE 0 END) AS underpaid_count,
    SUM(CASE WHEN compa_flag = 'Overpaid' THEN 1 ELSE 0 END) AS overpaid_count,
    SUM(CASE WHEN compa_flag = 'Fair' THEN 1 ELSE 0 END) AS fair_count,
    ROUND(AVG(compa_ratio)::NUMERIC, 3) AS avg_compa_ratio
FROM hr_record
GROUP BY department, job_level;



-- /* 
-- VIEW: vw_hr_data_quality
-- PURPOSE: Monitors the health of the HRIS database.
-- SIGNIFICANCE: 
-- - 'duplicate_count': Detects system sync errors.
-- - 'logical_age_errors': Catches 'Impossible' data (e.g., 20-year-olds with 10 years experience).
-- - Vital for the IT/HR Ops team to perform weekly data cleaning.
-- */
DROP VIEW IF EXISTS vw_hr_data_quality;

CREATE OR REPLACE VIEW vw_hr_data_quality AS
SELECT
    department, job_level,
    COUNT(employee_id) AS total_records,
    SUM(CASE WHEN data_quality_flag = 'High Quality' THEN 1 ELSE 0 END) AS high_quality,
    SUM(CASE WHEN data_quality_flag = 'Medium Quality' THEN 1 ELSE 0 END) AS medium_quality,
    SUM(CASE WHEN data_quality_flag = 'Low Quality' THEN 1 ELSE 0 END) AS low_quality,
    ROUND(AVG(data_quality_score)::NUMERIC, 2) AS avg_quality_score,
    SUM(CASE WHEN missing_salary_flag THEN 1 ELSE 0 END) AS missing_salary_count,
    SUM(CASE WHEN missing_performance_flag THEN 1 ELSE 0 END) AS missing_performance_count,
    SUM(CASE WHEN invalid_age_flag THEN 1 ELSE 0 END) AS invalid_age_count,
    SUM(CASE WHEN duplicate_employee_flag THEN 1 ELSE 0 END) AS duplicate_count,
    SUM(CASE WHEN age_validation_flag != 'Valid' THEN 1 ELSE 0 END) AS logical_age_errors
FROM hr_record
GROUP BY department, job_level;



-- /* 
-- VIEW: vw_hr_tenure_analysis
-- PURPOSE: Segments employees by their lifecycle stage (New, Junior, Senior, etc.).
-- SIGNIFICANCE: 
-- - Helps identify 'Flight Risk' for mid-tenure employees.
-- - Assists in succession planning by identifying the senior workforce nearing retirement.
-- */
DROP VIEW IF EXISTS vw_hr_tenure_analysis;

CREATE OR REPLACE VIEW vw_hr_tenure_analysis AS
SELECT
    department, job_level, tenure_band,
    COUNT(employee_id) AS employee_count,
    ROUND(AVG(tenure_total)::NUMERIC, 2) AS avg_tenure
FROM hr_record
GROUP BY department, job_level, tenure_band;