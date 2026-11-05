# SQL Server Mastery Portfolio: 1,000 Production T-SQL Queries

An exhaustive, enterprise-grade SQL portfolio project consisting of **1,000 unique T-SQL queries** designed for Microsoft SQL Server Management Studio (SSMS). This repository demonstrates advanced data manipulation, relational modeling, performance tuning, and complex analytical reporting structured across **10 iterative production rounds**.

---

## Project Architecture & Methodology

To simulate real-world data evolution and operational scaling, this project utilizes an iterative architecture:
* **10 Progressive Rounds:** Each round contains a synchronized library of 100 core SQL commands.
* **Data & Parameter Evolution:** Across rounds 1 through 10, data baselines, date parameters (spanning 2024 to 2034), and aggregation thresholds dynamically shift to test query resilience against changing business environments.
* **Standardized Relational Schema:** Built on a robust 3NF relational model linking departments, personnel, customers, transactions, and inventory items.

---

## Core Schema Models

[Departments] ──< [Employees]
[Customers]   ──< [Orders] ──< [OrderItems] >── [Products]

* `dbo.Departments`: Organizational department hierarchies and metadata.
* `dbo.Employees`: Personnel records, salaries, hire dates, and reporting lines.
* `dbo.Customers`: Client profiles, regional segments, and contact details.
* `dbo.Orders`: Transaction headers, timestamps, and order statuses.
* `dbo.OrderItems`: Granular line-item quantities and unit valuations.
* `dbo.Products`: Inventory metrics, categories, pricing, cost tracking, and reorder thresholds.

---

## Technical Scope & Competencies Demonstrated

### 1. Foundations & Junior Analytics (Queries 01–50)
* Basic CRUD operations, precise filtering (`WHERE`, `IN`, `BETWEEN`, `LIKE`), and pattern matching.
* Advanced Multi-Table Joins (`INNER`, `LEFT`, `RIGHT`, `FULL OUTER`, `CROSS`, and Self-Joins).
* Aggregations (`GROUP BY`, `HAVING`) and conditional branching (`CASE WHEN`).
* Set operations (`UNION`, `UNION ALL`, `INTERSECT`, `EXCEPT`) and staging hygiene.

### 2. Advanced Mid-Level Analytics & T-SQL Engineering (Queries 51–100)
* **Window Functions:** Advanced ranking (`ROW_NUMBER`, `RANK`, `DENSE_RANK`), analytic offsets (`LAG`, `LEAD`), distribution (`NTILE`, `PERCENT_RANK`, `CUME_DIST`), and window framing (`ROWS BETWEEN`).
* **Common Table Expressions (CTEs):** Recursive queries, multi-step staging CTEs, and inline derived tables.
* **Advanced Patterns:** Anti-joins (`NOT EXISTS`), island-and-gap resolution, string parsing (`CHARINDEX`, `SUBSTRING`, `STRING_AGG`), and JSON extraction.
* **Time-Series & Financial Analytics:** Running totals, moving averages, Month-over-Month (MoM) & Year-over-Year (YoY) variance, RFM segmentation, and cohort retention tracking.
* **Data Quality & Optimization:** Automated anomaly detection (negative amounts, missing keys, duplicates), execution plan profiling (`SET STATISTICS IO/TIME`), index optimization, and transaction safety (`BEGIN TRANSACTION`, `COMMIT`/`ROLLBACK`).

---

## Getting Started

1. Open **SQL Server Management Studio (SSMS)**.
2. Select any round script (e.g., `Round10.sql`) to initialize the isolated mock database and seed tables.
3. Execute queries individually or in blocks to inspect analytical outputs and execution plans.