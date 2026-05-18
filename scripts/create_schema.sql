-- =========================================
-- DROP TABLE IF EXISTS (SAFE RESET)
-- =========================================
DROP TABLE IF EXISTS hr_record;


-- =========================================
-- CREATE TABLE (GOLD LAYER HR DATASET)
-- =========================================
CREATE TABLE IF NOT EXISTS hr_record (
    -- 0-7: Core Identifiers & Geography
    employee_id                TEXT PRIMARY KEY,
    full_name                  TEXT,
    department                 TEXT,
    job_title                  TEXT,
    job_level                  TEXT,
    country                    TEXT,
    city                       TEXT,
    work_mode                  TEXT,

    -- 8-13: Employment & Demographics
    hire_date                  DATE,
    status                     TEXT,
    year                       INTEGER,
    age                        INTEGER,
    prev_exp_year              INTEGER,
    salary                     NUMERIC(15, 2),

    -- 14-16: Performance Data
    performance_rating_raw     TEXT,
    performance_rating_clean   TEXT,
    performance_missing_flag   BOOLEAN,

    -- 17-19: Tenure Metrics
    tenure_total               NUMERIC(10, 2),
    tenure_active              NUMERIC(10, 2),
    tenure_band                TEXT, -- Pandas 'category' maps to TEXT

    -- 20-22: Compensation Engineering
    benchmark_salary           NUMERIC(15, 2),
    compa_ratio                NUMERIC(10, 4),
    compa_flag                 TEXT,

    -- 23-26: Statistical Outliers
    group_mean_salary          NUMERIC(15, 2),
    group_std_salary           NUMERIC(15, 2),
    salary_zscore              NUMERIC(12, 6),
    salary_outlier_flag        TEXT,

    -- 27-30: Salary Positioning & Validation
    salary_percentile          NUMERIC(5, 4),
    low_pay_flag               TEXT,
    level_expected_salary      NUMERIC(15, 2),
    level_mismatch_flag        TEXT,

    -- 31-34: Org Structure & Age Logic
    department_headcount       INTEGER,
    job_level_density          INTEGER,
    expected_age               INTEGER,
    age_validation_flag        TEXT,

    -- 35-40: Data Quality Framework
    missing_salary_flag        BOOLEAN,
    missing_performance_flag   BOOLEAN,
    invalid_age_flag           BOOLEAN,
    duplicate_employee_flag    BOOLEAN,
    data_quality_score         INTEGER,
    data_quality_flag          TEXT,

    -- 41-44: Attrition & Lineage
    attrition_risk_score       INTEGER,
    attrition_risk_flag        TEXT,
    pipeline_version           TEXT,
    load_timestamp             TIMESTAMP
);

-- Indexing for performance (Optional but recommended)
CREATE INDEX idx_hr_dept ON hr_record(department);
CREATE INDEX idx_hr_status ON hr_record(status);