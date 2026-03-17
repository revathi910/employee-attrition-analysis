# 📊 Employee Attrition Analysis — HR Analytics Project

> **Tools Used:** Excel · SQL · Power BI  
> **Dataset:** IBM HR Analytics Attrition Dataset (1,470 employees, 35 columns)  
> **Goal:** Identify why employees leave and which departments are at highest risk

---

## 🎯 Business Problem

Employee attrition costs companies 50–200% of an employee's annual salary to replace them. This project analyzes the IBM HR dataset to:
- Find the **overall attrition rate**
- Identify **which departments** lose the most staff
- Discover **key drivers** of attrition (salary, overtime, satisfaction)
- Build an **employee risk score** to flag at-risk employees proactively

---

## 📁 Project Files

| File | Description |
|------|-------------|
| `Employee_Attrition_Template.xlsx` | Cleaned dataset with calculated columns + summary analysis |
| `Employee_Attrition_Queries.sql` | 9 SQL queries covering all attrition dimensions |
| `Employee_Attrition_Guide.docx` | Full step-by-step project guide |
| `dashboard_screenshot.png` | Power BI dashboard (add your screenshot here) |

---

## 🔧 Tools & Steps

### Step 1 — Excel (Data Cleaning)
- Loaded raw CSV (1,470 rows × 35 columns)
- Created new calculated columns:
  - `Attrition_Flag` — converts Yes/No to 1/0 for calculations
  - `Age_Group` — buckets employees into Under 30 / 30-39 / 40-49 / 50+
  - `Salary_Band` — Low / Mid / High / Executive
  - `Risk_Score` — weighted score based on 5 attrition risk factors
- Applied conditional formatting (red rows = employees who left)
- Built pivot table summary by department

### Step 2 — SQL (Analysis)
Ran 9 queries to answer key business questions:

```sql
-- Example: Attrition by department
SELECT
    Department,
    COUNT(*)                              AS total_employees,
    SUM(Attrition_Flag)                   AS attrition_count,
    ROUND(AVG(Attrition_Flag) * 100, 2)  AS attrition_rate_pct
FROM employees
GROUP BY Department
ORDER BY attrition_rate_pct DESC;
```

### Step 3 — Power BI (Dashboard)
Built a 6-visual interactive dashboard:
- 📌 KPI Cards (Total Employees, Attrition Count, Rate %, Avg Salary)
- 📊 Bar Chart — Attrition by Department
- 🌡️ Heatmap Matrix — Job Role vs Department
- 🍩 Donut Chart — Yes vs No attrition split
- ⭕ Scatter Plot — Monthly Income vs Job Satisfaction
- 📶 Stacked Bar — Overtime impact on attrition

---

## 📈 Key Findings

| # | Finding | Impact |
|---|---------|--------|
| 1 | **Sales dept has 20.6% attrition** — highest of all departments | Sales Reps alone have ~40% turnover |
| 2 | **Overtime employees are 3× more likely to leave** (30% vs 10%) | Strongest single predictor in dataset |
| 3 | **Low salary band = 29% attrition** vs 5% for Executive band | Compensation drives early exits |
| 4 | **Under-30 employees have 26% attrition** — double company average | Early-career retention needs attention |
| 5 | **Low job satisfaction (score 1) = 22% attrition** vs 11% for score 4 | Engagement programs could reduce this |

---

## 💡 Recommendations

1. **Cap overtime hours** for Sales team — this is the fastest, cheapest intervention
2. **Salary band review** — target Low band employees with compensation adjustments
3. **Mentorship program** for Under-30 employees to improve retention
4. **Monthly pulse surveys** to catch low-satisfaction employees early
5. **Use the Risk Score model** to flag high-risk employees for proactive HR outreach

---

## 🗄️ SQL Queries Summary

| Query | Business Question |
|-------|------------------|
| Q1 | Overall attrition rate |
| Q2 | Attrition by department |
| Q3 | Attrition by salary band |
| Q4 | Overtime impact |
| Q5 | Job satisfaction analysis |
| Q6 | Age group analysis |
| Q7 | Job role heatmap data |
| Q8 | Employee risk score model |
| Q9 | Executive summary table |

---

## 📦 Dataset

**Source:** [IBM HR Analytics Attrition Dataset — Kaggle](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset)

| Detail | Value |
|--------|-------|
| Rows | 1,470 employees |
| Columns | 35 features |
| Attrition Rate | ~16.12% |
| File Format | CSV |

---

## 🚀 How to Run

1. **Download** the dataset from Kaggle link above
2. **Open** `Employee_Attrition_Template.xlsx` to see the cleaned data
3. **Import** the CSV into MySQL / SQLite and run `Employee_Attrition_Queries.sql`
4. **Open** Power BI Desktop → Get Data → connect to the Excel file
5. **Build** the dashboard following the guide in `Employee_Attrition_Guide.docx`

---

## 👤 Author

**Your Name**  
Aspiring Data Analyst | Excel · SQL · Power BI  
📧 your.email@example.com  
🔗 [LinkedIn Profile](https://linkedin.com/in/yourprofile)

---

*This project was built for portfolio and interview preparation purposes using a publicly available dataset.*
