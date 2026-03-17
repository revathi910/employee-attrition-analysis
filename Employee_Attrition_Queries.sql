-- ============================================================
-- EMPLOYEE ATTRITION ANALYSIS — SQL QUERIES
-- Dataset : IBM HR Analytics Attrition Dataset
-- Tool    : MySQL / SQLite / PostgreSQL (all compatible)
-- Author  : Your Name
-- ============================================================


-- ============================================================
-- STEP 0 — CREATE TABLE
-- Run this first to set up the database table
-- ============================================================
CREATE TABLE IF NOT EXISTS employees (
    EmployeeNumber   INT PRIMARY KEY,
    Age              INT,
    Attrition        VARCHAR(5),
    Attrition_Flag   INT,          -- 1 = Left, 0 = Stayed
    Department       VARCHAR(50),
    JobRole          VARCHAR(60),
    MonthlyIncome    INT,
    Salary_Band      VARCHAR(20),  -- Low / Mid / High / Executive
    Age_Group        VARCHAR(20),  -- Under 30 / 30-39 / 40-49 / 50+
    JobSatisfaction  INT,          -- 1=Low, 2=Medium, 3=High, 4=Very High
    OverTime         VARCHAR(5),   -- Yes / No
    WorkLifeBalance  INT,          -- 1=Bad, 2=Good, 3=Better, 4=Best
    YearsAtCompany   INT,
    Gender           VARCHAR(10),
    MaritalStatus    VARCHAR(15)
);


-- ============================================================
-- QUERY 1 — OVERALL ATTRITION RATE
-- Business Q: What % of our workforce has left?
-- Expected  : ~16.12% attrition rate
-- ============================================================
SELECT
    COUNT(*)                                    AS total_employees,
    SUM(Attrition_Flag)                         AS total_attrition,
    ROUND(AVG(Attrition_Flag) * 100, 2)        AS attrition_rate_pct
FROM employees;


-- ============================================================
-- QUERY 2 — ATTRITION BY DEPARTMENT
-- Business Q: Which department loses the most employees?
-- Expected  : Sales = 20.6% (highest)
-- ============================================================
SELECT
    Department,
    COUNT(*)                                    AS total_employees,
    SUM(Attrition_Flag)                         AS attrition_count,
    ROUND(AVG(Attrition_Flag) * 100, 2)        AS attrition_rate_pct
FROM employees
GROUP BY Department
ORDER BY attrition_rate_pct DESC;


-- ============================================================
-- QUERY 3 — ATTRITION BY SALARY BAND
-- Business Q: Do lower-paid employees leave more?
-- Expected  : Low band = ~29%, Executive = ~5%
-- ============================================================
SELECT
    Salary_Band,
    COUNT(*)                                    AS employees,
    SUM(Attrition_Flag)                         AS left_count,
    ROUND(AVG(Attrition_Flag) * 100, 2)        AS attrition_pct,
    ROUND(AVG(MonthlyIncome), 0)                AS avg_monthly_income
FROM employees
GROUP BY Salary_Band
ORDER BY
    CASE Salary_Band
        WHEN 'Low'       THEN 1
        WHEN 'Mid'       THEN 2
        WHEN 'High'      THEN 3
        WHEN 'Executive' THEN 4
    END;


-- ============================================================
-- QUERY 4 — OVERTIME IMPACT ON ATTRITION
-- Business Q: Does overtime increase chance of leaving?
-- Expected  : Overtime Yes = ~30%, No = ~10%
-- ============================================================
SELECT
    OverTime,
    COUNT(*)                                    AS employees,
    SUM(Attrition_Flag)                         AS left_count,
    ROUND(AVG(Attrition_Flag) * 100, 2)        AS attrition_pct
FROM employees
GROUP BY OverTime
ORDER BY attrition_pct DESC;


-- ============================================================
-- QUERY 5 — JOB SATISFACTION VS ATTRITION
-- Business Q: Does low satisfaction lead to leaving?
-- Expected  : Satisfaction 1 = ~22%, Satisfaction 4 = ~11%
-- ============================================================
SELECT
    JobSatisfaction,
    CASE JobSatisfaction
        WHEN 1 THEN 'Low'
        WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'High'
        WHEN 4 THEN 'Very High'
    END                                         AS satisfaction_label,
    COUNT(*)                                    AS employees,
    SUM(Attrition_Flag)                         AS left_count,
    ROUND(AVG(Attrition_Flag) * 100, 2)        AS attrition_pct
FROM employees
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;


-- ============================================================
-- QUERY 6 — AGE GROUP VS ATTRITION
-- Business Q: Which age group is most at risk?
-- Expected  : Under 30 = ~26% attrition
-- ============================================================
SELECT
    Age_Group,
    COUNT(*)                                    AS employees,
    SUM(Attrition_Flag)                         AS left_count,
    ROUND(AVG(Attrition_Flag) * 100, 2)        AS attrition_pct,
    ROUND(AVG(MonthlyIncome), 0)                AS avg_salary
FROM employees
GROUP BY Age_Group
ORDER BY attrition_pct DESC;


