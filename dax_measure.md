# DAX Measures Library

This document compiles the core business logic and calculations engineered for the HR Analytics Platform.

## 📊 Page 1: Workforce Overview

### Active Headcount
```dax
Active Headcount = CALCULATE(
    COUNT(vw_hr_workforce[employee_id]), 
    vw_hr_workforce[status] = "Active"
)
```

```dax
Active Headcount % = DIVIDE(
  [Active Headcount],
  [Total Headcount]
)
```

```dax
Avg Tenure = AVERAGE('vw_hr_workforce'[tenure_total])
```

```dax
New Hires = CALCULATE(
  [Total Headcount], 
  'vw_hr_workforce'[tenure_band] = "New (<3m)"
)
```

```dax
Total Headcount = DISTINCTCOUNT('vw_hr_workforce'[employee_id])
```

## 📊 Page 2: Compensation and Internal Equity

```dax
_diff Salary vs Benchmark % = DIVIDE(
    [Avg Salary] - [Avg Benchmark Salary],
    [Avg Benchmark Salary]
)
```

```dax
Avg Benchmark Salary = AVERAGE(vw_hr_workforce[benchmark_salary])
```

```dax
Avg Compa-Ratio = AVERAGE('vw_hr_workforce'[compa_ratio])
```

```dax
Avg Salary = AVERAGE(vw_hr_workforce[salary])
```

```dax
Equity Risk Percentage = DIVIDE(
    [Underpaid Population], 
    [Active Headcount]
)
```

```dax
Outlier Count = CALCULATE(
  [Total Headcount], 
  vw_hr_workforce[compa_flag] IN {"Underpaid", "Overpaid"}
)
```

```dax
Underpaid Population = CALCULATE(
  [Total Headcount], 
  'vw_hr_workforce'[compa_flag] = "Underpaid"
)
```

## 📊 Page 3: Talent Risk and Attrition

```dax
Avg Risk Score = AVERAGE('vw_hr_workforce'[attrition_risk_score])
```

```dax
Flight Risk Percentage = DIVIDE(
  [High-Risk Headcount], 
  [Active Headcount]
)
```

```dax
High-Risk Headcount = CALCULATE(
  [Total Headcount], 
  'vw_hr_workforce'[attrition_risk_flag] = "High Risk"
)
```

```dax
Regrettable Loss = CALCULATE(
    [Total Headcount], 
    vw_hr_workforce[attrition_risk_flag] = "High Risk",
    vw_hr_workforce[performance_rating_clean] IN {"Excellent", "Good"}
)
```

## 📊 Page 4: Data Quality and Integrity

```dax
Data Health Percentage = DIVIDE(
    CALCULATE(
      [Total Headcount], 
      'vw_hr_workforce'[data_quality_flag] = "High Quality"
    ),
    [Total Headcount]
)
```

```dax
Data Integrity Rate = AVERAGE(vw_hr_workforce[data_quality_score])
```

```dax
Logical Age Discrepancies = CALCULATE(
  [Total Headcount], 
  vw_hr_workforce[age_validation_flag] <> "Valid"
)
```

```dax
Low Quality Anomalies = CALCULATE(
  [Total Headcount], 
  vw_hr_workforce[data_quality_flag] = "Low Quality"
)
```

```dax
Missing Performance Ratings = CALCULATE(
  [Total Headcount], 
  vw_hr_workforce[performance_missing_flag] = TRUE
)
```

## 📊 Custom Scatter Plot Y-axis

```dax
_scatter_custom_axis = Row("Colu
```

```dax
max_y = MAXX(ALL(vw_hr_workforce[department]), [Avg Risk Score]) * 1.005
```

```dax
min_y = MINX(ALL(vw_hr_workforce[department]), [Avg Risk Score]) * 0.995
```

## 📊 Date Table Creation

```dax
_dateTable = 
VAR MinYear = YEAR(MIN(vw_hr_workforce[hire_date]))
VAR MaxYear = YEAR(TODAY()) -- Or use MAX(load_timestamp)
RETURN
ADDCOLUMNS (
    CALENDAR(DATE(MinYear, 1, 1), DATE(MaxYear, 12, 31)),
    "Year", YEAR([Date]),
    "Month Name", FORMAT([Date], "MMMM"),
    "Month Number", MONTH([Date]),
    "Quarter", "Q" & FORMAT([Date], "Q"),
    "Year Month", FORMAT([Date], "YYYY-MM"),
    "Year Month Sort", YEAR([Date]) * 100 + MONTH([Date])
)
```

## 📊 Sort Table Creation

```dax
_sort_compa = DATATABLE(
    "Compa-ratio Flag", STRING,
    "SortOrder", INTEGER,
    {
        {"Underpaid", 1},
        {"Fair", 2},
        {"Overpaid", 3}
    }
)
```

```dax
_sort_level = DATATABLE(
    "Job Level", STRING,
    "SortOrder", INTEGER,
    {
        {"Junior", 1},
        {"Mid", 2},
        {"Senior", 3},
        {"Director", 4}
    }
)
```

```dax
_sort_rating = DATATABLE(
    "Performance Rating", STRING,
    "SortOrder", INTEGER,
    {
        {"Excellent", 1},
        {"Good", 2},
        {"Satisfactory", 3},
        {"Needs Improvement", 4},
        {"Unrated", 5}
    }
)
```

```dax
_sort_tenure = DATATABLE(
    "Tenure Band", STRING,
    "SortOrder", INTEGER,
    {
        {"New (<3m)", 1},
        {"Early", 2},
        {"Junior", 3},
        {"Mid", 4},
        {"Senior", 5}
    }
)
```