-- ============================================================
-- QUERY 7 — JOB ROLE ATTRITION (HEATMAP DATA)
-- Business Q: Which specific job roles are highest risk?
-- Expected  : Sales Rep = ~40%, Lab Technician = ~24%
-- ============================================================
SELECT
    JobRole,
    Department,
    COUNT(*)                                    AS employees,
    SUM(Attrition_Flag)                         AS attrition_count,
    ROUND(AVG(Attrition_Flag) * 100, 2)        AS attrition_pct,
    ROUND(AVG(MonthlyIncome), 0)                AS avg_monthly_income
FROM employees
GROUP BY JobRole, Department
ORDER BY attrition_pct DESC
LIMIT 10;


-- ============================================================
-- QUERY 8 — EMPLOYEE RISK SCORE (ADVANCED)
-- Business Q: Which employees are most at risk of leaving?
-- Logic     : Weighted score based on key attrition drivers
-- Score Key : 50-100 = High Risk | 20-49 = Medium | 0-19 = Low
-- ============================================================
SELECT
    EmployeeNumber,
    Department,
    JobRole,
    MonthlyIncome,
    JobSatisfaction,
    OverTime,
    YearsAtCompany,
    Attrition,
    -- Weighted Risk Score
    (
        CASE WHEN OverTime = 'Yes'         THEN 30 ELSE 0 END +
        CASE WHEN JobSatisfaction <= 2     THEN 25 ELSE 0 END +
        CASE WHEN MonthlyIncome < 3000     THEN 20 ELSE 0 END +
        CASE WHEN WorkLifeBalance <= 2     THEN 15 ELSE 0 END +
        CASE WHEN YearsAtCompany <= 2      THEN 10 ELSE 0 END
    )                                           AS risk_score,
    -- Risk Label
    CASE
        WHEN (
            CASE WHEN OverTime = 'Yes'     THEN 30 ELSE 0 END +
            CASE WHEN JobSatisfaction <= 2 THEN 25 ELSE 0 END +
            CASE WHEN MonthlyIncome < 3000 THEN 20 ELSE 0 END +
            CASE WHEN WorkLifeBalance <= 2 THEN 15 ELSE 0 END +
            CASE WHEN YearsAtCompany <= 2  THEN 10 ELSE 0 END
        ) >= 50 THEN 'HIGH RISK'
        WHEN (
            CASE WHEN OverTime = 'Yes'     THEN 30 ELSE 0 END +
            CASE WHEN JobSatisfaction <= 2 THEN 25 ELSE 0 END +
            CASE WHEN MonthlyIncome < 3000 THEN 20 ELSE 0 END +
            CASE WHEN WorkLifeBalance <= 2 THEN 15 ELSE 0 END +
            CASE WHEN YearsAtCompany <= 2  THEN 10 ELSE 0 END
        ) >= 20 THEN 'MEDIUM RISK'
        ELSE 'LOW RISK'
    END                                         AS risk_label
FROM employees
ORDER BY risk_score DESC
LIMIT 20;


-- ============================================================
-- QUERY 9 — EXECUTIVE SUMMARY (CEO-READY TABLE)
-- Business Q: One table summarising everything for leadership
-- ============================================================
SELECT
    Department,
    COUNT(*)                                    AS total_employees,
    SUM(Attrition_Flag)                         AS employees_left,
    ROUND(AVG(Attrition_Flag) * 100, 1)        AS attrition_rate_pct,
    ROUND(AVG(MonthlyIncome), 0)                AS avg_salary,
    ROUND(AVG(JobSatisfaction), 2)              AS avg_job_satisfaction,
    SUM(
        CASE WHEN OverTime = 'Yes' THEN 1 ELSE 0 END
    )                                           AS overtime_workers,
    ROUND(
        SUM(CASE WHEN OverTime = 'Yes' THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 1
    )                                           AS overtime_pct
FROM employees
GROUP BY Department
ORDER BY attrition_rate_pct DESC;


-- ============================================================
-- BONUS — GENDER ATTRITION ANALYSIS
-- ============================================================
SELECT
    Gender,
    COUNT(*)                                    AS employees,
    SUM(Attrition_Flag)                         AS left_count,
    ROUND(AVG(Attrition_Flag) * 100, 2)        AS attrition_pct
FROM employees
GROUP BY Gender;


-- ============================================================
-- BONUS — MARITAL STATUS VS ATTRITION
-- Expected  : Single employees have highest attrition (~26%)
-- ============================================================
SELECT
    MaritalStatus,
    COUNT(*)                                    AS employees,
    SUM(Attrition_Flag)                         AS left_count,
    ROUND(AVG(Attrition_Flag) * 100, 2)        AS attrition_pct,
    ROUND(AVG(MonthlyIncome), 0)                AS avg_salary
FROM employees
GROUP BY MaritalStatus
ORDER BY attrition_pct DESC;


-- ============================================================
-- END OF FILE
-- Total Queries: 9 Main + 2 Bonus = 11 Queries
-- ============================================================
