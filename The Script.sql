-- ============================================================================
-- SQL MASTERY PROJECT: ROUND 1 (QUERIES 1–100)
-- Description: Foundation, CRUD, Filtering, Joins, Aggregations & Basic Analytics.
-- ============================================================================

CREATE DATABASE SQLMastery_Round1;
GO
USE SQLMastery_Round1;
GO

-- ============================================================================
-- SETUP BLOCK: MOCK TABLES & SAMPLE DATA
-- ============================================================================
CREATE TABLE departments (id INT PRIMARY KEY, dept_name VARCHAR(50));
CREATE TABLE employees (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    name VARCHAR(100),
    department VARCHAR(50),
    dept_id INT FOREIGN KEY REFERENCES departments(id),
    salary DECIMAL(10,2),
    manager_id INT,
    hire_date DATE,
    job_title VARCHAR(50),
    gender VARCHAR(10),
    status VARCHAR(20)
);

CREATE TABLE customers (id INT PRIMARY KEY, name VARCHAR(50), city VARCHAR(50), created_at DATE);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    id INT,
    customer_id INT FOREIGN KEY REFERENCES customers(id),
    amount DECIMAL(10,2),
    order_date DATE,
    shipped_date DATE,
    status VARCHAR(20)
);

CREATE TABLE products (product_id INT PRIMARY KEY, id INT, name VARCHAR(50), category VARCHAR(50), price DECIMAL(10,2));
CREATE TABLE colors (color_name VARCHAR(50));
CREATE TABLE suppliers (id INT PRIMARY KEY, city VARCHAR(50));
CREATE TABLE store_a (product_id INT);
CREATE TABLE store_b (product_id INT);
CREATE TABLE staging_logs (log_id INT);
CREATE TABLE users (id INT PRIMARY KEY, email VARCHAR(100), created_at DATE, status VARCHAR(20), phone VARCHAR(20), mobile VARCHAR(20));
CREATE TABLE contacts (contact_id INT, phone_number VARCHAR(20));
CREATE TABLE projects (project_id INT, start_date DATE, end_date DATE);
CREATE TABLE metrics (metric_id INT, actual_val DECIMAL(10,2), target_val DECIMAL(10,2), col1 DECIMAL(10,2), col2 DECIMAL(10,2));
CREATE TABLE sales (sale_id INT, order_date DATE, amount DECIMAL(10,2));
CREATE TABLE sequence_table (val INT);
CREATE TABLE ids (id INT);
CREATE TABLE categories (id INT PRIMARY KEY, name VARCHAR(50), parent_id INT);
CREATE TABLE staging (id INT, string_val VARCHAR(50));

-- Seed sample data
INSERT INTO departments VALUES (1, 'IT'), (2, 'HR'), (3, 'Finance'), (4, 'Sales');
INSERT INTO employees (id, first_name, last_name, name, department, dept_id, salary, manager_id, hire_date, job_title, gender, status) VALUES 
(1, 'John', 'Doe', 'John Doe', 'IT', 1, 75000.00, NULL, '2023-01-15', 'Developer', 'M', 'Active'),
(2, 'Jane', 'Smith', 'Jane Smith', 'HR', 2, 65000.00, 1, '2022-05-10', 'Manager', 'F', 'Active');
INSERT INTO customers VALUES (1, 'Alice Corp', 'New York', '2024-01-01'), (2, 'Beta LLC', 'Chicago', '2024-02-01');
INSERT INTO orders VALUES (101, 1, 1, 550.00, '2026-01-10', '2026-01-12', 'Completed');
INSERT INTO products VALUES (1, 101, 'Mouse', 'Electronics', 29.99), (2, 102, 'Keyboard', 'Electronics', 89.50);
INSERT INTO colors VALUES ('Red'), ('Blue');
INSERT INTO suppliers VALUES (1, 'New York'), (2, 'Chicago');
INSERT INTO store_a VALUES (1), (2);
INSERT INTO store_b VALUES (2);
INSERT INTO staging_logs VALUES (101);
INSERT INTO users VALUES (1, 'john@gmail.com', '2026-01-10', 'Active', '555-0101', '555-0201');
INSERT INTO contacts VALUES (1, '555-0101');
INSERT INTO projects VALUES (1, '2026-01-01', '2026-06-30');
INSERT INTO metrics VALUES (1, 150.50, 140.00, 10.5, 20.0);
INSERT INTO sales VALUES (1, '2026-01-01', 150.00), (2, '2026-01-02', 300.50);
INSERT INTO sequence_table VALUES (1), (2), (3), (5);
INSERT INTO ids VALUES (1), (2), (4);
INSERT INTO categories VALUES (1, 'Electronics', NULL), (2, 'Laptops', 1);
INSERT INTO staging VALUES (1, '123.45');
GO

-- ============================================================================
-- PART 1: JUNIOR FOUNDATIONS & BASIC SELECT QUERIES (Queries 1–50)
-- ============================================================================

-- 1. Retrieves every column and row from the employees table.
SELECT * FROM employees;

-- 2. Selects only specific columns to reduce data transfer overhead.
SELECT first_name, last_name FROM employees;

-- 3. Filters rows using a WHERE condition for a specific department.
SELECT * FROM employees WHERE department = 'IT';

-- 4. Combines multiple conditions using AND (both must be true).
SELECT * FROM employees WHERE department = 'IT' AND salary > 60000;

-- 5. Combines conditions using OR (at least one must be true).
SELECT * FROM employees WHERE department = 'IT' OR department = 'HR';

-- 6. Excludes rows matching a condition using NOT.
SELECT * FROM employees WHERE NOT department = 'HR';

-- 7. Removes duplicate rows from the result set using DISTINCT.
SELECT DISTINCT department FROM employees;

-- 8. Sorts query results in ascending order.
SELECT * FROM employees ORDER BY salary ASC;

-- 9. Sorts query results in descending order.
SELECT * FROM employees ORDER BY salary DESC;

-- 10. Limits output rows using T-SQL TOP keyword.
SELECT TOP 10 * FROM employees;

-- 11. Implements pagination using OFFSET and FETCH NEXT in SQL Server.
SELECT * FROM employees ORDER BY employee_id OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- 12. Filters records matching any value within a specified list using IN.
SELECT * FROM employees WHERE department IN ('IT', 'HR', 'Finance');

-- 13. Excludes records matching a list using NOT IN.
SELECT * FROM employees WHERE department NOT IN ('Sales', 'Marketing');

-- 14. Filters numerical or date ranges inclusively using BETWEEN.
SELECT * FROM employees WHERE salary BETWEEN 50000 AND 80000;

-- 15. Performs wildcard pattern matching for strings starting with 'J'.
SELECT * FROM employees WHERE first_name LIKE 'J%';

-- 16. Performs wildcard matching for strings ending with 'son'.
SELECT * FROM employees WHERE first_name LIKE '%son';

-- 17. Performs wildcard matching for strings containing 'an'.
SELECT * FROM employees WHERE first_name LIKE '%an%';

-- 18. Filters records where a column explicitly contains NULL.
SELECT * FROM employees WHERE manager_id IS NULL;

-- 19. Filters records where a column contains a valid value (Not Null).
SELECT * FROM employees WHERE manager_id IS NOT NULL;

-- 20. Combines two tables based on a matching column using INNER JOIN.
SELECT e.name, d.dept_name FROM employees e INNER JOIN departments d ON e.dept_id = d.id;

-- 21. Retrieves all records from the left table and matched from the right via LEFT JOIN.
SELECT c.name, o.order_id FROM customers c LEFT JOIN orders o ON c.id = o.customer_id;

-- 22. Retrieves all records from the right table and matched from the left via RIGHT JOIN.
SELECT e.name, d.dept_name FROM employees e RIGHT JOIN departments d ON e.dept_id = d.id;

-- 23. Returns all records when a match exists in either left or right table using FULL OUTER JOIN.
SELECT a.col1, b.col2 FROM metrics a FULL OUTER JOIN metrics b ON a.metric_id = b.metric_id;

-- 24. Produces a Cartesian product combining all rows from both tables using CROSS JOIN.
SELECT * FROM products CROSS JOIN colors;

-- 25. Joins a table to itself to establish hierarchical relationships (e.g., Employee-Manager).
SELECT e.name AS employee, m.name AS manager FROM employees e LEFT JOIN employees m ON e.manager_id = m.id;

-- 26. Counts total number of rows in a table.
SELECT COUNT(*) FROM employees;

-- 27. Counts non-null values within a specific column.
SELECT COUNT(email) FROM users;

-- 28. Calculates the total sum of a numeric column.
SELECT SUM(salary) FROM employees WHERE department = 'IT';

-- 29. Calculates the mathematical average of a column.
SELECT AVG(salary) FROM employees;

-- 30. Finds the lowest value in a column.
SELECT MIN(salary) FROM employees;

-- 31. Finds the highest value in a column.
SELECT MAX(salary) FROM employees;

-- 32. Aggregates rows into groups by a single column.
SELECT department, COUNT(*) FROM employees GROUP BY department;

-- 33. Aggregates rows across multiple grouping columns.
SELECT department, job_title, COUNT(*) FROM employees GROUP BY department, job_title;

-- 34. Filters aggregated results using HAVING.
SELECT department, AVG(salary) FROM employees GROUP BY department HAVING AVG(salary) > 70000;

-- 35. Applies conditional logic inline using CASE WHEN.
SELECT name, salary, CASE WHEN salary > 80000 THEN 'High' ELSE 'Normal' END AS salary_tier FROM employees;

-- 36. Combines result sets of two queries and removes duplicates using UNION.
SELECT city FROM customers UNION SELECT city FROM suppliers;

-- 37. Combines result sets including duplicates using UNION ALL.
SELECT city FROM customers UNION ALL SELECT city FROM suppliers;

-- 38. Returns only common records present in both queries using INTERSECT.
SELECT product_id FROM store_a INTERSECT SELECT product_id FROM store_b;

-- 39. Returns records from the first query that are absent in the second using EXCEPT.
SELECT product_id FROM store_a EXCEPT SELECT product_id FROM store_b;

-- 40. Renames columns in the output display using column aliases.
SELECT first_name AS fname, last_name AS lname FROM employees;

-- 41. Assigns a temporary alias to a table for concise queries.
SELECT emp.id FROM employees AS emp;

-- 42. Concatenates strings together in T-SQL.
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM employees;

-- 43. Generates inline virtual table rows using the VALUES constructor.
SELECT * FROM (VALUES (1, 'Alice', 50000)) AS t(id, name, salary);

-- 44. Modifies existing data records based on a condition.
UPDATE employees SET salary = salary * 1.05 WHERE department = 'IT';

-- 45. Deletes specific rows from a table.
DELETE FROM employees WHERE status = 'Terminated';

-- 46. Creates a temporary working table.
CREATE TABLE temp_emp (id INT, name VARCHAR(50));

-- 47. Drops a table if it exists.
DROP TABLE IF EXISTS temp_emp;

-- 48. Quickly purges all rows from a staging log table.
TRUNCATE TABLE staging_logs;

-- 49. Alters table schema to add a new column.
ALTER TABLE employees ADD hire_date_new DATE;

-- 50. Milestone verification query for Round 1 Part 1.
SELECT 'Round 1 Part 1 Completed Successfully' AS status;


-- ============================================================================
-- PART 2: MID-LEVEL FUNCTIONS, CTEs & WINDOW CALCULATIONS (Queries 51–100)
-- ============================================================================

-- 51. Assigns a unique sequential integer to rows ordered by salary.
SELECT name, salary, ROW_NUMBER() OVER (ORDER BY salary DESC) AS rn FROM employees;

-- 52. Assigns rank numbers with gaps for duplicate values.
SELECT name, salary, RANK() OVER (ORDER BY salary DESC) AS rnk FROM employees;

-- 53. Assigns rank numbers without gaps for duplicate values.
SELECT name, salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS drnk FROM employees;

-- 54. Partitions row numbering independently per department.
SELECT department, name, salary, ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rn FROM employees;

-- 55. Accesses data from a previous row relative to the current row.
SELECT name, salary, LAG(salary, 1) OVER (ORDER BY hire_date) AS prev_salary FROM employees;

-- 56. Accesses data from a subsequent row relative to the current row.
SELECT name, salary, LEAD(salary, 1) OVER (ORDER BY hire_date) AS next_salary FROM employees;

-- 57. Retrieves the first value in an ordered partition window.
SELECT name, department, salary, FIRST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS highest_dept_salary FROM employees;

-- 58. Retrieves the last value in an ordered window frame.
SELECT name, department, salary, LAST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lowest_dept_salary FROM employees;

-- 59. Distributes rows into a specified number of ranked groups.
SELECT name, salary, NTILE(4) OVER (ORDER BY salary DESC) AS quartile FROM employees;

-- 60. Creates a Common Table Expression (CTE) for modular query design.
WITH HighEarners AS (SELECT * FROM employees WHERE salary > 90000) SELECT * FROM HighEarners;

-- 61. Chains multiple CTEs together for complex logical multi-step processing.
WITH DeptAvg AS (SELECT department, AVG(salary) AS avg_sal FROM employees GROUP BY department), 
     HighDept AS (SELECT department FROM DeptAvg WHERE avg_sal > 75000) 
SELECT * FROM employees WHERE department IN (SELECT department FROM HighDept);

-- 62. Generates recursive sequence numbers in T-SQL.
WITH nums(n) AS (SELECT 1 UNION ALL SELECT n + 1 FROM nums WHERE n < 10) SELECT * FROM nums;

-- 63. Correlates a subquery against the outer query's current row context.
SELECT * FROM employees e WHERE salary > (SELECT AVG(salary) FROM employees WHERE department = e.department);

-- 64. Implements a subquery as a derived table within the FROM clause.
SELECT dept, avg_sal FROM (SELECT department AS dept, AVG(salary) AS avg_sal FROM employees GROUP BY department) t WHERE avg_sal > 60000;

-- 65. Checks for existence of related records using EXISTS.
SELECT * FROM customers c WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id AND o.amount > 500);

-- 66. Filters for records lacking related entries using NOT EXISTS (Anti-Join).
SELECT * FROM customers c WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id);

-- 67. Identifies duplicate email records using grouping and HAVING.
SELECT email, COUNT(*) FROM users GROUP BY email HAVING COUNT(*) > 1;

-- 68. Deletes duplicate table rows safely using a CTE and window ranking.
WITH cte AS (SELECT id, ROW_NUMBER() OVER (PARTITION BY email ORDER BY created_at DESC) AS rn FROM users) DELETE FROM cte WHERE rn > 1;

-- 69. Pivots categorical values into metrics using conditional aggregation.
SELECT department, SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_count, SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_count FROM employees GROUP BY department;

-- 70. Extracts substring characters up to the '@' symbol in emails.
SELECT SUBSTRING(email, 1, CHARINDEX('@', email) - 1) AS username FROM users;

-- 71. Locates character position within a string.
SELECT CHARINDEX('@', 'test@gmail.com');

-- 72. Replaces specific characters within a string.
SELECT REPLACE('123-456-7890', '-', '') AS clean_phone;

-- 73. Converts text casing to uppercase and lowercase.
SELECT UPPER(first_name), LOWER(last_name) FROM employees;

-- 74. Trims leading and trailing whitespace.
SELECT LTRIM(RTRIM(status)) FROM users;

-- 75. Computes the character length of text strings.
SELECT name, LEN(name) FROM employees WHERE LEN(name) > 10;

-- 76. Truncates date values to month-level precision in T-SQL.
SELECT DATEADD(month, DATEDIFF(month, 0, order_date), 0), SUM(amount) FROM orders GROUP BY DATEADD(month, DATEDIFF(month, 0, order_date), 0);

-- 77. Extracts year components from date fields.
SELECT DATEPART(year, hire_date), COUNT(*) FROM employees GROUP BY DATEPART(year, hire_date);

-- 78. Calculates date differences in days.
SELECT DATEDIFF(day, '2026-01-01', '2026-01-10');

-- 79. Adds date intervals to a timestamp.
SELECT DATEADD(day, 7, GETDATE());

-- 80. Returns the first non-null value among arguments.
SELECT COALESCE(phone, mobile, 'No Contact') FROM users;

-- 81. Returns NULL if two expressions are equal.
SELECT NULLIF(actual_val, target_val) FROM metrics;

-- 82. Implements conditional logic to evaluate greater values.
SELECT CASE WHEN col1 > col2 THEN col1 ELSE col2 END FROM metrics;

-- 83. Implements conditional logic to evaluate lesser values.
SELECT CASE WHEN col1 < col2 THEN col1 ELSE col2 END FROM metrics;

-- 84. Validates basic pattern matching via LIKE wildcards.
SELECT * FROM users WHERE email LIKE '%@%.%';

-- 85. Extracts values from JSON data fields in T-SQL.
SELECT JSON_VALUE('{"address": {"city": "Cairo"}}', '$.address.city');

-- 86. Aggregates multi-row text values into a single delimited string.
SELECT department, STRING_AGG(name, ', ') FROM employees GROUP BY department;

-- 87. Calculates cumulative running totals across ordered rows.
SELECT sale_id, amount, SUM(amount) OVER (ORDER BY sale_id) AS running_total FROM sales;

-- 88. Computes moving averages across rolling window frames.
SELECT sale_id, amount, AVG(amount) OVER (ORDER BY sale_id ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS moving_avg FROM sales;

-- 89. Calculates relative percentile ranking of values.
SELECT name, salary, PERCENT_RANK() OVER (ORDER BY salary) FROM employees;

-- 90. Calculates cumulative distribution metrics.
SELECT name, salary, CUME_DIST() OVER (ORDER BY salary) FROM employees;

-- 91. Retrieves the first value within an ordered partition window.
SELECT name, salary, FIRST_VALUE(salary) OVER (ORDER BY salary DESC) FROM employees;

-- 92. Filters top N records per partition group using a window function.
WITH ranked AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY price DESC) as rn FROM products) SELECT * FROM ranked WHERE rn <= 3;

-- 93. Calculates statistical median using percentile distribution functions.
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) OVER () FROM employees;

-- 94. Finds the statistical mode value in a dataset.
SELECT TOP 1 salary FROM employees GROUP BY salary ORDER BY COUNT(*) DESC;

-- 95. Identifies missing numerical gaps in sequential lists.
SELECT t1.id + 1 AS missing_id FROM ids t1 WHERE NOT EXISTS (SELECT 1 FROM ids t2 WHERE t2.id = t1.id + 1);

-- 96. Solves island and gap grouping sequence problems.
SELECT MIN(val), MAX(val) FROM (SELECT val, val - ROW_NUMBER() OVER (ORDER BY val) AS grp FROM sequence_table) t GROUP BY grp;

-- 97. Generates self-referencing hierarchical path strings.
WITH PATH AS (SELECT id, name, CAST(name AS VARCHAR(1000)) AS path FROM categories WHERE parent_id IS NULL UNION ALL SELECT c.id, c.name, CAST(p.path + ' > ' + c.name AS VARCHAR(1000)) FROM categories c JOIN PATH p ON c.parent_id = p.id) SELECT * FROM PATH;

-- 98. Safely casts string values to numeric data types.
SELECT CAST(string_val AS DECIMAL(10,2)) FROM staging;

-- 99. Safely attempts data type conversion without throwing runtime batch errors.
SELECT TRY_CAST('123' AS INT);

-- 100. Final confirmation query for the completion of Round 1.
SELECT 'Round 1 (Queries 1–100) Completed Successfully!' AS round_1_status;


/*
SQL SERVER DATA ANALYST PRACTICE LIBRARY — ROUND 2 (QUERIES 01–100)
===================================================================

Dialect: Microsoft SQL Server (T-SQL)
Description: Round 2 variation featuring adjusted numerical thresholds, 
shifted date parameters (2025/2027 baselines), and modified filter criteria 
for comprehensive practice and portfolio building.
*/

CREATE DATABASE SQLMastery_Round2;
GO
USE SQLMastery_Round2;
GO

-- Setup Mock Schema & Seed Data for Round 2
CREATE TABLE dbo.Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE dbo.Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeName VARCHAR(100),
    DepartmentID INT FOREIGN KEY REFERENCES dbo.Departments(DepartmentID),
    Salary DECIMAL(18,2),
    HireDate DATE
);

CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50),
    Region VARCHAR(50)
);

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES dbo.Customers(CustomerID),
    OrderDate DATE,
    ShipDate DATE,
    Status VARCHAR(50),
    TotalAmount DECIMAL(18,2)
);

CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(18,2),
    CostPrice DECIMAL(18,2),
    OriginalPrice DECIMAL(18,2),
    StockQuantity INT,
    ReorderLevel INT
);

CREATE TABLE dbo.OrderItems (
    OrderID INT FOREIGN KEY REFERENCES dbo.Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES dbo.Products(ProductID),
    Quantity INT,
    UnitPrice DECIMAL(18,2)
);

-- Seed Sample Data
INSERT INTO dbo.Departments VALUES (1, 'Analytics'), (2, 'Engineering'), (3, 'Sales'), (4, 'Operations');

INSERT INTO dbo.Employees (EmployeeName, DepartmentID, Salary, HireDate) VALUES 
('Alice Smith', 1, 95000.00, '2024-03-15'),
('Bob Jones', 2, 110000.00, '2023-07-01'),
('Charlie Brown', 3, 72000.00, '2025-01-10'),
('Diana Prince', 3, 72000.00, '2025-02-14'),
('Ethan Hunt', 4, 65000.00, '2025-06-20');

INSERT INTO dbo.Customers VALUES 
(1, 'Acme Corp', 'contact@acme.com', 'New York', 'East'),
(2, 'Beta LLC', NULL, 'Chicago', 'Central'),
(3, 'Gamma Inc', 'support@gamma.com', 'San Francisco', 'West'),
(4, 'Delta Co', 'info@delta.com', 'New York', 'East');

INSERT INTO dbo.Products VALUES 
(101, 'Enterprise Server', 'Hardware', 1500.00, 1100.00, 1700.00, 8, 15),
(102, 'Cloud License', 'Software', 450.00, 100.00, 500.00, 120, 20),
(103, 'Support Pack', 'Services', 150.00, 30.00, 200.00, 500, 50),
(104, 'Workstation Pro', 'Hardware', 850.00, 600.00, 950.00, 4, 10);

INSERT INTO dbo.Orders VALUES 
(1001, 1, '2025-05-10', '2025-05-12', 'Shipped', 1950.00),
(1002, 2, '2025-06-01', '2025-06-08', 'Shipped', 450.00),
(1003, 1, '2025-08-15', '2025-08-16', 'Processing', 850.00),
(1004, 3, '2026-01-10', NULL, 'Pending', 1500.00),
(1005, 4, '2026-02-01', '2026-02-02', 'Shipped', 600.00);

INSERT INTO dbo.OrderItems VALUES 
(1001, 101, 1, 1500.00),
(1001, 103, 3, 150.00),
(1002, 102, 1, 450.00),
(1003, 104, 1, 850.00),
(1004, 101, 1, 1500.00),
(1005, 102, 1, 450.00),
(1005, 103, 1, 150.00);
GO


/* 01. Filter rows with WHERE (Modified: looking for 'Shipped' status) */
SELECT OrderID, CustomerID, OrderDate, Status
FROM dbo.Orders
WHERE Status = 'Shipped';


/* 02. Sort results (Modified: sorting by StockQuantity descending) */
SELECT ProductID, ProductName, StockQuantity
FROM dbo.Products
ORDER BY StockQuantity DESC;


/* 03. Return the top 5 records (Modified: TOP 5 instead of 10) */
SELECT TOP (5) OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
ORDER BY TotalAmount DESC;


/* 04. Find distinct categories */
SELECT DISTINCT Category
FROM dbo.Products
ORDER BY Category;


/* 05. Count all rows vs non-NULL values */
SELECT COUNT(*) AS TotalRows,
       COUNT(Email) AS RowsWithEmail
FROM dbo.Customers;


/* 06. Find NULL values */
SELECT CustomerID, CustomerName, Email
FROM dbo.Customers
WHERE Email IS NULL;


/* 07. Use CASE to classify values (Modified price tiers) */
SELECT ProductID, ProductName, Price,
       CASE WHEN Price >= 1000 THEN 'Tier 1'
            WHEN Price >= 500 THEN 'Tier 2'
            ELSE 'Tier 3' END AS PriceTier
FROM dbo.Products;


/* 08. Aggregate with GROUP BY */
SELECT Status, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY Status;


/* 09. Filter groups with HAVING (Modified threshold >= 2) */
SELECT CustomerID, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(*) >= 2;


/* 10. Calculate average salary */
SELECT AVG(CAST(Salary AS DECIMAL(18,2))) AS AverageSalary
FROM dbo.Employees;


/* 11. INNER JOIN two tables */
SELECT o.OrderID, c.CustomerName, o.OrderDate
FROM dbo.Orders AS o
INNER JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID;


/* 12. LEFT JOIN to keep unmatched customers */
SELECT c.CustomerID, c.CustomerName, o.OrderID
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID;


/* 13. Find customers with no orders */
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;


/* 14. Find products never ordered */
SELECT p.ProductID, p.ProductName
FROM dbo.Products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.OrderItems AS oi
    WHERE oi.ProductID = p.ProductID
);


/* 15. Join three tables */
SELECT o.OrderID, c.CustomerName, p.ProductName, oi.Quantity
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID;


/* 16. UNION vs UNION ALL pattern */
SELECT City FROM dbo.Customers
UNION
SELECT Region FROM dbo.Customers;


/* 17. Find duplicate emails */
SELECT Email, COUNT(*) AS DuplicateCount
FROM dbo.Customers
WHERE Email IS NOT NULL
GROUP BY Email
HAVING COUNT(*) > 1;


/* 18. Find the second-highest distinct salary */
WITH SalaryRanks AS (
    SELECT Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM dbo.Employees
    WHERE Salary IS NOT NULL
)
SELECT DISTINCT Salary
FROM SalaryRanks
WHERE SalaryRank = 2;


/* 19. Find the Nth-highest salary (Modified @N = 2) */
DECLARE @N INT = 2;
WITH SalaryRanks AS (
    SELECT EmployeeID, EmployeeName, Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM dbo.Employees
    WHERE Salary IS NOT NULL
)
SELECT EmployeeID, EmployeeName, Salary
FROM SalaryRanks
WHERE SalaryRank = @N;


/* 20. Rank employees within each department */
SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
       RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
FROM dbo.Employees;


/* 21. Top 2 employees per department (Modified to rn <= 2) */
WITH RankedEmployees AS (
    SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
           ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC, EmployeeID) AS rn
    FROM dbo.Employees
)
SELECT EmployeeID, EmployeeName, DepartmentID, Salary
FROM RankedEmployees
WHERE rn <= 2;


/* 22. Compare ROW_NUMBER, RANK, DENSE_RANK */
SELECT EmployeeID, EmployeeName, Salary,
       ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNum,
       RANK() OVER (ORDER BY Salary DESC) AS SalaryRank,
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseSalaryRank
FROM dbo.Employees;


/* 23. Find employees paid above company average */
SELECT EmployeeID, EmployeeName, Salary
FROM dbo.Employees
WHERE Salary > (SELECT AVG(CAST(Salary AS DECIMAL(18,2))) FROM dbo.Employees);


/* 24. Find employees paid above their department average */
WITH DepartmentAverages AS (
    SELECT DepartmentID, AVG(CAST(Salary AS DECIMAL(18,2))) AS AvgSalary
    FROM dbo.Employees
    GROUP BY DepartmentID
)
SELECT e.EmployeeID, e.EmployeeName, e.DepartmentID, e.Salary
FROM dbo.Employees AS e
JOIN DepartmentAverages AS d ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > d.AvgSalary;


/* 25. Use a CTE to calculate order totals */
WITH OrderTotals AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS CalculatedTotal
    FROM dbo.OrderItems
    GROUP BY OrderID
)
SELECT OrderID, CalculatedTotal
FROM OrderTotals
ORDER BY CalculatedTotal DESC;


/* 26. Use EXISTS to find customers with orders */
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
WHERE EXISTS (
    SELECT 1 FROM dbo.Orders AS o
    WHERE o.CustomerID = c.CustomerID
);


/* 27. Find the latest order for each customer */
WITH RankedOrders AS (
    SELECT OrderID, CustomerID, OrderDate,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC) AS rn
    FROM dbo.Orders
)
SELECT OrderID, CustomerID, OrderDate
FROM RankedOrders
WHERE rn = 1;


/* 28. Find each customer's first order */
SELECT CustomerID, MIN(OrderDate) AS FirstOrderDate
FROM dbo.Orders
GROUP BY CustomerID;


/* 29. Calculate a running sales total */
WITH DailySales AS (
    SELECT CAST(OrderDate AS DATE) AS OrderDay, SUM(TotalAmount) AS Sales
    FROM dbo.Orders
    GROUP BY CAST(OrderDate AS DATE)
)
SELECT OrderDay, Sales,
       SUM(Sales) OVER (ORDER BY OrderDay ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningSales
FROM DailySales
ORDER BY OrderDay;


/* 30. Compare each month with the previous month */
WITH MonthlySales AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
SalesComparison AS (
    SELECT SalesMonth, Revenue,
           LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue
    FROM MonthlySales
)
SELECT SalesMonth, Revenue, PreviousMonthRevenue,
       (Revenue - PreviousMonthRevenue) * 100.0 / NULLIF(PreviousMonthRevenue, 0) AS MoMPercentChange
FROM SalesComparison
ORDER BY SalesMonth;


/* 31. Calculate each category's share of revenue */
WITH CategorySales AS (
    SELECT p.Category, SUM(oi.Quantity * oi.UnitPrice) AS Revenue
    FROM dbo.OrderItems AS oi
    JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
    GROUP BY p.Category
)
SELECT Category, Revenue,
       Revenue * 100.0 / NULLIF(SUM(Revenue) OVER (), 0) AS RevenueSharePercent
FROM CategorySales
ORDER BY Revenue DESC;


/* 32. Find customers above average order value */
WITH CustomerSpend AS (
    SELECT CustomerID, AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AvgOrderValue
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT CustomerID, AvgOrderValue
FROM CustomerSpend
WHERE AvgOrderValue > (SELECT AVG(CAST(TotalAmount AS DECIMAL(18,2))) FROM dbo.Orders);


/* 33. Find consecutive orders using LAG */
WITH OrderHistory AS (
    SELECT CustomerID, OrderID, OrderDate,
           LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate, OrderID) AS PreviousOrderDate
    FROM dbo.Orders
)
SELECT CustomerID, OrderID, OrderDate, PreviousOrderDate,
       DATEDIFF(DAY, PreviousOrderDate, OrderDate) AS DaysSincePreviousOrder
FROM OrderHistory;


/* 34. Calculate a 2-row moving average of daily sales (Modified to 2 rows) */
WITH DailySales AS (
    SELECT CAST(OrderDate AS DATE) AS OrderDay, SUM(TotalAmount) AS Sales
    FROM dbo.Orders
    GROUP BY CAST(OrderDate AS DATE)
)
SELECT OrderDay, Sales,
       AVG(CAST(Sales AS DECIMAL(18,2))) OVER (
           ORDER BY OrderDay ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
       ) AS MovingAverage2Rows
FROM DailySales
ORDER BY OrderDay;


/* 35. Find duplicate rows by business key and keep latest */
WITH Duplicates AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC
    ) AS rn
    FROM dbo.Orders
)
SELECT *
FROM Duplicates
WHERE rn = 1;


/* 36. Pivot order counts by status */
SELECT CustomerID,
       SUM(CASE WHEN Status = 'Shipped' THEN 1 ELSE 0 END) AS ShippedOrders,
       SUM(CASE WHEN Status = 'Processing' THEN 1 ELSE 0 END) AS ProcessingOrders,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS PendingOrders
FROM dbo.Orders
GROUP BY CustomerID;


/* 37. Find the most expensive product in each category */
WITH RankedProducts AS (
    SELECT ProductID, ProductName, Category, Price,
           DENSE_RANK() OVER (PARTITION BY Category ORDER BY Price DESC) AS rn
    FROM dbo.Products
)
SELECT ProductID, ProductName, Category, Price
FROM RankedProducts
WHERE rn = 1;


/* 38. Find customers who ordered in one year but not another (Shifted years) */
SELECT DISTINCT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2025-01-01' AND OrderDate < '2026-01-01'
EXCEPT
SELECT DISTINCT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2026-01-01' AND OrderDate < '2027-01-01';


/* 39. Calculate order value including line items */
SELECT o.OrderID, o.CustomerID, o.OrderDate,
       SUM(oi.Quantity * oi.UnitPrice) AS CalculatedOrderValue
FROM dbo.Orders AS o
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
GROUP BY o.OrderID, o.CustomerID, o.OrderDate;


/* 40. Find orders where stored total differs from line total */
WITH LineTotals AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS LineTotal
    FROM dbo.OrderItems
    GROUP BY OrderID
)
SELECT o.OrderID, o.TotalAmount, l.LineTotal,
       o.TotalAmount - l.LineTotal AS Difference
FROM dbo.Orders AS o
JOIN LineTotals AS l ON l.OrderID = o.OrderID
WHERE ABS(o.TotalAmount - l.LineTotal) > 0.01;


/* 41. Calculate percentage of employees in each department */
SELECT DepartmentID, COUNT(*) AS EmployeeCount,
       COUNT(*) * 100.0 / NULLIF(SUM(COUNT(*)) OVER (), 0) AS PercentOfEmployees
FROM dbo.Employees
GROUP BY DepartmentID;


/* 42. Find employees hired in the last 24 months (Modified to 24) */
SELECT EmployeeID, EmployeeName, HireDate
FROM dbo.Employees
WHERE HireDate >= DATEADD(MONTH, -24, CAST(GETDATE() AS DATE))
  AND HireDate < DATEADD(DAY, 1, CAST(GETDATE() AS DATE));


/* 43. Calculate days between order and shipment */
SELECT OrderID, OrderDate, ShipDate,
       DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Orders
WHERE ShipDate IS NOT NULL;


/* 44. Find the median salary */
SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary)
       OVER () AS MedianSalary
FROM dbo.Employees
WHERE Salary IS NOT NULL;


/* 45. Identify outlier prices using IQR */
WITH Quartiles AS (
    SELECT DISTINCT
           PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Price) OVER () AS Q1,
           PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Price) OVER () AS Q3
    FROM dbo.Products
    WHERE Price IS NOT NULL
)
SELECT p.ProductID, p.ProductName, p.Price, q.Q1, q.Q3
FROM dbo.Products AS p
CROSS JOIN Quartiles AS q
WHERE p.Price < q.Q1 - 1.5 * (q.Q3 - q.Q1)
   OR p.Price > q.Q3 + 1.5 * (q.Q3 - q.Q1);


/* 46. Find missing dates in the order activity calendar */
WITH OrderDays AS (
    SELECT DISTINCT CAST(OrderDate AS DATE) AS OrderDay
    FROM dbo.Orders
),
DateRange AS (
    SELECT MIN(OrderDay) AS StartDay, MAX(OrderDay) AS EndDay
    FROM OrderDays
),
Calendar AS (
    SELECT StartDay AS CalendarDay, EndDay
    FROM DateRange
    UNION ALL
    SELECT DATEADD(DAY, 1, CalendarDay), EndDay
    FROM Calendar
    WHERE CalendarDay < EndDay
)
SELECT c.CalendarDay
FROM Calendar AS c
LEFT JOIN OrderDays AS o ON o.OrderDay = c.CalendarDay
WHERE o.OrderDay IS NULL
OPTION (MAXRECURSION 0);


/* 47. Find customers with orders in at least 2 distinct months (Modified to >= 2) */
SELECT CustomerID, COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) AS ActiveMonths
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) >= 2;


/* 48. Calculate customer repeat-purchase rate */
WITH CustomerOrders AS (
    SELECT CustomerID, COUNT(*) AS OrderCount
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT COUNT(CASE WHEN OrderCount >= 2 THEN 1 END) AS RepeatCustomers,
       COUNT(*) AS CustomersWithOrders,
       COUNT(CASE WHEN OrderCount >= 2 THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS RepeatPurchaseRatePercent
FROM CustomerOrders;


/* 49. Calculate customer retention by first-order cohort and next month */
WITH FirstOrder AS (
    SELECT CustomerID, MIN(DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) AS CohortMonth
    FROM dbo.Orders
    GROUP BY CustomerID
),
CustomerActivity AS (
    SELECT DISTINCT CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS ActivityMonth
    FROM dbo.Orders
)
SELECT f.CohortMonth,
       COUNT(DISTINCT f.CustomerID) AS CohortCustomers,
       COUNT(DISTINCT CASE WHEN a.ActivityMonth = DATEADD(MONTH, 1, f.CohortMonth) THEN f.CustomerID END) AS RetainedNextMonth,
       COUNT(DISTINCT CASE WHEN a.ActivityMonth = DATEADD(MONTH, 1, f.CohortMonth) THEN f.CustomerID END) * 100.0
           / NULLIF(COUNT(DISTINCT f.CustomerID), 0) AS NextMonthRetentionPercent
FROM FirstOrder AS f
LEFT JOIN CustomerActivity AS a ON a.CustomerID = f.CustomerID
GROUP BY f.CohortMonth
ORDER BY f.CohortMonth;


/* 50. Inspect query execution plan and IO/time */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT CustomerID, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
WHERE OrderDate >= '2025-01-01' AND OrderDate < '2026-01-01'
GROUP BY CustomerID;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;


/* 51. Daily sales summary (Modified window to last 60 days) */
SELECT CAST(OrderDate AS DATE) AS OrderDay,
       COUNT(*) AS OrderCount,
       SUM(TotalAmount) AS Revenue,
       AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AverageOrderValue
FROM dbo.Orders
WHERE OrderDate >= DATEADD(DAY, -60, CAST(GETDATE() AS DATE))
GROUP BY CAST(OrderDate AS DATE)
ORDER BY OrderDay;


/* 52. Sales by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 53. Sales by region */
SELECT c.Region, COUNT(o.OrderID) AS OrderCount, SUM(o.TotalAmount) AS Revenue
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
GROUP BY c.Region
ORDER BY Revenue DESC;


/* 54. Sales by product category */
SELECT p.Category, SUM(oi.Quantity) AS UnitsSold,
       SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM dbo.OrderItems AS oi
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
GROUP BY p.Category
ORDER BY Revenue DESC;


/* 55. Top 5 customers by lifetime revenue (Modified TOP 5) */
SELECT TOP (5) c.CustomerID, c.CustomerName,
       SUM(o.TotalAmount) AS LifetimeRevenue
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY LifetimeRevenue DESC;


/* 56. Top 5 products by units sold (Modified TOP 5) */
SELECT TOP (5) p.ProductID, p.ProductName,
       SUM(oi.Quantity) AS UnitsSold
FROM dbo.OrderItems AS oi
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY UnitsSold DESC;


/* 57. Revenue by order status */
SELECT Status, COUNT(*) AS OrderCount, SUM(TotalAmount) AS TotalAmount
FROM dbo.Orders
GROUP BY Status
ORDER BY TotalAmount DESC;


/* 58. Cancellation rate */
SELECT COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) AS CancelledOrders,
       COUNT(*) AS TotalOrders,
       COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS CancellationRatePercent
FROM dbo.Orders;


/* 59. Average order value by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AverageOrderValue
FROM dbo.Orders
WHERE TotalAmount IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 60. Customers who have not ordered in 60 days (Modified to 60 days) */
SELECT c.CustomerID, c.CustomerName, MAX(o.OrderDate) AS LastOrderDate
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING MAX(o.OrderDate) IS NULL
    OR MAX(o.OrderDate) < DATEADD(DAY, -60, GETDATE());


/* 61. Customers who ordered this month */
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderDate >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
  AND o.OrderDate < DATEADD(MONTH, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1));


/* 62. Orders above the overall average order value */
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE TotalAmount > (SELECT AVG(CAST(TotalAmount AS DECIMAL(18,2))) FROM dbo.Orders);


/* 63. Daily order count by status */
SELECT CAST(OrderDate AS DATE) AS OrderDay,
       SUM(CASE WHEN Status = 'Shipped' THEN 1 ELSE 0 END) AS Shipped,
       SUM(CASE WHEN Status = 'Processing' THEN 1 ELSE 0 END) AS Processing,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS Pending
FROM dbo.Orders
GROUP BY CAST(OrderDate AS DATE)
ORDER BY OrderDay;


/* 64. Check duplicate customer records */
SELECT CustomerName, Email, COUNT(*) AS RecordCount
FROM dbo.Customers
GROUP BY CustomerName, Email
HAVING COUNT(*) > 1;


/* 65. Check duplicate order IDs */
SELECT OrderID, COUNT(*) AS RecordCount
FROM dbo.Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;


/* 66. Check missing required values */
SELECT
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS MissingOrderDate,
    SUM(CASE WHEN TotalAmount IS NULL THEN 1 ELSE 0 END) AS MissingTotalAmount
FROM dbo.Orders;


/* 67. Find negative or zero order amounts */
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE TotalAmount <= 0;


/* 68. Find negative prices or quantities */
SELECT OrderID, ProductID, Quantity, UnitPrice
FROM dbo.OrderItems
WHERE Quantity <= 0 OR UnitPrice < 0;


/* 69. Find orders with no matching customer */
SELECT o.*
FROM dbo.Orders AS o
LEFT JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL;


/* 70. Find order items with no matching product */
SELECT oi.*
FROM dbo.OrderItems AS oi
LEFT JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
WHERE p.ProductID IS NULL;


/* 71. Standardize text for review (trim and lowercase) */
SELECT CustomerID, CustomerName, Email,
       LOWER(LTRIM(RTRIM(Email))) AS StandardizedEmail
FROM dbo.Customers;


/* 72. Find leading/trailing spaces in customer names */
SELECT CustomerID, CustomerName
FROM dbo.Customers
WHERE CustomerName <> LTRIM(RTRIM(CustomerName));


/* 73. Count distinct customers per month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       COUNT(DISTINCT CustomerID) AS ActiveCustomers
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 74. Compare current month and previous month revenue */
WITH MonthlyRevenue AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
)
SELECT SalesMonth, Revenue,
       LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue,
       Revenue - LAG(Revenue) OVER (ORDER BY SalesMonth) AS RevenueChange
FROM MonthlyRevenue
ORDER BY SalesMonth;


/* 75. Year-over-year revenue comparison */
WITH YearlyRevenue AS (
    SELECT YEAR(OrderDate) AS SalesYear, SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY YEAR(OrderDate)
)
SELECT SalesYear, Revenue,
       LAG(Revenue) OVER (ORDER BY SalesYear) AS PreviousYearRevenue,
       (Revenue - LAG(Revenue) OVER (ORDER BY SalesYear)) * 100.0
           / NULLIF(LAG(Revenue) OVER (ORDER BY SalesYear), 0) AS YoYPercentChange
FROM YearlyRevenue
ORDER BY SalesYear;


/* 76. Revenue by weekday */
SELECT DATENAME(WEEKDAY, OrderDate) AS WeekdayName,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATENAME(WEEKDAY, OrderDate), DATEPART(WEEKDAY, OrderDate)
ORDER BY DATEPART(WEEKDAY, OrderDate);


/* 77. Revenue by hour of day */
SELECT DATEPART(HOUR, CAST(OrderDate AS DATETIME)) AS OrderHour,
       COUNT(*) AS OrderCount, 
       SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEPART(HOUR, CAST(OrderDate AS DATETIME))
ORDER BY OrderHour;


/* 78. Average shipping time by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS OrderMonth,
       AVG(CAST(DATEDIFF(DAY, OrderDate, ShipDate) AS DECIMAL(10,2))) AS AvgDaysToShip
FROM dbo.Orders
WHERE ShipDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY OrderMonth;


/* 79. Late shipments (Modified threshold to > 2 days) */
SELECT OrderID, OrderDate, ShipDate,
       DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Orders
WHERE ShipDate > DATEADD(DAY, 2, OrderDate);


/* 80. Products below reorder level */
SELECT ProductID, ProductName, StockQuantity, ReorderLevel
FROM dbo.Products
WHERE StockQuantity <= ReorderLevel;


/* 81. Inventory value by category */
SELECT Category,
       SUM(CAST(StockQuantity AS DECIMAL(18,2)) * Price) AS InventoryValue
FROM dbo.Products
GROUP BY Category
ORDER BY InventoryValue DESC;


/* 82. Calculate gross margin per product */
SELECT ProductID, ProductName, Price, CostPrice,
       Price - CostPrice AS GrossProfitPerUnit,
       (Price - CostPrice) * 100.0 / NULLIF(Price, 0) AS GrossMarginPercent
FROM dbo.Products
WHERE Price IS NOT NULL AND CostPrice IS NOT NULL;


/* 83. Discount analysis */
SELECT ProductID, ProductName, OriginalPrice, Price,
       OriginalPrice - Price AS DiscountAmount,
       (OriginalPrice - Price) * 100.0 / NULLIF(OriginalPrice, 0) AS DiscountPercent
FROM dbo.Products
WHERE OriginalPrice > 0 AND Price IS NOT NULL;


/* 84. Average salary by department */
SELECT d.DepartmentName,
       AVG(CAST(e.Salary AS DECIMAL(18,2))) AS AverageSalary,
       MIN(e.Salary) AS MinimumSalary,
       MAX(e.Salary) AS MaximumSalary,
       COUNT(*) AS EmployeeCount
FROM dbo.Employees AS e
JOIN dbo.Departments AS d ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY AverageSalary DESC;


/* 85. Headcount by department */
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS Headcount
FROM dbo.Departments AS d
LEFT JOIN dbo.Employees AS e ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY Headcount DESC;


/* 86. Employees missing a department match */
SELECT e.EmployeeID, e.EmployeeName, e.DepartmentID
FROM dbo.Employees AS e
LEFT JOIN dbo.Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentID IS NULL;


/* 87. New hires by month */
SELECT DATEFROMPARTS(YEAR(HireDate), MONTH(HireDate), 1) AS HireMonth,
       COUNT(*) AS NewHires
FROM dbo.Employees
WHERE HireDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(HireDate), MONTH(HireDate), 1)
ORDER BY HireMonth;


/* 88. Employee salary compared with department average */
SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
       AVG(CAST(Salary AS DECIMAL(18,2))) OVER (PARTITION BY DepartmentID) AS DepartmentAverage
FROM dbo.Employees;


/* 89. Find customers with multiple orders on the same day */
SELECT CustomerID, CAST(OrderDate AS DATE) AS OrderDay, COUNT(*) AS OrdersThatDay
FROM dbo.Orders
GROUP BY CustomerID, CAST(OrderDate AS DATE)
HAVING COUNT(*) > 1;


/* 90. Calculate order-item contribution to order total */
WITH LineValues AS (
    SELECT OrderID, ProductID, Quantity * UnitPrice AS LineValue
    FROM dbo.OrderItems
),
OrderValues AS (
    SELECT OrderID, SUM(LineValue) AS OrderValue
    FROM LineValues
    GROUP BY OrderID
)
SELECT l.OrderID, l.ProductID, l.LineValue, o.OrderValue,
       l.LineValue * 100.0 / NULLIF(o.OrderValue, 0) AS PercentOfOrder
FROM LineValues AS l
JOIN OrderValues AS o ON o.OrderID = l.OrderID;


/* 91. Identify customers whose spending declined month over month */
WITH CustomerMonthlySpend AS (
    SELECT CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS MonthlySpend
    FROM dbo.Orders
    GROUP BY CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
SpendComparison AS (
    SELECT CustomerID, SalesMonth, MonthlySpend,
           LAG(MonthlySpend) OVER (PARTITION BY CustomerID ORDER BY SalesMonth) AS PreviousMonthSpend
    FROM CustomerMonthlySpend
)
SELECT CustomerID, SalesMonth, MonthlySpend, PreviousMonthSpend
FROM SpendComparison
WHERE PreviousMonthSpend IS NOT NULL AND MonthlySpend < PreviousMonthSpend;


/* 92. Segment customers by lifetime spending (Modified thresholds: 5000 / 1000) */
WITH CustomerSpend AS (
    SELECT c.CustomerID, c.CustomerName, COALESCE(SUM(o.TotalAmount), 0) AS LifetimeSpend
    FROM dbo.Customers AS c
    LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT *, CASE WHEN LifetimeSpend >= 5000 THEN 'High Value'
               WHEN LifetimeSpend >= 1000 THEN 'Medium Value'
               ELSE 'Low Value' END AS CustomerSegment
FROM CustomerSpend;


/* 93. Calculate RFM-style recency, frequency, monetary value */
SELECT c.CustomerID, c.CustomerName,
       MAX(o.OrderDate) AS LastOrderDate,
       DATEDIFF(DAY, MAX(o.OrderDate), CAST(GETDATE() AS DATE)) AS RecencyDays,
       COUNT(o.OrderID) AS Frequency,
       COALESCE(SUM(o.TotalAmount), 0) AS MonetaryValue
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName;



/* 94. Find customers with a high-value recent order (Modified threshold >= 500) */
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.TotalAmount >= 500
  AND o.OrderDate >= DATEADD(DAY, -30, GETDATE());


/* 95. Weekly sales summary */
SELECT DATEADD(DAY, 1 - DATEPART(WEEKDAY, CAST(OrderDate AS DATE)), CAST(OrderDate AS DATE)) AS WeekStart,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEADD(DAY, 1 - DATEPART(WEEKDAY, CAST(OrderDate AS DATE)), CAST(OrderDate AS DATE))
ORDER BY WeekStart;

/* 96. Build a reusable filtered dataset with a CTE */
WITH RecentCompletedOrders AS (
    SELECT OrderID, CustomerID, OrderDate, TotalAmount
    FROM dbo.Orders
    WHERE Status = 'Shipped'
      AND OrderDate >= DATEADD(MONTH, -6, GETDATE())
)
SELECT CustomerID, COUNT(*) AS ShippedOrders, SUM(TotalAmount) AS Revenue
FROM RecentCompletedOrders
GROUP BY CustomerID
ORDER BY Revenue DESC;


/* 97. Create a temporary table for repeated analysis */
DROP TABLE IF EXISTS #MonthlySales;

SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       SUM(TotalAmount) AS Revenue
INTO #MonthlySales
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1);

SELECT SalesMonth, Revenue
FROM #MonthlySales
ORDER BY SalesMonth;


/* 98. Add a nonclustered index for a common filter */
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate
ON dbo.Orders (OrderDate)
INCLUDE (CustomerID, Status, TotalAmount);


/* 99. Safely test a data update inside a transaction */
BEGIN TRANSACTION;

UPDATE dbo.Products
SET Price = Price * 1.10
WHERE Category = 'Hardware';

-- Check affected rows and values before deciding:
SELECT ProductID, ProductName, Category, Price
FROM dbo.Products
WHERE Category = 'Hardware';

-- Run ONE of these after reviewing the result:
-- COMMIT TRANSACTION;
-- ROLLBACK TRANSACTION;


/* 100. Produce a compact data-quality summary for core tables */
SELECT 'Departments' AS TableName, COUNT(*) AS "RowCount" FROM dbo.Departments
UNION ALL
SELECT 'Employees', COUNT(*) FROM dbo.Employees
UNION ALL
SELECT 'Customers', COUNT(*) FROM dbo.Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM dbo.Orders
UNION ALL
SELECT 'OrderItems', COUNT(*) FROM dbo.OrderItems
UNION ALL
SELECT 'Products', COUNT(*) FROM dbo.Products;



/*
SQL SERVER DATA ANALYST PRACTICE LIBRARY — ROUND 3 (QUERIES 01–100)
===================================================================

Dialect: Microsoft SQL Server (T-SQL)
Description: Round 3 iteration featuring updated mock dataset values, shifted 
date parameters (2026/2027 baselines), modified numerical thresholds, and 
adjusted parameters while keeping the 100 core query patterns identical.
*/

CREATE DATABASE SQLMastery_Round3;
GO
USE SQLMastery_Round3;
GO

-- ============================================================================
-- SETUP BLOCK: MOCK SCHEMA & ROUND 3 SEED DATA
-- ============================================================================
CREATE TABLE dbo.Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE dbo.Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeName VARCHAR(100),
    DepartmentID INT FOREIGN KEY REFERENCES dbo.Departments(DepartmentID),
    Salary DECIMAL(18,2),
    HireDate DATE
);

CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50),
    Region VARCHAR(50)
);

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES dbo.Customers(CustomerID),
    OrderDate DATE,
    ShipDate DATE,
    Status VARCHAR(50),
    TotalAmount DECIMAL(18,2)
);

CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(18,2),
    CostPrice DECIMAL(18,2),
    OriginalPrice DECIMAL(18,2),
    StockQuantity INT,
    ReorderLevel INT
);

CREATE TABLE dbo.OrderItems (
    OrderID INT FOREIGN KEY REFERENCES dbo.Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES dbo.Products(ProductID),
    Quantity INT,
    UnitPrice DECIMAL(18,2)
);

-- Seed Sample Data (Round 3 Fresh Values)
INSERT INTO dbo.Departments VALUES 
(10, 'Data & AI'), 
(20, 'Cybersecurity'), 
(30, 'Enterprise Sales'), 
(40, 'Cloud Infrastructure');

INSERT INTO dbo.Employees (EmployeeName, DepartmentID, Salary, HireDate) VALUES 
('Hassan Farahat', 10, 105000.00, '2024-01-10'),
('Nawal Mahmoud', 10, 98000.00, '2024-06-15'),
('Omar Khaled', 20, 115000.00, '2023-03-20'),
('Youssef Ali', 30, 85000.00, '2025-09-01'),
('Mona Zaki', 40, 92000.00, '2026-02-11');

INSERT INTO dbo.Customers VALUES 
(501, 'Global Tech Solutions', 'contact@globaltech.io', 'Cairo', 'EMEA'),
(502, 'Nile Logistics', NULL, 'Alexandria', 'EMEA'),
(503, 'Apex Financial', 'billing@apexfin.com', 'Dubai', 'MENA'),
(504, 'Horizon Retail', 'info@horizon.com', 'Riyadh', 'MENA');

INSERT INTO dbo.Products VALUES 
(201, 'AI Inference Server', 'Hardware', 3200.00, 2400.00, 3500.00, 5, 10),
(202, 'Data Science Suite', 'Software', 750.00, 200.00, 850.00, 200, 30),
(203, '24/7 Managed SOC', 'Services', 1200.00, 500.00, 1400.00, 50, 15),
(204, 'High-Mem Node', 'Hardware', 2100.00, 1500.00, 2300.00, 12, 8);

INSERT INTO dbo.Orders VALUES 
(5001, 501, '2026-01-15', '2026-01-17', 'Completed', 3950.00),
(5002, 502, '2026-03-01', '2026-03-05', 'Completed', 750.00),
(5003, 501, '2026-06-20', '2026-06-22', 'Shipped', 2100.00),
(5004, 503, '2026-09-10', NULL, 'Pending', 3200.00),
(5005, 504, '2026-10-05', '2026-10-07', 'Completed', 1950.00);

INSERT INTO dbo.OrderItems VALUES 
(5001, 201, 1, 3200.00),
(5001, 202, 1, 750.00),
(5002, 202, 1, 750.00),
(5003, 204, 1, 2100.00),
(5004, 201, 1, 3200.00),
(5005, 202, 1, 750.00),
(5005, 203, 1, 1200.00);
GO


/* 01. Filter rows with WHERE (Modified: looking for 'Completed' status) */
SELECT OrderID, CustomerID, OrderDate, Status
FROM dbo.Orders
WHERE Status = 'Completed';


/* 02. Sort results (Modified: sorting by Price descending) */
SELECT ProductID, ProductName, Price
FROM dbo.Products
ORDER BY Price DESC;


/* 03. Return top records (Modified: TOP 3 instead of 5/10) */
SELECT TOP (3) OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
ORDER BY TotalAmount DESC;


/* 04. Find distinct categories */
SELECT DISTINCT Category
FROM dbo.Products
ORDER BY Category;


/* 05. Count all rows vs non-NULL values */
SELECT COUNT(*) AS TotalRows,
       COUNT(Email) AS RowsWithEmail
FROM dbo.Customers;


/* 06. Find NULL values */
SELECT CustomerID, CustomerName, Email
FROM dbo.Customers
WHERE Email IS NULL;


/* 07. Use CASE to classify values (Modified threshold limits) */
SELECT ProductID, ProductName, Price,
       CASE WHEN Price >= 2000 THEN 'Enterprise High'
            WHEN Price >= 1000 THEN 'Mid-Market'
            ELSE 'Standard' END AS PriceTier
FROM dbo.Products;


/* 08. Aggregate with GROUP BY */
SELECT Status, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY Status;


/* 09. Filter groups with HAVING (Modified threshold >= 1) */
SELECT CustomerID, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(*) >= 1;


/* 10. Calculate average salary */
SELECT AVG(CAST(Salary AS DECIMAL(18,2))) AS AverageSalary
FROM dbo.Employees;


/* 11. INNER JOIN two tables */
SELECT o.OrderID, c.CustomerName, o.OrderDate
FROM dbo.Orders AS o
INNER JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID;


/* 12. LEFT JOIN to keep unmatched customers */
SELECT c.CustomerID, c.CustomerName, o.OrderID
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID;


/* 13. Find customers with no orders */
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;


/* 14. Find products never ordered */
SELECT p.ProductID, p.ProductName
FROM dbo.Products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.OrderItems AS oi
    WHERE oi.ProductID = p.ProductID
);


/* 15. Join three tables */
SELECT o.OrderID, c.CustomerName, p.ProductName, oi.Quantity
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID;


/* 16. UNION vs UNION ALL pattern */
SELECT City FROM dbo.Customers
UNION
SELECT Region FROM dbo.Customers;


/* 17. Find duplicate emails */
SELECT Email, COUNT(*) AS DuplicateCount
FROM dbo.Customers
WHERE Email IS NOT NULL
GROUP BY Email
HAVING COUNT(*) > 1;


/* 18. Find the second-highest distinct salary */
WITH SalaryRanks AS (
    SELECT Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM dbo.Employees
    WHERE Salary IS NOT NULL
)
SELECT DISTINCT Salary
FROM SalaryRanks
WHERE SalaryRank = 2;


/* 19. Find the Nth-highest salary (Modified @N = 4) */
DECLARE @N INT = 4;
WITH SalaryRanks AS (
    SELECT EmployeeID, EmployeeName, Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM dbo.Employees
    WHERE Salary IS NOT NULL
)
SELECT EmployeeID, EmployeeName, Salary
FROM SalaryRanks
WHERE SalaryRank = @N;


/* 20. Rank employees within each department */
SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
       RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
FROM dbo.Employees;


/* 21. Top 1 employee per department (Modified to rn <= 1) */
WITH RankedEmployees AS (
    SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
           ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC, EmployeeID) AS rn
    FROM dbo.Employees
)
SELECT EmployeeID, EmployeeName, DepartmentID, Salary
FROM RankedEmployees
WHERE rn <= 1;


/* 22. Compare ROW_NUMBER, RANK, DENSE_RANK */
SELECT EmployeeID, EmployeeName, Salary,
       ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNum,
       RANK() OVER (ORDER BY Salary DESC) AS SalaryRank,
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseSalaryRank
FROM dbo.Employees;


/* 23. Find employees paid above company average */
SELECT EmployeeID, EmployeeName, Salary
FROM dbo.Employees
WHERE Salary > (SELECT AVG(CAST(Salary AS DECIMAL(18,2))) FROM dbo.Employees);


/* 24. Find employees paid above their department average */
WITH DepartmentAverages AS (
    SELECT DepartmentID, AVG(CAST(Salary AS DECIMAL(18,2))) AS AvgSalary
    FROM dbo.Employees
    GROUP BY DepartmentID
)
SELECT e.EmployeeID, e.EmployeeName, e.DepartmentID, e.Salary
FROM dbo.Employees AS e
JOIN DepartmentAverages AS d ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > d.AvgSalary;


/* 25. Use a CTE to calculate order totals */
WITH OrderTotals AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS CalculatedTotal
    FROM dbo.OrderItems
    GROUP BY OrderID
)
SELECT OrderID, CalculatedTotal
FROM OrderTotals
ORDER BY CalculatedTotal DESC;


/* 26. Use EXISTS to find customers with orders */
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
WHERE EXISTS (
    SELECT 1 FROM dbo.Orders AS o
    WHERE o.CustomerID = c.CustomerID
);


/* 27. Find the latest order for each customer */
WITH RankedOrders AS (
    SELECT OrderID, CustomerID, OrderDate,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC) AS rn
    FROM dbo.Orders
)
SELECT OrderID, CustomerID, OrderDate
FROM RankedOrders
WHERE rn = 1;


/* 28. Find each customer's first order */
SELECT CustomerID, MIN(OrderDate) AS FirstOrderDate
FROM dbo.Orders
GROUP BY CustomerID;


/* 29. Calculate a running sales total */
WITH DailySales AS (
    SELECT CAST(OrderDate AS DATE) AS OrderDay, SUM(TotalAmount) AS Sales
    FROM dbo.Orders
    GROUP BY CAST(OrderDate AS DATE)
)
SELECT OrderDay, Sales,
       SUM(Sales) OVER (ORDER BY OrderDay ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningSales
FROM DailySales
ORDER BY OrderDay;


/* 30. Compare each month with the previous month */
WITH MonthlySales AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
SalesComparison AS (
    SELECT SalesMonth, Revenue,
           LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue
    FROM MonthlySales
)
SELECT SalesMonth, Revenue, PreviousMonthRevenue,
       (Revenue - PreviousMonthRevenue) * 100.0 / NULLIF(PreviousMonthRevenue, 0) AS MoMPercentChange
FROM SalesComparison
ORDER BY SalesMonth;


/* 31. Calculate each category's share of revenue */
WITH CategorySales AS (
    SELECT p.Category, SUM(oi.Quantity * oi.UnitPrice) AS Revenue
    FROM dbo.OrderItems AS oi
    JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
    GROUP BY p.Category
)
SELECT Category, Revenue,
       Revenue * 100.0 / NULLIF(SUM(Revenue) OVER (), 0) AS RevenueSharePercent
FROM CategorySales
ORDER BY Revenue DESC;


/* 32. Find customers above average order value */
WITH CustomerSpend AS (
    SELECT CustomerID, AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AvgOrderValue
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT CustomerID, AvgOrderValue
FROM CustomerSpend
WHERE AvgOrderValue > (SELECT AVG(CAST(TotalAmount AS DECIMAL(18,2))) FROM dbo.Orders);


/* 33. Find consecutive orders using LAG */
WITH OrderHistory AS (
    SELECT CustomerID, OrderID, OrderDate,
           LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate, OrderID) AS PreviousOrderDate
    FROM dbo.Orders
)
SELECT CustomerID, OrderID, OrderDate, PreviousOrderDate,
       DATEDIFF(DAY, PreviousOrderDate, OrderDate) AS DaysSincePreviousOrder
FROM OrderHistory;


/* 34. Calculate a 4-row moving average of daily sales (Modified to 4 rows) */
WITH DailySales AS (
    SELECT CAST(OrderDate AS DATE) AS OrderDay, SUM(TotalAmount) AS Sales
    FROM dbo.Orders
    GROUP BY CAST(OrderDate AS DATE)
)
SELECT OrderDay, Sales,
       AVG(CAST(Sales AS DECIMAL(18,2))) OVER (
           ORDER BY OrderDay ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
       ) AS MovingAverage4Rows
FROM DailySales
ORDER BY OrderDay;


/* 35. Find duplicate rows by business key and keep latest */
WITH Duplicates AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC
    ) AS rn
    FROM dbo.Orders
)
SELECT *
FROM Duplicates
WHERE rn = 1;


/* 36. Pivot order counts by status */
SELECT CustomerID,
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedOrders,
       SUM(CASE WHEN Status = 'Shipped' THEN 1 ELSE 0 END) AS ShippedOrders,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS PendingOrders
FROM dbo.Orders
GROUP BY CustomerID;


/* 37. Find the most expensive product in each category */
WITH RankedProducts AS (
    SELECT ProductID, ProductName, Category, Price,
           DENSE_RANK() OVER (PARTITION BY Category ORDER BY Price DESC) AS rn
    FROM dbo.Products
)
SELECT ProductID, ProductName, Category, Price
FROM RankedProducts
WHERE rn = 1;


/* 38. Find customers who ordered in 2026 but not in 2027 (Shifted years) */
SELECT DISTINCT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2026-01-01' AND OrderDate < '2027-01-01'
EXCEPT
SELECT DISTINCT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2027-01-01' AND OrderDate < '2028-01-01';


/* 39. Calculate order value including line items */
SELECT o.OrderID, o.CustomerID, o.OrderDate,
       SUM(oi.Quantity * oi.UnitPrice) AS CalculatedOrderValue
FROM dbo.Orders AS o
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
GROUP BY o.OrderID, o.CustomerID, o.OrderDate;


/* 40. Find orders where stored total differs from line total */
WITH LineTotals AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS LineTotal
    FROM dbo.OrderItems
    GROUP BY OrderID
)
SELECT o.OrderID, o.TotalAmount, l.LineTotal,
       o.TotalAmount - l.LineTotal AS Difference
FROM dbo.Orders AS o
JOIN LineTotals AS l ON l.OrderID = o.OrderID
WHERE ABS(o.TotalAmount - l.LineTotal) > 0.01;


/* 41. Calculate percentage of employees in each department */
SELECT DepartmentID, COUNT(*) AS EmployeeCount,
       COUNT(*) * 100.0 / NULLIF(SUM(COUNT(*)) OVER (), 0) AS PercentOfEmployees
FROM dbo.Employees
GROUP BY DepartmentID;


/* 42. Find employees hired in the last 36 months (Modified to 36) */
SELECT EmployeeID, EmployeeName, HireDate
FROM dbo.Employees
WHERE HireDate >= DATEADD(MONTH, -36, CAST(GETDATE() AS DATE))
  AND HireDate < DATEADD(DAY, 1, CAST(GETDATE() AS DATE));


/* 43. Calculate days between order and shipment */
SELECT OrderID, OrderDate, ShipDate,
       DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Orders
WHERE ShipDate IS NOT NULL;


/* 44. Find the median salary */
SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary)
       OVER () AS MedianSalary
FROM dbo.Employees
WHERE Salary IS NOT NULL;


/* 45. Identify outlier prices using IQR */
WITH Quartiles AS (
    SELECT DISTINCT
           PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Price) OVER () AS Q1,
           PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Price) OVER () AS Q3
    FROM dbo.Products
    WHERE Price IS NOT NULL
)
SELECT p.ProductID, p.ProductName, p.Price, q.Q1, q.Q3
FROM dbo.Products AS p
CROSS JOIN Quartiles AS q
WHERE p.Price < q.Q1 - 1.5 * (q.Q3 - q.Q1)
   OR p.Price > q.Q3 + 1.5 * (q.Q3 - q.Q1);


/* 46. Find missing dates in the order activity calendar */
WITH OrderDays AS (
    SELECT DISTINCT CAST(OrderDate AS DATE) AS OrderDay
    FROM dbo.Orders
),
DateRange AS (
    SELECT MIN(OrderDay) AS StartDay, MAX(OrderDay) AS EndDay
    FROM OrderDays
),
Calendar AS (
    SELECT StartDay AS CalendarDay, EndDay
    FROM DateRange
    UNION ALL
    SELECT DATEADD(DAY, 1, CalendarDay), EndDay
    FROM Calendar
    WHERE CalendarDay < EndDay
)
SELECT c.CalendarDay
FROM Calendar AS c
LEFT JOIN OrderDays AS o ON o.OrderDay = c.CalendarDay
WHERE o.OrderDay IS NULL
OPTION (MAXRECURSION 0);


/* 47. Find customers with orders in at least 1 distinct month */
SELECT CustomerID, COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) AS ActiveMonths
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) >= 1;


/* 48. Calculate customer repeat-purchase rate */
WITH CustomerOrders AS (
    SELECT CustomerID, COUNT(*) AS OrderCount
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT COUNT(CASE WHEN OrderCount >= 2 THEN 1 END) AS RepeatCustomers,
       COUNT(*) AS CustomersWithOrders,
       COUNT(CASE WHEN OrderCount >= 2 THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS RepeatPurchaseRatePercent
FROM CustomerOrders;


/* 49. Calculate customer retention by first-order cohort and next month */
WITH FirstOrder AS (
    SELECT CustomerID, MIN(DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) AS CohortMonth
    FROM dbo.Orders
    GROUP BY CustomerID
),
CustomerActivity AS (
    SELECT DISTINCT CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS ActivityMonth
    FROM dbo.Orders
)
SELECT f.CohortMonth,
       COUNT(DISTINCT f.CustomerID) AS CohortCustomers,
       COUNT(DISTINCT CASE WHEN a.ActivityMonth = DATEADD(MONTH, 1, f.CohortMonth) THEN f.CustomerID END) AS RetainedNextMonth,
       COUNT(DISTINCT CASE WHEN a.ActivityMonth = DATEADD(MONTH, 1, f.CohortMonth) THEN f.CustomerID END) * 100.0
           / NULLIF(COUNT(DISTINCT f.CustomerID), 0) AS NextMonthRetentionPercent
FROM FirstOrder AS f
LEFT JOIN CustomerActivity AS a ON a.CustomerID = f.CustomerID
GROUP BY f.CohortMonth
ORDER BY f.CohortMonth;


/* 50. Inspect query execution plan and IO/time */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT CustomerID, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
WHERE OrderDate >= '2026-01-01' AND OrderDate < '2027-01-01'
GROUP BY CustomerID;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;


/* 51. Daily sales summary (Modified window to last 90 days) */
SELECT CAST(OrderDate AS DATE) AS OrderDay,
       COUNT(*) AS OrderCount,
       SUM(TotalAmount) AS Revenue,
       AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AverageOrderValue
FROM dbo.Orders
WHERE OrderDate >= DATEADD(DAY, -90, CAST(GETDATE() AS DATE))
GROUP BY CAST(OrderDate AS DATE)
ORDER BY OrderDay;


/* 52. Sales by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 53. Sales by region */
SELECT c.Region, COUNT(o.OrderID) AS OrderCount, SUM(o.TotalAmount) AS Revenue
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
GROUP BY c.Region
ORDER BY Revenue DESC;


/* 54. Sales by product category */
SELECT p.Category, SUM(oi.Quantity) AS UnitsSold,
       SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM dbo.OrderItems AS oi
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
GROUP BY p.Category
ORDER BY Revenue DESC;


/* 55. Top 3 customers by lifetime revenue (Modified TOP 3) */
SELECT TOP (3) c.CustomerID, c.CustomerName,
       SUM(o.TotalAmount) AS LifetimeRevenue
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY LifetimeRevenue DESC;


/* 56. Top 3 products by units sold (Modified TOP 3) */
SELECT TOP (3) p.ProductID, p.ProductName,
       SUM(oi.Quantity) AS UnitsSold
FROM dbo.OrderItems AS oi
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY UnitsSold DESC;


/* 57. Revenue by order status */
SELECT Status, COUNT(*) AS OrderCount, SUM(TotalAmount) AS TotalAmount
FROM dbo.Orders
GROUP BY Status
ORDER BY TotalAmount DESC;


/* 58. Cancellation rate */
SELECT COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) AS CancelledOrders,
       COUNT(*) AS TotalOrders,
       COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS CancellationRatePercent
FROM dbo.Orders;


/* 59. Average order value by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AverageOrderValue
FROM dbo.Orders
WHERE TotalAmount IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 60. Customers who have not ordered in 120 days (Modified to 120 days) */
SELECT c.CustomerID, c.CustomerName, MAX(o.OrderDate) AS LastOrderDate
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING MAX(o.OrderDate) IS NULL
    OR MAX(o.OrderDate) < DATEADD(DAY, -120, GETDATE());


/* 61. Customers who ordered this month */
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderDate >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
  AND o.OrderDate < DATEADD(MONTH, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1));


/* 62. Orders above the overall average order value */
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE TotalAmount > (SELECT AVG(CAST(TotalAmount AS DECIMAL(18,2))) FROM dbo.Orders);


/* 63. Daily order count by status */
SELECT CAST(OrderDate AS DATE) AS OrderDay,
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS Completed,
       SUM(CASE WHEN Status = 'Shipped' THEN 1 ELSE 0 END) AS Shipped,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS Pending
FROM dbo.Orders
GROUP BY CAST(OrderDate AS DATE)
ORDER BY OrderDay;


/* 64. Check duplicate customer records */
SELECT CustomerName, Email, COUNT(*) AS RecordCount
FROM dbo.Customers
GROUP BY CustomerName, Email
HAVING COUNT(*) > 1;


/* 65. Check duplicate order IDs */
SELECT OrderID, COUNT(*) AS RecordCount
FROM dbo.Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;


/* 66. Check missing required values */
SELECT
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS MissingOrderDate,
    SUM(CASE WHEN TotalAmount IS NULL THEN 1 ELSE 0 END) AS MissingTotalAmount
FROM dbo.Orders;


/* 67. Find negative or zero order amounts */
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE TotalAmount <= 0;


/* 68. Find negative prices or quantities */
SELECT OrderID, ProductID, Quantity, UnitPrice
FROM dbo.OrderItems
WHERE Quantity <= 0 OR UnitPrice < 0;


/* 69. Find orders with no matching customer */
SELECT o.*
FROM dbo.Orders AS o
LEFT JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL;


/* 70. Find order items with no matching product */
SELECT oi.*
FROM dbo.OrderItems AS oi
LEFT JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
WHERE p.ProductID IS NULL;


/* 71. Standardize text for review (trim and lowercase) */
SELECT CustomerID, CustomerName, Email,
       LOWER(LTRIM(RTRIM(Email))) AS StandardizedEmail
FROM dbo.Customers;


/* 72. Find leading/trailing spaces in customer names */
SELECT CustomerID, CustomerName
FROM dbo.Customers
WHERE CustomerName <> LTRIM(RTRIM(CustomerName));


/* 73. Count distinct customers per month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       COUNT(DISTINCT CustomerID) AS ActiveCustomers
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 74. Compare current month and previous month revenue */
WITH MonthlyRevenue AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
)
SELECT SalesMonth, Revenue,
       LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue,
       Revenue - LAG(Revenue) OVER (ORDER BY SalesMonth) AS RevenueChange
FROM MonthlyRevenue
ORDER BY SalesMonth;


/* 75. Year-over-year revenue comparison */
WITH YearlyRevenue AS (
    SELECT YEAR(OrderDate) AS SalesYear, SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY YEAR(OrderDate)
)
SELECT SalesYear, Revenue,
       LAG(Revenue) OVER (ORDER BY SalesYear) AS PreviousYearRevenue,
       (Revenue - LAG(Revenue) OVER (ORDER BY SalesYear)) * 100.0
           / NULLIF(LAG(Revenue) OVER (ORDER BY SalesYear), 0) AS YoYPercentChange
FROM YearlyRevenue
ORDER BY SalesYear;


/* 76. Revenue by weekday */
SELECT DATENAME(WEEKDAY, OrderDate) AS WeekdayName,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATENAME(WEEKDAY, OrderDate), DATEPART(WEEKDAY, OrderDate)
ORDER BY DATEPART(WEEKDAY, OrderDate);


/* 77. Revenue by hour of day */
ALTER TABLE dbo.Orders
ALTER COLUMN OrderDate DATETIME2;

UPDATE dbo.Orders SET OrderDate = '2026-01-15 09:30:00' WHERE OrderID = 5001;
UPDATE dbo.Orders SET OrderDate = '2026-03-01 14:15:00' WHERE OrderID = 5002;
UPDATE dbo.Orders SET OrderDate = '2026-06-20 11:00:00' WHERE OrderID = 5003;
UPDATE dbo.Orders SET OrderDate = '2026-09-10 16:45:00' WHERE OrderID = 5004;
UPDATE dbo.Orders SET OrderDate = '2026-10-05 08:20:00' WHERE OrderID = 5005;

SELECT DATEPART(HOUR, OrderDate) AS OrderHour,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEPART(HOUR, OrderDate)
ORDER BY OrderHour;


/* 78. Average shipping time by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS OrderMonth,
       AVG(CAST(DATEDIFF(DAY, OrderDate, ShipDate) AS DECIMAL(10,2))) AS AvgDaysToShip
FROM dbo.Orders
WHERE ShipDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY OrderMonth;


/* 79. Late shipments (Modified threshold to > 4 days) */
SELECT OrderID, OrderDate, ShipDate,
       DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Orders
WHERE ShipDate > DATEADD(DAY, 4, OrderDate);


/* 80. Products below reorder level */
SELECT ProductID, ProductName, StockQuantity, ReorderLevel
FROM dbo.Products
WHERE StockQuantity <= ReorderLevel;


/* 81. Inventory value by category */
SELECT Category,
       SUM(CAST(StockQuantity AS DECIMAL(18,2)) * Price) AS InventoryValue
FROM dbo.Products
GROUP BY Category
ORDER BY InventoryValue DESC;


/* 82. Calculate gross margin per product */
SELECT ProductID, ProductName, Price, CostPrice,
       Price - CostPrice AS GrossProfitPerUnit,
       (Price - CostPrice) * 100.0 / NULLIF(Price, 0) AS GrossMarginPercent
FROM dbo.Products
WHERE Price IS NOT NULL AND CostPrice IS NOT NULL;


/* 83. Discount analysis */
SELECT ProductID, ProductName, OriginalPrice, Price,
       OriginalPrice - Price AS DiscountAmount,
       (OriginalPrice - Price) * 100.0 / NULLIF(OriginalPrice, 0) AS DiscountPercent
FROM dbo.Products
WHERE OriginalPrice > 0 AND Price IS NOT NULL;


/* 84. Average salary by department */
SELECT d.DepartmentName,
       AVG(CAST(e.Salary AS DECIMAL(18,2))) AS AverageSalary,
       MIN(e.Salary) AS MinimumSalary,
       MAX(e.Salary) AS MaximumSalary,
       COUNT(*) AS EmployeeCount
FROM dbo.Employees AS e
JOIN dbo.Departments AS d ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY AverageSalary DESC;


/* 85. Headcount by department */
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS Headcount
FROM dbo.Departments AS d
LEFT JOIN dbo.Employees AS e ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY Headcount DESC;


/* 86. Employees missing a department match */
SELECT e.EmployeeID, e.EmployeeName, e.DepartmentID
FROM dbo.Employees AS e
LEFT JOIN dbo.Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentID IS NULL;


/* 87. New hires by month */
SELECT DATEFROMPARTS(YEAR(HireDate), MONTH(HireDate), 1) AS HireMonth,
       COUNT(*) AS NewHires
FROM dbo.Employees
WHERE HireDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(HireDate), MONTH(HireDate), 1)
ORDER BY HireMonth;


/* 88. Employee salary compared with department average */
SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
       AVG(CAST(Salary AS DECIMAL(18,2))) OVER (PARTITION BY DepartmentID) AS DepartmentAverage
FROM dbo.Employees;


/* 89. Find customers with multiple orders on the same day */
SELECT CustomerID, CAST(OrderDate AS DATE) AS OrderDay, COUNT(*) AS OrdersThatDay
FROM dbo.Orders
GROUP BY CustomerID, CAST(OrderDate AS DATE)
HAVING COUNT(*) > 1;


/* 90. Calculate order-item contribution to order total */
WITH LineValues AS (
    SELECT OrderID, ProductID, Quantity * UnitPrice AS LineValue
    FROM dbo.OrderItems
),
OrderValues AS (
    SELECT OrderID, SUM(LineValue) AS OrderValue
    FROM LineValues
    GROUP BY OrderID
)
SELECT l.OrderID, l.ProductID, l.LineValue, o.OrderValue,
       l.LineValue * 100.0 / NULLIF(o.OrderValue, 0) AS PercentOfOrder
FROM LineValues AS l
JOIN OrderValues AS o ON o.OrderID = l.OrderID;


/* 91. Identify customers whose spending declined month over month */
WITH CustomerMonthlySpend AS (
    SELECT CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS MonthlySpend
    FROM dbo.Orders
    GROUP BY CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
SpendComparison AS (
    SELECT CustomerID, SalesMonth, MonthlySpend,
           LAG(MonthlySpend) OVER (PARTITION BY CustomerID ORDER BY SalesMonth) AS PreviousMonthSpend
    FROM CustomerMonthlySpend
)
SELECT CustomerID, SalesMonth, MonthlySpend, PreviousMonthSpend
FROM SpendComparison
WHERE PreviousMonthSpend IS NOT NULL AND MonthlySpend < PreviousMonthSpend;


/* 92. Segment customers by lifetime spending (Modified thresholds: 3000 / 1500) */
WITH CustomerSpend AS (
    SELECT c.CustomerID, c.CustomerName, COALESCE(SUM(o.TotalAmount), 0) AS LifetimeSpend
    FROM dbo.Customers AS c
    LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT *, CASE WHEN LifetimeSpend >= 3000 THEN 'Tier 1 Executive'
               WHEN LifetimeSpend >= 1500 THEN 'Tier 2 Corporate'
               ELSE 'Tier 3 Retail' END AS CustomerSegment
FROM CustomerSpend;


/* 93. Calculate RFM-style recency, frequency, monetary value */
SELECT c.CustomerID, c.CustomerName,
       MAX(o.OrderDate) AS LastOrderDate,
       DATEDIFF(DAY, MAX(o.OrderDate), CAST(GETDATE() AS DATE)) AS RecencyDays,
       COUNT(o.OrderID) AS Frequency,
       COALESCE(SUM(o.TotalAmount), 0) AS MonetaryValue
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName;


/* 94. Find customers with a high-value recent order (Modified threshold >= 2000) */
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.TotalAmount >= 2000
  AND o.OrderDate >= DATEADD(DAY, -60, GETDATE());


/* 95. Weekly sales summary */
SELECT DATEADD(DAY, 1 - DATEPART(WEEKDAY, CAST(OrderDate AS DATE)), CAST(OrderDate AS DATE)) AS WeekStart,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEADD(DAY, 1 - DATEPART(WEEKDAY, CAST(OrderDate AS DATE)), CAST(OrderDate AS DATE))
ORDER BY WeekStart;


/* 96. Build a reusable filtered dataset with a CTE */
WITH RecentCompletedOrders AS (
    SELECT OrderID, CustomerID, OrderDate, TotalAmount
    FROM dbo.Orders
    WHERE Status = 'Completed'
      AND OrderDate >= DATEADD(MONTH, -12, GETDATE())
)
SELECT CustomerID, COUNT(*) AS CompletedOrders, SUM(TotalAmount) AS Revenue
FROM RecentCompletedOrders
GROUP BY CustomerID
ORDER BY Revenue DESC;


/* 97. Create a temporary table for repeated analysis */
DROP TABLE IF EXISTS #MonthlySales;

SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       SUM(TotalAmount) AS Revenue
INTO #MonthlySales
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1);

SELECT SalesMonth, Revenue
FROM #MonthlySales
ORDER BY SalesMonth;


/* 98. Add a nonclustered index for a common filter */
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate
ON dbo.Orders (OrderDate)
INCLUDE (CustomerID, Status, TotalAmount);


/* 99. Safely test a data update inside a transaction */
BEGIN TRANSACTION;

UPDATE dbo.Products
SET Price = Price * 1.08
WHERE Category = 'Software';

-- Check affected rows and values before deciding:
SELECT ProductID, ProductName, Category, Price
FROM dbo.Products
WHERE Category = 'Software';

-- Run ONE of these after reviewing the result:
-- COMMIT TRANSACTION;
-- ROLLBACK TRANSACTION;


/* 100. Produce a compact data-quality summary for core tables */
SELECT 'Departments' AS TableName, COUNT(*) AS "RowCount" FROM dbo.Departments
UNION ALL
SELECT 'Employees', COUNT(*) FROM dbo.Employees
UNION ALL
SELECT 'Customers', COUNT(*) FROM dbo.Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM dbo.Orders
UNION ALL
SELECT 'OrderItems', COUNT(*) FROM dbo.OrderItems
UNION ALL
SELECT 'Products', COUNT(*) FROM dbo.Products;


/*
SQL SERVER DATA ANALYST PRACTICE LIBRARY — ROUND 4 (QUERIES 01–100)
===================================================================

Dialect: Microsoft SQL Server (T-SQL)
Description: Round 4 iteration featuring fresh sample seed data, shifted 
date baselines (2027/2028), updated numerical filter thresholds, and modified 
parameters while keeping the exact same 100 core query patterns.
*/

CREATE DATABASE SQLMastery_Round4;
GO
USE SQLMastery_Round4;
GO

-- ============================================================================
-- SETUP BLOCK: MOCK SCHEMA & ROUND 4 SEED DATA
-- ============================================================================
CREATE TABLE dbo.Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE dbo.Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeName VARCHAR(100),
    DepartmentID INT FOREIGN KEY REFERENCES dbo.Departments(DepartmentID),
    Salary DECIMAL(18,2),
    HireDate DATE
);

CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50),
    Region VARCHAR(50)
);

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES dbo.Customers(CustomerID),
    OrderDate DATE,
    ShipDate DATE,
    Status VARCHAR(50),
    TotalAmount DECIMAL(18,2)
);

CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(18,2),
    CostPrice DECIMAL(18,2),
    OriginalPrice DECIMAL(18,2),
    StockQuantity INT,
    ReorderLevel INT
);

CREATE TABLE dbo.OrderItems (
    OrderID INT FOREIGN KEY REFERENCES dbo.Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES dbo.Products(ProductID),
    Quantity INT,
    UnitPrice DECIMAL(18,2)
);

-- Seed Sample Data (Round 4 Fresh Values)
INSERT INTO dbo.Departments VALUES 
(100, 'Business Intelligence'), 
(200, 'DevOps Engineering'), 
(300, 'Global Accounts'), 
(400, 'Quality Assurance');

INSERT INTO dbo.Employees (EmployeeName, DepartmentID, Salary, HireDate) VALUES 
('Ziad Tarek', 100, 120000.00, '2022-01-15'),
('Salma Ahmed', 100, 105000.00, '2023-04-10'),
('Karim Fathy', 200, 130000.00, '2021-11-05'),
('Dina Mostafa', 300, 95000.00, '2024-02-20'),
('Tamer Hosny', 400, 88000.00, '2025-05-12');

INSERT INTO dbo.Customers VALUES 
(901, 'Alpha Dynamics', 'support@alphadyn.com', 'London', 'UK'),
(902, 'Omega Systems', NULL, 'Berlin', 'EU'),
(903, 'Prime Logistics', 'ops@primelog.com', 'Paris', 'EU'),
(904, 'Vanguard Group', 'contact@vanguard.org', 'London', 'UK');

INSERT INTO dbo.Products VALUES 
(301, 'Neural Processing Unit', 'Hardware', 4500.00, 3200.00, 4800.00, 3, 10),
(302, 'Enterprise Analytics Core', 'Software', 1250.00, 400.00, 1400.00, 80, 25),
(303, 'Cloud Security Audit', 'Services', 2500.00, 800.00, 2800.00, 15, 5),
(304, 'Storage Blade 10TB', 'Hardware', 1800.00, 1300.00, 1950.00, 25, 12);

INSERT INTO dbo.Orders VALUES 
(9001, 901, '2027-02-10', '2027-02-12', 'Completed', 5750.00),
(9002, 902, '2027-04-05', '2027-04-10', 'Completed', 1250.00),
(9003, 901, '2027-07-15', '2027-07-18', 'Shipped', 2500.00),
(9004, 903, '2027-09-01', NULL, 'Pending', 4500.00),
(9005, 904, '2027-11-20', '2027-11-22', 'Completed', 3050.00);

INSERT INTO dbo.OrderItems VALUES 
(9001, 301, 1, 4500.00),
(9001, 302, 1, 1250.00),
(9002, 302, 1, 1250.00),
(9003, 303, 1, 2500.00),
(9004, 301, 1, 4500.00),
(9005, 302, 1, 1250.00),
(9005, 304, 1, 1800.00);
GO


/* 01. Filter rows with WHERE */
SELECT OrderID, CustomerID, OrderDate, Status
FROM dbo.Orders
WHERE Status = 'Completed';


/* 02. Sort results */
SELECT ProductID, ProductName, Price
FROM dbo.Products
ORDER BY Price DESC;


/* 03. Return the top 10 records */
SELECT TOP (10) OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
ORDER BY TotalAmount DESC;


/* 04. Find distinct categories */
SELECT DISTINCT Category
FROM dbo.Products
ORDER BY Category;


/* 05. Count all rows vs non-NULL values */
SELECT COUNT(*) AS TotalRows,
       COUNT(Email) AS RowsWithEmail
FROM dbo.Customers;


/* 06. Find NULL values */
SELECT CustomerID, CustomerName, Email
FROM dbo.Customers
WHERE Email IS NULL;


/* 07. Use CASE to classify values */
SELECT ProductID, ProductName, Price,
       CASE WHEN Price >= 3000 THEN 'High'
            WHEN Price >= 1500 THEN 'Medium'
            ELSE 'Low' END AS PriceBand
FROM dbo.Products;


/* 08. Aggregate with GROUP BY */
SELECT Status, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY Status;


/* 09. Filter groups with HAVING */
SELECT CustomerID, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(*) >= 2;


/* 10. Calculate average salary */
SELECT AVG(CAST(Salary AS DECIMAL(18,2))) AS AverageSalary
FROM dbo.Employees;


/* 11. INNER JOIN two tables */
SELECT o.OrderID, c.CustomerName, o.OrderDate
FROM dbo.Orders AS o
INNER JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID;


/* 12. LEFT JOIN to keep unmatched customers */
SELECT c.CustomerID, c.CustomerName, o.OrderID
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID;


/* 13. Find customers with no orders */
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;


/* 14. Find products never ordered */
SELECT p.ProductID, p.ProductName
FROM dbo.Products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.OrderItems AS oi
    WHERE oi.ProductID = p.ProductID
);


/* 15. Join three tables */
SELECT o.OrderID, c.CustomerName, p.ProductName, oi.Quantity
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID;


/* 16. UNION vs UNION ALL pattern */
SELECT City FROM dbo.Customers
UNION
SELECT Region FROM dbo.Customers;


/* 17. Find duplicate emails */
SELECT Email, COUNT(*) AS DuplicateCount
FROM dbo.Customers
WHERE Email IS NOT NULL
GROUP BY Email
HAVING COUNT(*) > 1;


/* 18. Find the second-highest distinct salary */
WITH SalaryRanks AS (
    SELECT Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM dbo.Employees
    WHERE Salary IS NOT NULL
)
SELECT DISTINCT Salary
FROM SalaryRanks
WHERE SalaryRank = 2;


/* 19. Find the Nth-highest salary (change @N) */
DECLARE @N INT = 2;
WITH SalaryRanks AS (
    SELECT EmployeeID, EmployeeName, Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM dbo.Employees
    WHERE Salary IS NOT NULL
)
SELECT EmployeeID, EmployeeName, Salary
FROM SalaryRanks
WHERE SalaryRank = @N;


/* 20. Rank employees within each department */
SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
       RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
FROM dbo.Employees;


/* 21. Top 3 employees per department */
WITH RankedEmployees AS (
    SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
           ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC, EmployeeID) AS rn
    FROM dbo.Employees
)
SELECT EmployeeID, EmployeeName, DepartmentID, Salary
FROM RankedEmployees
WHERE rn <= 3;


/* 22. Compare ROW_NUMBER, RANK, DENSE_RANK */
SELECT EmployeeID, EmployeeName, Salary,
       ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNum,
       RANK() OVER (ORDER BY Salary DESC) AS SalaryRank,
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseSalaryRank
FROM dbo.Employees;


/* 23. Find employees paid above company average */
SELECT EmployeeID, EmployeeName, Salary
FROM dbo.Employees
WHERE Salary > (SELECT AVG(CAST(Salary AS DECIMAL(18,2))) FROM dbo.Employees);


/* 24. Find employees paid above their department average */
WITH DepartmentAverages AS (
    SELECT DepartmentID, AVG(CAST(Salary AS DECIMAL(18,2))) AS AvgSalary
    FROM dbo.Employees
    GROUP BY DepartmentID
)
SELECT e.EmployeeID, e.EmployeeName, e.DepartmentID, e.Salary
FROM dbo.Employees AS e
JOIN DepartmentAverages AS d ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > d.AvgSalary;


/* 25. Use a CTE to calculate order totals */
WITH OrderTotals AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS CalculatedTotal
    FROM dbo.OrderItems
    GROUP BY OrderID
)
SELECT OrderID, CalculatedTotal
FROM OrderTotals
ORDER BY CalculatedTotal DESC;


/* 26. Use EXISTS to find customers with orders */
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
WHERE EXISTS (
    SELECT 1 FROM dbo.Orders AS o
    WHERE o.CustomerID = c.CustomerID
);


/* 27. Find the latest order for each customer */
WITH RankedOrders AS (
    SELECT OrderID, CustomerID, OrderDate,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC) AS rn
    FROM dbo.Orders
)
SELECT OrderID, CustomerID, OrderDate
FROM RankedOrders
WHERE rn = 1;


/* 28. Find each customer's first order */
SELECT CustomerID, MIN(OrderDate) AS FirstOrderDate
FROM dbo.Orders
GROUP BY CustomerID;


/* 29. Calculate a running sales total */
WITH DailySales AS (
    SELECT CAST(OrderDate AS DATE) AS OrderDay, SUM(TotalAmount) AS Sales
    FROM dbo.Orders
    GROUP BY CAST(OrderDate AS DATE)
)
SELECT OrderDay, Sales,
       SUM(Sales) OVER (ORDER BY OrderDay ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningSales
FROM DailySales
ORDER BY OrderDay;


/* 30. Compare each month with the previous month */
WITH MonthlySales AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
SalesComparison AS (
    SELECT SalesMonth, Revenue,
           LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue
    FROM MonthlySales
)
SELECT SalesMonth, Revenue, PreviousMonthRevenue,
       (Revenue - PreviousMonthRevenue) * 100.0 / NULLIF(PreviousMonthRevenue, 0) AS MoMPercentChange
FROM SalesComparison
ORDER BY SalesMonth;


/* 31. Calculate each category's share of revenue */
WITH CategorySales AS (
    SELECT p.Category, SUM(oi.Quantity * oi.UnitPrice) AS Revenue
    FROM dbo.OrderItems AS oi
    JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
    GROUP BY p.Category
)
SELECT Category, Revenue,
       Revenue * 100.0 / NULLIF(SUM(Revenue) OVER (), 0) AS RevenueSharePercent
FROM CategorySales
ORDER BY Revenue DESC;


/* 32. Find customers above average order value */
WITH CustomerSpend AS (
    SELECT CustomerID, AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AvgOrderValue
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT CustomerID, AvgOrderValue
FROM CustomerSpend
WHERE AvgOrderValue > (SELECT AVG(CAST(TotalAmount AS DECIMAL(18,2))) FROM dbo.Orders);


/* 33. Find consecutive orders using LAG */
WITH OrderHistory AS (
    SELECT CustomerID, OrderID, OrderDate,
           LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate, OrderID) AS PreviousOrderDate
    FROM dbo.Orders
)
SELECT CustomerID, OrderID, OrderDate, PreviousOrderDate,
       DATEDIFF(DAY, PreviousOrderDate, OrderDate) AS DaysSincePreviousOrder
FROM OrderHistory;


/* 34. Calculate a 3-row moving average of daily sales */
WITH DailySales AS (
    SELECT CAST(OrderDate AS DATE) AS OrderDay, SUM(TotalAmount) AS Sales
    FROM dbo.Orders
    GROUP BY CAST(OrderDate AS DATE)
)
SELECT OrderDay, Sales,
       AVG(CAST(Sales AS DECIMAL(18,2))) OVER (
           ORDER BY OrderDay ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS MovingAverage3Rows
FROM DailySales
ORDER BY OrderDay;


/* 35. Find duplicate rows by business key and keep latest */
WITH Duplicates AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC
    ) AS rn
    FROM dbo.Orders
)
SELECT *
FROM Duplicates
WHERE rn = 1;


/* 36. Pivot order counts by status */
SELECT CustomerID,
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedOrders,
       SUM(CASE WHEN Status = 'Shipped' THEN 1 ELSE 0 END) AS ShippedOrders,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS PendingOrders
FROM dbo.Orders
GROUP BY CustomerID;


/* 37. Find the most expensive product in each category */
WITH RankedProducts AS (
    SELECT ProductID, ProductName, Category, Price,
           DENSE_RANK() OVER (PARTITION BY Category ORDER BY Price DESC) AS rn
    FROM dbo.Products
)
SELECT ProductID, ProductName, Category, Price
FROM RankedProducts
WHERE rn = 1;


/* 38. Find customers who ordered in one year but not another (Shifted to 2027/2028) */
SELECT DISTINCT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2027-01-01' AND OrderDate < '2028-01-01'
EXCEPT
SELECT DISTINCT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2028-01-01' AND OrderDate < '2029-01-01';


/* 39. Calculate order value including line items */
SELECT o.OrderID, o.CustomerID, o.OrderDate,
       SUM(oi.Quantity * oi.UnitPrice) AS CalculatedOrderValue
FROM dbo.Orders AS o
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
GROUP BY o.OrderID, o.CustomerID, o.OrderDate;


/* 40. Find orders where stored total differs from line total */
WITH LineTotals AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS LineTotal
    FROM dbo.OrderItems
    GROUP BY OrderID
)
SELECT o.OrderID, o.TotalAmount, l.LineTotal,
       o.TotalAmount - l.LineTotal AS Difference
FROM dbo.Orders AS o
JOIN LineTotals AS l ON l.OrderID = o.OrderID
WHERE ABS(o.TotalAmount - l.LineTotal) > 0.01;


/* 41. Calculate percentage of employees in each department */
SELECT DepartmentID, COUNT(*) AS EmployeeCount,
       COUNT(*) * 100.0 / NULLIF(SUM(COUNT(*)) OVER (), 0) AS PercentOfEmployees
FROM dbo.Employees
GROUP BY DepartmentID;


/* 42. Find employees hired in the last 12 months */
SELECT EmployeeID, EmployeeName, HireDate
FROM dbo.Employees
WHERE HireDate >= DATEADD(MONTH, -12, CAST(GETDATE() AS DATE))
  AND HireDate < DATEADD(DAY, 1, CAST(GETDATE() AS DATE));


/* 43. Calculate days between order and shipment */
SELECT OrderID, OrderDate, ShipDate,
       DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Orders
WHERE ShipDate IS NOT NULL;


/* 44. Find the median salary */
SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary)
       OVER () AS MedianSalary
FROM dbo.Employees
WHERE Salary IS NOT NULL;


/* 45. Identify outlier prices using IQR */
WITH Quartiles AS (
    SELECT DISTINCT
           PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Price) OVER () AS Q1,
           PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Price) OVER () AS Q3
    FROM dbo.Products
    WHERE Price IS NOT NULL
)
SELECT p.ProductID, p.ProductName, p.Price, q.Q1, q.Q3
FROM dbo.Products AS p
CROSS JOIN Quartiles AS q
WHERE p.Price < q.Q1 - 1.5 * (q.Q3 - q.Q1)
   OR p.Price > q.Q3 + 1.5 * (q.Q3 - q.Q1);


/* 46. Find missing dates in the order activity calendar */
WITH OrderDays AS (
    SELECT DISTINCT CAST(OrderDate AS DATE) AS OrderDay
    FROM dbo.Orders
),
DateRange AS (
    SELECT MIN(OrderDay) AS StartDay, MAX(OrderDay) AS EndDay
    FROM OrderDays
),
Calendar AS (
    SELECT StartDay AS CalendarDay, EndDay
    FROM DateRange
    UNION ALL
    SELECT DATEADD(DAY, 1, CalendarDay), EndDay
    FROM Calendar
    WHERE CalendarDay < EndDay
)
SELECT c.CalendarDay
FROM Calendar AS c
LEFT JOIN OrderDays AS o ON o.OrderDay = c.CalendarDay
WHERE o.OrderDay IS NULL
OPTION (MAXRECURSION 0);


/* 47. Find customers with orders in at least 3 distinct months */
SELECT CustomerID, COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) AS ActiveMonths
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) >= 3;


/* 48. Calculate customer repeat-purchase rate */
WITH CustomerOrders AS (
    SELECT CustomerID, COUNT(*) AS OrderCount
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT COUNT(CASE WHEN OrderCount >= 2 THEN 1 END) AS RepeatCustomers,
       COUNT(*) AS CustomersWithOrders,
       COUNT(CASE WHEN OrderCount >= 2 THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS RepeatPurchaseRatePercent
FROM CustomerOrders;


/* 49. Calculate customer retention by first-order cohort and next month */
WITH FirstOrder AS (
    SELECT CustomerID, MIN(DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) AS CohortMonth
    FROM dbo.Orders
    GROUP BY CustomerID
),
CustomerActivity AS (
    SELECT DISTINCT CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS ActivityMonth
    FROM dbo.Orders
)
SELECT f.CohortMonth,
       COUNT(DISTINCT f.CustomerID) AS CohortCustomers,
       COUNT(DISTINCT CASE WHEN a.ActivityMonth = DATEADD(MONTH, 1, f.CohortMonth) THEN f.CustomerID END) AS RetainedNextMonth,
       COUNT(DISTINCT CASE WHEN a.ActivityMonth = DATEADD(MONTH, 1, f.CohortMonth) THEN f.CustomerID END) * 100.0
           / NULLIF(COUNT(DISTINCT f.CustomerID), 0) AS NextMonthRetentionPercent
FROM FirstOrder AS f
LEFT JOIN CustomerActivity AS a ON a.CustomerID = f.CustomerID
GROUP BY f.CohortMonth
ORDER BY f.CohortMonth;


/* 50. Inspect query execution plan and IO/time (Shifted to 2027) */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT CustomerID, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
WHERE OrderDate >= '2027-01-01' AND OrderDate < '2028-01-01'
GROUP BY CustomerID;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;


/* 51. Daily sales summary */
SELECT CAST(OrderDate AS DATE) AS OrderDay,
       COUNT(*) AS OrderCount,
       SUM(TotalAmount) AS Revenue,
       AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AverageOrderValue
FROM dbo.Orders
WHERE OrderDate >= DATEADD(DAY, -30, CAST(GETDATE() AS DATE))
GROUP BY CAST(OrderDate AS DATE)
ORDER BY OrderDay;


/* 52. Sales by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 53. Sales by region */
SELECT c.Region, COUNT(o.OrderID) AS OrderCount, SUM(o.TotalAmount) AS Revenue
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
GROUP BY c.Region
ORDER BY Revenue DESC;


/* 54. Sales by product category */
SELECT p.Category, SUM(oi.Quantity) AS UnitsSold,
       SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM dbo.OrderItems AS oi
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
GROUP BY p.Category
ORDER BY Revenue DESC;


/* 55. Top 10 customers by lifetime revenue */
SELECT TOP (10) c.CustomerID, c.CustomerName,
       SUM(o.TotalAmount) AS LifetimeRevenue
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY LifetimeRevenue DESC;


/* 56. Top 10 products by units sold */
SELECT TOP (10) p.ProductID, p.ProductName,
       SUM(oi.Quantity) AS UnitsSold
FROM dbo.OrderItems AS oi
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY UnitsSold DESC;


/* 57. Revenue by order status */
SELECT Status, COUNT(*) AS OrderCount, SUM(TotalAmount) AS TotalAmount
FROM dbo.Orders
GROUP BY Status
ORDER BY TotalAmount DESC;


/* 58. Cancellation rate */
SELECT COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) AS CancelledOrders,
       COUNT(*) AS TotalOrders,
       COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS CancellationRatePercent
FROM dbo.Orders;


/* 59. Average order value by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AverageOrderValue
FROM dbo.Orders
WHERE TotalAmount IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 60. Customers who have not ordered in 90 days */
SELECT c.CustomerID, c.CustomerName, MAX(o.OrderDate) AS LastOrderDate
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING MAX(o.OrderDate) IS NULL
    OR MAX(o.OrderDate) < DATEADD(DAY, -90, GETDATE());


/* 61. Customers who ordered this month */
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderDate >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
  AND o.OrderDate < DATEADD(MONTH, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1));


/* 62. Orders above the overall average order value */
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE TotalAmount > (SELECT AVG(CAST(TotalAmount AS DECIMAL(18,2))) FROM dbo.Orders);


/* 63. Daily order count by status */
SELECT CAST(OrderDate AS DATE) AS OrderDay,
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS Completed,
       SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS Pending
FROM dbo.Orders
GROUP BY CAST(OrderDate AS DATE)
ORDER BY OrderDay;


/* 64. Check duplicate customer records */
SELECT CustomerName, Email, COUNT(*) AS RecordCount
FROM dbo.Customers
GROUP BY CustomerName, Email
HAVING COUNT(*) > 1;


/* 65. Check duplicate order IDs */
SELECT OrderID, COUNT(*) AS RecordCount
FROM dbo.Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;


/* 66. Check missing required values */
SELECT
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS MissingOrderDate,
    SUM(CASE WHEN TotalAmount IS NULL THEN 1 ELSE 0 END) AS MissingTotalAmount
FROM dbo.Orders;


/* 67. Find negative or zero order amounts */
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE TotalAmount <= 0;


/* 68. Find negative prices or quantities */
SELECT OrderID, ProductID, Quantity, UnitPrice
FROM dbo.OrderItems
WHERE Quantity <= 0 OR UnitPrice < 0;


/* 69. Find orders with no matching customer */
SELECT o.*
FROM dbo.Orders AS o
LEFT JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL;


/* 70. Find order items with no matching product */
SELECT oi.*
FROM dbo.OrderItems AS oi
LEFT JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
WHERE p.ProductID IS NULL;


/* 71. Standardize text for review (trim and lowercase) */
SELECT CustomerID, CustomerName, Email,
       LOWER(LTRIM(RTRIM(Email))) AS StandardizedEmail
FROM dbo.Customers;


/* 72. Find leading/trailing spaces in customer names */
SELECT CustomerID, CustomerName
FROM dbo.Customers
WHERE CustomerName <> LTRIM(RTRIM(CustomerName));


/* 73. Count distinct customers per month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       COUNT(DISTINCT CustomerID) AS ActiveCustomers
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 74. Compare current month and previous month revenue */
WITH MonthlyRevenue AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
)
SELECT SalesMonth, Revenue,
       LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue,
       Revenue - LAG(Revenue) OVER (ORDER BY SalesMonth) AS RevenueChange
FROM MonthlyRevenue
ORDER BY SalesMonth;


/* 75. Year-over-year revenue comparison */
WITH YearlyRevenue AS (
    SELECT YEAR(OrderDate) AS SalesYear, SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY YEAR(OrderDate)
)
SELECT SalesYear, Revenue,
       LAG(Revenue) OVER (ORDER BY SalesYear) AS PreviousYearRevenue,
       (Revenue - LAG(Revenue) OVER (ORDER BY SalesYear)) * 100.0
           / NULLIF(LAG(Revenue) OVER (ORDER BY SalesYear), 0) AS YoYPercentChange
FROM YearlyRevenue
ORDER BY SalesYear;


/* 76. Revenue by weekday */
SELECT DATENAME(WEEKDAY, OrderDate) AS WeekdayName,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATENAME(WEEKDAY, OrderDate), DATEPART(WEEKDAY, OrderDate)
ORDER BY DATEPART(WEEKDAY, OrderDate);


/* 77. Revenue by hour of day */
SELECT DATEPART(HOUR, OrderDate) AS OrderHour,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEPART(HOUR, OrderDate)
ORDER BY OrderHour;


/* 78. Average shipping time by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS OrderMonth,
       AVG(CAST(DATEDIFF(DAY, OrderDate, ShipDate) AS DECIMAL(10,2))) AS AvgDaysToShip
FROM dbo.Orders
WHERE ShipDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY OrderMonth;


/* 79. Late shipments */
SELECT OrderID, OrderDate, ShipDate,
       DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Orders
WHERE ShipDate > DATEADD(DAY, 3, OrderDate);


/* 80. Products below reorder level */
SELECT ProductID, ProductName, StockQuantity, ReorderLevel
FROM dbo.Products
WHERE StockQuantity <= ReorderLevel;


/* 81. Inventory value by category */
SELECT Category,
       SUM(CAST(StockQuantity AS DECIMAL(18,2)) * Price) AS InventoryValue
FROM dbo.Products
GROUP BY Category
ORDER BY InventoryValue DESC;


/* 82. Calculate gross margin per product (requires CostPrice) */
SELECT ProductID, ProductName, Price, CostPrice,
       Price - CostPrice AS GrossProfitPerUnit,
       (Price - CostPrice) * 100.0 / NULLIF(Price, 0) AS GrossMarginPercent
FROM dbo.Products
WHERE Price IS NOT NULL AND CostPrice IS NOT NULL;


/* 83. Discount analysis (requires OriginalPrice) */
SELECT ProductID, ProductName, OriginalPrice, Price,
       OriginalPrice - Price AS DiscountAmount,
       (OriginalPrice - Price) * 100.0 / NULLIF(OriginalPrice, 0) AS DiscountPercent
FROM dbo.Products
WHERE OriginalPrice > 0 AND Price IS NOT NULL;


/* 84. Average salary by department */
SELECT d.DepartmentName,
       AVG(CAST(e.Salary AS DECIMAL(18,2))) AS AverageSalary,
       MIN(e.Salary) AS MinimumSalary,
       MAX(e.Salary) AS MaximumSalary,
       COUNT(*) AS EmployeeCount
FROM dbo.Employees AS e
JOIN dbo.Departments AS d ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY AverageSalary DESC;


/* 85. Headcount by department */
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS Headcount
FROM dbo.Departments AS d
LEFT JOIN dbo.Employees AS e ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY Headcount DESC;


/* 86. Employees missing a department match */
SELECT e.EmployeeID, e.EmployeeName, e.DepartmentID
FROM dbo.Employees AS e
LEFT JOIN dbo.Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentID IS NULL;


/* 87. New hires by month */
SELECT DATEFROMPARTS(YEAR(HireDate), MONTH(HireDate), 1) AS HireMonth,
       COUNT(*) AS NewHires
FROM dbo.Employees
WHERE HireDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(HireDate), MONTH(HireDate), 1)
ORDER BY HireMonth;


/* 88. Employee salary compared with department average */
SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
       AVG(CAST(Salary AS DECIMAL(18,2))) OVER (PARTITION BY DepartmentID) AS DepartmentAverage
FROM dbo.Employees;


/* 89. Find customers with multiple orders on the same day */
SELECT CustomerID, CAST(OrderDate AS DATE) AS OrderDay, COUNT(*) AS OrdersThatDay
FROM dbo.Orders
GROUP BY CustomerID, CAST(OrderDate AS DATE)
HAVING COUNT(*) > 1;


/* 90. Calculate order-item contribution to order total */
WITH LineValues AS (
    SELECT OrderID, ProductID, Quantity * UnitPrice AS LineValue
    FROM dbo.OrderItems
),
OrderValues AS (
    SELECT OrderID, SUM(LineValue) AS OrderValue
    FROM LineValues
    GROUP BY OrderID
)
SELECT l.OrderID, l.ProductID, l.LineValue, o.OrderValue,
       l.LineValue * 100.0 / NULLIF(o.OrderValue, 0) AS PercentOfOrder
FROM LineValues AS l
JOIN OrderValues AS o ON o.OrderID = l.OrderID;


/* 91. Identify customers whose spending declined month over month */
WITH CustomerMonthlySpend AS (
    SELECT CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS MonthlySpend
    FROM dbo.Orders
    GROUP BY CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
SpendComparison AS (
    SELECT CustomerID, SalesMonth, MonthlySpend,
           LAG(MonthlySpend) OVER (PARTITION BY CustomerID ORDER BY SalesMonth) AS PreviousMonthSpend
    FROM CustomerMonthlySpend
)
SELECT CustomerID, SalesMonth, MonthlySpend, PreviousMonthSpend
FROM SpendComparison
WHERE PreviousMonthSpend IS NOT NULL AND MonthlySpend < PreviousMonthSpend;


/* 92. Segment customers by lifetime spending */
WITH CustomerSpend AS (
    SELECT c.CustomerID, c.CustomerName, COALESCE(SUM(o.TotalAmount), 0) AS LifetimeSpend
    FROM dbo.Customers AS c
    LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT *, CASE WHEN LifetimeSpend >= 10000 THEN 'High Value'
               WHEN LifetimeSpend >= 2500 THEN 'Medium Value'
               ELSE 'Low Value' END AS CustomerSegment
FROM CustomerSpend;


/* 93. Calculate RFM-style recency, frequency, monetary value */
SELECT c.CustomerID, c.CustomerName,
       MAX(o.OrderDate) AS LastOrderDate,
       DATEDIFF(DAY, MAX(o.OrderDate), CAST(GETDATE() AS DATE)) AS RecencyDays,
       COUNT(o.OrderID) AS Frequency,
       COALESCE(SUM(o.TotalAmount), 0) AS MonetaryValue
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName;


/* 94. Find customers with a high-value recent order */
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.TotalAmount >= 1000
  AND o.OrderDate >= DATEADD(DAY, -30, GETDATE());


/* 95. Weekly sales summary */
SELECT DATEADD(DAY, 1 - DATEPART(WEEKDAY, CAST(OrderDate AS DATE)), CAST(OrderDate AS DATE)) AS WeekStart,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEADD(DAY, 1 - DATEPART(WEEKDAY, CAST(OrderDate AS DATE)), CAST(OrderDate AS DATE))
ORDER BY WeekStart;


/* 96. Build a reusable filtered dataset with a CTE */
WITH RecentCompletedOrders AS (
    SELECT OrderID, CustomerID, OrderDate, TotalAmount
    FROM dbo.Orders
    WHERE Status = 'Completed'
      AND OrderDate >= DATEADD(MONTH, -3, GETDATE())
)
SELECT CustomerID, COUNT(*) AS CompletedOrders, SUM(TotalAmount) AS Revenue
FROM RecentCompletedOrders
GROUP BY CustomerID
ORDER BY Revenue DESC;


/* 97. Create a temporary table for repeated analysis */
DROP TABLE IF EXISTS #MonthlySales;

SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       SUM(TotalAmount) AS Revenue
INTO #MonthlySales
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1);

SELECT SalesMonth, Revenue
FROM #MonthlySales
ORDER BY SalesMonth;


/* 98. Add a nonclustered index for a common filter (review before running) */
-- Review existing indexes and workload before creating indexes in production.
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate
ON dbo.Orders (OrderDate)
INCLUDE (CustomerID, Status, TotalAmount);


/* 99. Safely test a data update inside a transaction (review before running) */
BEGIN TRANSACTION;

UPDATE dbo.Products
SET Price = Price * 1.05
WHERE Category = 'Example Category';

-- Check affected rows and values before deciding:
SELECT ProductID, ProductName, Category, Price
FROM dbo.Products
WHERE Category = 'Example Category';

-- Run ONE of these after reviewing the result:
-- COMMIT TRANSACTION;
-- ROLLBACK TRANSACTION;


/* 100. Produce a compact data-quality summary for core tables */
SELECT 'Customers' AS TableName, COUNT(*) AS "RowCount" FROM dbo.Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM dbo.Orders
UNION ALL
SELECT 'OrderItems', COUNT(*) FROM dbo.OrderItems
UNION ALL
SELECT 'Products', COUNT(*) FROM dbo.Products
UNION ALL
SELECT 'Employees', COUNT(*) FROM dbo.Employees;


/*
SQL SERVER DATA ANALYST PRACTICE LIBRARY — ROUND 5 (QUERIES 01–100)
===================================================================

Dialect: Microsoft SQL Server (T-SQL)
Description: Round 5 iteration featuring fresh sample seed data, shifted 
date baselines (2028/2029), updated numerical filter thresholds, and modified 
parameters while keeping the exact same 100 core query patterns.
*/

CREATE DATABASE SQLMastery_Round5;
GO
USE SQLMastery_Round5;
GO

-- ============================================================================
-- SETUP BLOCK: MOCK SCHEMA & ROUND 5 SEED DATA
-- ============================================================================
CREATE TABLE dbo.Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE dbo.Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeName VARCHAR(100),
    DepartmentID INT FOREIGN KEY REFERENCES dbo.Departments(DepartmentID),
    Salary DECIMAL(18,2),
    HireDate DATE
);

CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50),
    Region VARCHAR(50)
);

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES dbo.Customers(CustomerID),
    OrderDate DATE,
    ShipDate DATE,
    Status VARCHAR(50),
    TotalAmount DECIMAL(18,2)
);

CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(18,2),
    CostPrice DECIMAL(18,2),
    OriginalPrice DECIMAL(18,2),
    StockQuantity INT,
    ReorderLevel INT
);

CREATE TABLE dbo.OrderItems (
    OrderID INT FOREIGN KEY REFERENCES dbo.Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES dbo.Products(ProductID),
    Quantity INT,
    UnitPrice DECIMAL(18,2)
);


-- Seed Sample Data (Round 5 Fresh Values)
INSERT INTO dbo.Departments VALUES 
(1000, 'Artificial Intelligence'), 
(2000, 'Cloud Security'), 
(3000, 'Strategic Growth'), 
(4000, 'Data Governance');

INSERT INTO dbo.Employees (EmployeeName, DepartmentID, Salary, HireDate) VALUES 
('Yassmin Magdy', 1000, 135000.00, '2022-03-10'),
('Hisham Kamel', 1000, 115000.00, '2023-06-15'),
('Reham Hossam', 2000, 140000.00, '2021-09-01'),
('Mostafa Fahmy', 3000, 98000.00, '2024-01-20'),
('Nourhan Adel', 4000, 92000.00, '2025-07-11');

INSERT INTO dbo.Customers VALUES 
(1101, 'Falcon Logistics', 'logistics@falcon.eg', 'Giza', 'Africa'),
(1102, 'Pyramid Tech', NULL, 'Cairo', 'Africa'),
(1103, 'Suez Maritime', 'ops@suezmaritime.com', 'Port Said', 'Africa'),
(1104, 'Delta Agro', 'info@deltaagro.org', 'Mansoura', 'Africa');

INSERT INTO dbo.Products VALUES 
(401, 'Quantum Core Processor', 'Hardware', 5500.00, 4000.00, 5900.00, 4, 8),
(402, 'Enterprise BI Platform', 'Software', 1500.00, 500.00, 1650.00, 60, 20),
(403, 'Advanced Analytics Suite', 'Software', 2800.00, 900.00, 3100.00, 15, 5),
(404, 'Cloud Storage Gateway', 'Hardware', 1900.00, 1400.00, 2100.00, 25, 10);

INSERT INTO dbo.Orders VALUES 
(5001, 1101, '2026-01-10', '2026-01-12', 'Shipped', 11000.00),
(5002, 1102, '2026-02-05', '2026-02-07', 'Processing', 3100.00),
(5003, 1103, '2026-03-01', '2026-03-03', 'Delivered', 5500.00);

INSERT INTO dbo.OrderItems VALUES 
(5001, 401, 2, 5500.00),
(5002, 403, 1, 3100.00),
(5003, 401, 1, 5500.00);

/* 01. Filter rows with WHERE */
SELECT OrderID, CustomerID, OrderDate, Status
FROM dbo.Orders
WHERE Status = 'Completed';


/* 02. Sort results */
SELECT ProductID, ProductName, Price
FROM dbo.Products
ORDER BY Price DESC;


/* 03. Return the top 10 records */
SELECT TOP (10) OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
ORDER BY TotalAmount DESC;



/* 04. Find distinct categories */
SELECT DISTINCT Category
FROM dbo.Products
ORDER BY Category;


/* 05. Count all rows vs non-NULL values */
SELECT COUNT(*) AS TotalRows,
       COUNT(Email) AS RowsWithEmail
FROM dbo.Customers;


/* 06. Find NULL values */
SELECT CustomerID, CustomerName, Email
FROM dbo.Customers
WHERE Email IS NULL;


/* 07. Use CASE to classify values */
SELECT ProductID, ProductName, Price,
       CASE WHEN Price >= 3500 THEN 'High'
            WHEN Price >= 2000 THEN 'Medium'
            ELSE 'Low' END AS PriceBand
FROM dbo.Products;


/* 08. Aggregate with GROUP BY */
SELECT Status, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY Status;


/* 09. Filter groups with HAVING */
SELECT CustomerID, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(*) >= 2;


/* 10. Calculate average salary */
SELECT AVG(CAST(Salary AS DECIMAL(18,2))) AS AverageSalary
FROM dbo.Employees;


/* 11. INNER JOIN two tables */
SELECT o.OrderID, c.CustomerName, o.OrderDate
FROM dbo.Orders AS o
INNER JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID;


/* 12. LEFT JOIN to keep unmatched customers */
SELECT c.CustomerID, c.CustomerName, o.OrderID
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID;


/* 13. Find customers with no orders */
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;


/* 14. Find products never ordered */
SELECT p.ProductID, p.ProductName
FROM dbo.Products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.OrderItems AS oi
    WHERE oi.ProductID = p.ProductID
);


/* 15. Join three tables */
SELECT o.OrderID, c.CustomerName, p.ProductName, oi.Quantity
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID;


/* 16. UNION vs UNION ALL pattern */
SELECT City FROM dbo.Customers
UNION
SELECT Region FROM dbo.Customers;


/* 17. Find duplicate emails */
SELECT Email, COUNT(*) AS DuplicateCount
FROM dbo.Customers
WHERE Email IS NOT NULL
GROUP BY Email
HAVING COUNT(*) > 1;


/* 18. Find the second-highest distinct salary */
WITH SalaryRanks AS (
    SELECT Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM dbo.Employees
    WHERE Salary IS NOT NULL
)
SELECT DISTINCT Salary
FROM SalaryRanks
WHERE SalaryRank = 2;


/* 19. Find the Nth-highest salary (change @N) */
DECLARE @N INT = 2;
WITH SalaryRanks AS (
    SELECT EmployeeID, EmployeeName, Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM dbo.Employees
    WHERE Salary IS NOT NULL
)
SELECT EmployeeID, EmployeeName, Salary
FROM SalaryRanks
WHERE SalaryRank = @N;


/* 20. Rank employees within each department */
SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
       RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
FROM dbo.Employees;


/* 21. Top 3 employees per department */
WITH RankedEmployees AS (
    SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
           ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC, EmployeeID) AS rn
    FROM dbo.Employees
)
SELECT EmployeeID, EmployeeName, DepartmentID, Salary
FROM RankedEmployees
WHERE rn <= 3;


/* 22. Compare ROW_NUMBER, RANK, DENSE_RANK */
SELECT EmployeeID, EmployeeName, Salary,
       ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNum,
       RANK() OVER (ORDER BY Salary DESC) AS SalaryRank,
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseSalaryRank
FROM dbo.Employees;


/* 23. Find employees paid above company average */
SELECT EmployeeID, EmployeeName, Salary
FROM dbo.Employees
WHERE Salary > (SELECT AVG(CAST(Salary AS DECIMAL(18,2))) FROM dbo.Employees);


/* 24. Find employees paid above their department average */
WITH DepartmentAverages AS (
    SELECT DepartmentID, AVG(CAST(Salary AS DECIMAL(18,2))) AS AvgSalary
    FROM dbo.Employees
    GROUP BY DepartmentID
)
SELECT e.EmployeeID, e.EmployeeName, e.DepartmentID, e.Salary
FROM dbo.Employees AS e
JOIN DepartmentAverages AS d ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > d.AvgSalary;


/* 25. Use a CTE to calculate order totals */
WITH OrderTotals AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS CalculatedTotal
    FROM dbo.OrderItems
    GROUP BY OrderID
)
SELECT OrderID, CalculatedTotal
FROM OrderTotals
ORDER BY CalculatedTotal DESC;


/* 26. Use EXISTS to find customers with orders */
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
WHERE EXISTS (
    SELECT 1 FROM dbo.Orders AS o
    WHERE o.CustomerID = c.CustomerID
);


/* 27. Find the latest order for each customer */
WITH RankedOrders AS (
    SELECT OrderID, CustomerID, OrderDate,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC) AS rn
    FROM dbo.Orders
)
SELECT OrderID, CustomerID, OrderDate
FROM RankedOrders
WHERE rn = 1;


/* 28. Find each customer's first order */
SELECT CustomerID, MIN(OrderDate) AS FirstOrderDate
FROM dbo.Orders
GROUP BY CustomerID;


/* 29. Calculate a running sales total */
WITH DailySales AS (
    SELECT CAST(OrderDate AS DATE) AS OrderDay, SUM(TotalAmount) AS Sales
    FROM dbo.Orders
    GROUP BY CAST(OrderDate AS DATE)
)
SELECT OrderDay, Sales,
       SUM(Sales) OVER (ORDER BY OrderDay ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningSales
FROM DailySales
ORDER BY OrderDay;


/* 30. Compare each month with the previous month */
WITH MonthlySales AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
SalesComparison AS (
    SELECT SalesMonth, Revenue,
           LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue
    FROM MonthlySales
)
SELECT SalesMonth, Revenue, PreviousMonthRevenue,
       (Revenue - PreviousMonthRevenue) * 100.0 / NULLIF(PreviousMonthRevenue, 0) AS MoMPercentChange
FROM SalesComparison
ORDER BY SalesMonth;


/* 31. Calculate each category's share of revenue */
WITH CategorySales AS (
    SELECT p.Category, SUM(oi.Quantity * oi.UnitPrice) AS Revenue
    FROM dbo.OrderItems AS oi
    JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
    GROUP BY p.Category
)
SELECT Category, Revenue,
       Revenue * 100.0 / NULLIF(SUM(Revenue) OVER (), 0) AS RevenueSharePercent
FROM CategorySales
ORDER BY Revenue DESC;


/* 32. Find customers above average order value */
WITH CustomerSpend AS (
    SELECT CustomerID, AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AvgOrderValue
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT CustomerID, AvgOrderValue
FROM CustomerSpend
WHERE AvgOrderValue > (SELECT AVG(CAST(TotalAmount AS DECIMAL(18,2))) FROM dbo.Orders);


/* 33. Find consecutive orders using LAG */
WITH OrderHistory AS (
    SELECT CustomerID, OrderID, OrderDate,
           LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate, OrderID) AS PreviousOrderDate
    FROM dbo.Orders
)
SELECT CustomerID, OrderID, OrderDate, PreviousOrderDate,
       DATEDIFF(DAY, PreviousOrderDate, OrderDate) AS DaysSincePreviousOrder
FROM OrderHistory;


/* 34. Calculate a 3-row moving average of daily sales */
WITH DailySales AS (
    SELECT CAST(OrderDate AS DATE) AS OrderDay, SUM(TotalAmount) AS Sales
    FROM dbo.Orders
    GROUP BY CAST(OrderDate AS DATE)
)
SELECT OrderDay, Sales,
       AVG(CAST(Sales AS DECIMAL(18,2))) OVER (
           ORDER BY OrderDay ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS MovingAverage3Rows
FROM DailySales
ORDER BY OrderDay;


/* 35. Find duplicate rows by business key and keep latest */
WITH Duplicates AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC
    ) AS rn
    FROM dbo.Orders
)
SELECT *
FROM Duplicates
WHERE rn = 1;


/* 36. Pivot order counts by status */
SELECT CustomerID,
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedOrders,
       SUM(CASE WHEN Status = 'Shipped' THEN 1 ELSE 0 END) AS ShippedOrders,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS PendingOrders
FROM dbo.Orders
GROUP BY CustomerID;


/* 37. Find the most expensive product in each category */
WITH RankedProducts AS (
    SELECT ProductID, ProductName, Category, Price,
           DENSE_RANK() OVER (PARTITION BY Category ORDER BY Price DESC) AS rn
    FROM dbo.Products
)
SELECT ProductID, ProductName, Category, Price
FROM RankedProducts
WHERE rn = 1;


/* 38. Find customers who ordered in one year but not another (Shifted to 2028/2029) */
SELECT DISTINCT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2028-01-01' AND OrderDate < '2029-01-01'
EXCEPT
SELECT DISTINCT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2029-01-01' AND OrderDate < '2030-01-01';


/* 39. Calculate order value including line items */
SELECT o.OrderID, o.CustomerID, o.OrderDate,
       SUM(oi.Quantity * oi.UnitPrice) AS CalculatedOrderValue
FROM dbo.Orders AS o
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
GROUP BY o.OrderID, o.CustomerID, o.OrderDate;


/* 40. Find orders where stored total differs from line total */
WITH LineTotals AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS LineTotal
    FROM dbo.OrderItems
    GROUP BY OrderID
)
SELECT o.OrderID, o.TotalAmount, l.LineTotal,
       o.TotalAmount - l.LineTotal AS Difference
FROM dbo.Orders AS o
JOIN LineTotals AS l ON l.OrderID = o.OrderID
WHERE ABS(o.TotalAmount - l.LineTotal) > 0.01;


/* 41. Calculate percentage of employees in each department */
SELECT DepartmentID, COUNT(*) AS EmployeeCount,
       COUNT(*) * 100.0 / NULLIF(SUM(COUNT(*)) OVER (), 0) AS PercentOfEmployees
FROM dbo.Employees
GROUP BY DepartmentID;


/* 42. Find employees hired in the last 12 months */
SELECT EmployeeID, EmployeeName, HireDate
FROM dbo.Employees
WHERE HireDate >= DATEADD(MONTH, -12, CAST(GETDATE() AS DATE))
  AND HireDate < DATEADD(DAY, 1, CAST(GETDATE() AS DATE));


/* 43. Calculate days between order and shipment */
SELECT OrderID, OrderDate, ShipDate,
       DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Orders
WHERE ShipDate IS NOT NULL;


/* 44. Find the median salary */
SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary)
       OVER () AS MedianSalary
FROM dbo.Employees
WHERE Salary IS NOT NULL;


/* 45. Identify outlier prices using IQR */
WITH Quartiles AS (
    SELECT DISTINCT
           PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Price) OVER () AS Q1,
           PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Price) OVER () AS Q3
    FROM dbo.Products
    WHERE Price IS NOT NULL
)
SELECT p.ProductID, p.ProductName, p.Price, q.Q1, q.Q3
FROM dbo.Products AS p
CROSS JOIN Quartiles AS q
WHERE p.Price < q.Q1 - 1.5 * (q.Q3 - q.Q1)
   OR p.Price > q.Q3 + 1.5 * (q.Q3 - q.Q1);


/* 46. Find missing dates in the order activity calendar */
WITH OrderDays AS (
    SELECT DISTINCT CAST(OrderDate AS DATE) AS OrderDay
    FROM dbo.Orders
),
DateRange AS (
    SELECT MIN(OrderDay) AS StartDay, MAX(OrderDay) AS EndDay
    FROM OrderDays
),
Calendar AS (
    SELECT StartDay AS CalendarDay, EndDay
    FROM DateRange
    UNION ALL
    SELECT DATEADD(DAY, 1, CalendarDay), EndDay
    FROM Calendar
    WHERE CalendarDay < EndDay
)
SELECT c.CalendarDay
FROM Calendar AS c
LEFT JOIN OrderDays AS o ON o.OrderDay = c.CalendarDay
WHERE o.OrderDay IS NULL
OPTION (MAXRECURSION 0);


/* 47. Find customers with orders in at least 3 distinct months */
SELECT CustomerID, COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) AS ActiveMonths
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) >= 3;


/* 48. Calculate customer repeat-purchase rate */
WITH CustomerOrders AS (
    SELECT CustomerID, COUNT(*) AS OrderCount
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT COUNT(CASE WHEN OrderCount >= 2 THEN 1 END) AS RepeatCustomers,
       COUNT(*) AS CustomersWithOrders,
       COUNT(CASE WHEN OrderCount >= 2 THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS RepeatPurchaseRatePercent
FROM CustomerOrders;


/* 49. Calculate customer retention by first-order cohort and next month */
WITH FirstOrder AS (
    SELECT CustomerID, MIN(DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) AS CohortMonth
    FROM dbo.Orders
    GROUP BY CustomerID
),
CustomerActivity AS (
    SELECT DISTINCT CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS ActivityMonth
    FROM dbo.Orders
)
SELECT f.CohortMonth,
       COUNT(DISTINCT f.CustomerID) AS CohortCustomers,
       COUNT(DISTINCT CASE WHEN a.ActivityMonth = DATEADD(MONTH, 1, f.CohortMonth) THEN f.CustomerID END) AS RetainedNextMonth,
       COUNT(DISTINCT CASE WHEN a.ActivityMonth = DATEADD(MONTH, 1, f.CohortMonth) THEN f.CustomerID END) * 100.0
           / NULLIF(COUNT(DISTINCT f.CustomerID), 0) AS NextMonthRetentionPercent
FROM FirstOrder AS f
LEFT JOIN CustomerActivity AS a ON a.CustomerID = f.CustomerID
GROUP BY f.CohortMonth
ORDER BY f.CohortMonth;


/* 50. Inspect query execution plan and IO/time (Shifted to 2028) */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT CustomerID, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
WHERE OrderDate >= '2028-01-01' AND OrderDate < '2029-01-01'
GROUP BY CustomerID;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;


/* 51. Daily sales summary */
SELECT CAST(OrderDate AS DATE) AS OrderDay,
       COUNT(*) AS OrderCount,
       SUM(TotalAmount) AS Revenue,
       AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AverageOrderValue
FROM dbo.Orders
WHERE OrderDate >= DATEADD(DAY, -30, CAST(GETDATE() AS DATE))
GROUP BY CAST(OrderDate AS DATE)
ORDER BY OrderDay;


/* 52. Sales by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 53. Sales by region */
SELECT c.Region, COUNT(o.OrderID) AS OrderCount, SUM(o.TotalAmount) AS Revenue
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
GROUP BY c.Region
ORDER BY Revenue DESC;


/* 54. Sales by product category */
SELECT p.Category, SUM(oi.Quantity) AS UnitsSold,
       SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM dbo.OrderItems AS oi
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
GROUP BY p.Category
ORDER BY Revenue DESC;


/* 55. Top 10 customers by lifetime revenue */
SELECT TOP (10) c.CustomerID, c.CustomerName,
       SUM(o.TotalAmount) AS LifetimeRevenue
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY LifetimeRevenue DESC;


/* 56. Top 10 products by units sold */
SELECT TOP (10) p.ProductID, p.ProductName,
       SUM(oi.Quantity) AS UnitsSold
FROM dbo.OrderItems AS oi
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY UnitsSold DESC;


/* 57. Revenue by order status */
SELECT Status, COUNT(*) AS OrderCount, SUM(TotalAmount) AS TotalAmount
FROM dbo.Orders
GROUP BY Status
ORDER BY TotalAmount DESC;


/* 58. Cancellation rate */
SELECT COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) AS CancelledOrders,
       COUNT(*) AS TotalOrders,
       COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS CancellationRatePercent
FROM dbo.Orders;


/* 59. Average order value by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AverageOrderValue
FROM dbo.Orders
WHERE TotalAmount IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 60. Customers who have not ordered in 90 days */
SELECT c.CustomerID, c.CustomerName, MAX(o.OrderDate) AS LastOrderDate
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING MAX(o.OrderDate) IS NULL
    OR MAX(o.OrderDate) < DATEADD(DAY, -90, GETDATE());


/* 61. Customers who ordered this month */
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderDate >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
  AND o.OrderDate < DATEADD(MONTH, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1));


/* 62. Orders above the overall average order value */
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE TotalAmount > (SELECT AVG(CAST(TotalAmount AS DECIMAL(18,2))) FROM dbo.Orders);


/* 63. Daily order count by status */
SELECT CAST(OrderDate AS DATE) AS OrderDay,
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS Completed,
       SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS Pending
FROM dbo.Orders
GROUP BY CAST(OrderDate AS DATE)
ORDER BY OrderDay;


/* 64. Check duplicate customer records */
SELECT CustomerName, Email, COUNT(*) AS RecordCount
FROM dbo.Customers
GROUP BY CustomerName, Email
HAVING COUNT(*) > 1;


/* 65. Check duplicate order IDs */
SELECT OrderID, COUNT(*) AS RecordCount
FROM dbo.Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;


/* 66. Check missing required values */
SELECT
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS MissingOrderDate,
    SUM(CASE WHEN TotalAmount IS NULL THEN 1 ELSE 0 END) AS MissingTotalAmount
FROM dbo.Orders;


/* 67. Find negative or zero order amounts */
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE TotalAmount <= 0;


/* 68. Find negative prices or quantities */
SELECT OrderID, ProductID, Quantity, UnitPrice
FROM dbo.OrderItems
WHERE Quantity <= 0 OR UnitPrice < 0;


/* 69. Find orders with no matching customer */
SELECT o.*
FROM dbo.Orders AS o
LEFT JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL;


/* 70. Find order items with no matching product */
SELECT oi.*
FROM dbo.OrderItems AS oi
LEFT JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
WHERE p.ProductID IS NULL;


/* 71. Standardize text for review (trim and lowercase) */
SELECT CustomerID, CustomerName, Email,
       LOWER(LTRIM(RTRIM(Email))) AS StandardizedEmail
FROM dbo.Customers;


/* 72. Find leading/trailing spaces in customer names */
SELECT CustomerID, CustomerName
FROM dbo.Customers
WHERE CustomerName <> LTRIM(RTRIM(CustomerName));


/* 73. Count distinct customers per month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       COUNT(DISTINCT CustomerID) AS ActiveCustomers
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 74. Compare current month and previous month revenue */
WITH MonthlyRevenue AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
)
SELECT SalesMonth, Revenue,
       LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue,
       Revenue - LAG(Revenue) OVER (ORDER BY SalesMonth) AS RevenueChange
FROM MonthlyRevenue
ORDER BY SalesMonth;


/* 75. Year-over-year revenue comparison */
WITH YearlyRevenue AS (
    SELECT YEAR(OrderDate) AS SalesYear, SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY YEAR(OrderDate)
)
SELECT SalesYear, Revenue,
       LAG(Revenue) OVER (ORDER BY SalesYear) AS PreviousYearRevenue,
       (Revenue - LAG(Revenue) OVER (ORDER BY SalesYear)) * 100.0
           / NULLIF(LAG(Revenue) OVER (ORDER BY SalesYear), 0) AS YoYPercentChange
FROM YearlyRevenue
ORDER BY SalesYear;


/* 76. Revenue by weekday */
SELECT DATENAME(WEEKDAY, OrderDate) AS WeekdayName,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATENAME(WEEKDAY, OrderDate), DATEPART(WEEKDAY, OrderDate)
ORDER BY DATEPART(WEEKDAY, OrderDate);


/* 77. Revenue by order date */
SELECT OrderDate AS OrderDay,
       COUNT(*) AS OrderCount, 
       SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY OrderDate
ORDER BY OrderDay;


/* 78. Average shipping time by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS OrderMonth,
       AVG(CAST(DATEDIFF(DAY, OrderDate, ShipDate) AS DECIMAL(10,2))) AS AvgDaysToShip
FROM dbo.Orders
WHERE ShipDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY OrderMonth;


/* 79. Late shipments */
SELECT OrderID, OrderDate, ShipDate,
       DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Orders
WHERE ShipDate > DATEADD(DAY, 3, OrderDate);


/* 80. Products below reorder level */
SELECT ProductID, ProductName, StockQuantity, ReorderLevel
FROM dbo.Products
WHERE StockQuantity <= ReorderLevel;


/* 81. Inventory value by category */
SELECT Category,
       SUM(CAST(StockQuantity AS DECIMAL(18,2)) * Price) AS InventoryValue
FROM dbo.Products
GROUP BY Category
ORDER BY InventoryValue DESC;


/* 82. Calculate gross margin per product (requires CostPrice) */
SELECT ProductID, ProductName, Price, CostPrice,
       Price - CostPrice AS GrossProfitPerUnit,
       (Price - CostPrice) * 100.0 / NULLIF(Price, 0) AS GrossMarginPercent
FROM dbo.Products
WHERE Price IS NOT NULL AND CostPrice IS NOT NULL;


/* 83. Discount analysis (requires OriginalPrice) */
SELECT ProductID, ProductName, OriginalPrice, Price,
       OriginalPrice - Price AS DiscountAmount,
       (OriginalPrice - Price) * 100.0 / NULLIF(OriginalPrice, 0) AS DiscountPercent
FROM dbo.Products
WHERE OriginalPrice > 0 AND Price IS NOT NULL;


/* 84. Average salary by department */
SELECT d.DepartmentName,
       AVG(CAST(e.Salary AS DECIMAL(18,2))) AS AverageSalary,
       MIN(e.Salary) AS MinimumSalary,
       MAX(e.Salary) AS MaximumSalary,
       COUNT(*) AS EmployeeCount
FROM dbo.Employees AS e
JOIN dbo.Departments AS d ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY AverageSalary DESC;


/* 85. Headcount by department */
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS Headcount
FROM dbo.Departments AS d
LEFT JOIN dbo.Employees AS e ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY Headcount DESC;


/* 86. Employees missing a department match */
SELECT e.EmployeeID, e.EmployeeName, e.DepartmentID
FROM dbo.Employees AS e
LEFT JOIN dbo.Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentID IS NULL;


/* 87. New hires by month */
SELECT DATEFROMPARTS(YEAR(HireDate), MONTH(HireDate), 1) AS HireMonth,
       COUNT(*) AS NewHires
FROM dbo.Employees
WHERE HireDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(HireDate), MONTH(HireDate), 1)
ORDER BY HireMonth;


/* 88. Employee salary compared with department average */
SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
       AVG(CAST(Salary AS DECIMAL(18,2))) OVER (PARTITION BY DepartmentID) AS DepartmentAverage
FROM dbo.Employees;


/* 89. Find customers with multiple orders on the same day */
SELECT CustomerID, CAST(OrderDate AS DATE) AS OrderDay, COUNT(*) AS OrdersThatDay
FROM dbo.Orders
GROUP BY CustomerID, CAST(OrderDate AS DATE)
HAVING COUNT(*) > 1;


/* 90. Calculate order-item contribution to order total */
WITH LineValues AS (
    SELECT OrderID, ProductID, Quantity * UnitPrice AS LineValue
    FROM dbo.OrderItems
),
OrderValues AS (
    SELECT OrderID, SUM(LineValue) AS OrderValue
    FROM LineValues
    GROUP BY OrderID
)
SELECT l.OrderID, l.ProductID, l.LineValue, o.OrderValue,
       l.LineValue * 100.0 / NULLIF(o.OrderValue, 0) AS PercentOfOrder
FROM LineValues AS l
JOIN OrderValues AS o ON o.OrderID = l.OrderID;


/* 91. Identify customers whose spending declined month over month */
WITH CustomerMonthlySpend AS (
    SELECT CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS MonthlySpend
    FROM dbo.Orders
    GROUP BY CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
SpendComparison AS (
    SELECT CustomerID, SalesMonth, MonthlySpend,
           LAG(MonthlySpend) OVER (PARTITION BY CustomerID ORDER BY SalesMonth) AS PreviousMonthSpend
    FROM CustomerMonthlySpend
)
SELECT CustomerID, SalesMonth, MonthlySpend, PreviousMonthSpend
FROM SpendComparison
WHERE PreviousMonthSpend IS NOT NULL AND MonthlySpend < PreviousMonthSpend;


/* 92. Segment customers by lifetime spending */
WITH CustomerSpend AS (
    SELECT c.CustomerID, c.CustomerName, COALESCE(SUM(o.TotalAmount), 0) AS LifetimeSpend
    FROM dbo.Customers AS c
    LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT *, CASE WHEN LifetimeSpend >= 10000 THEN 'High Value'
               WHEN LifetimeSpend >= 2500 THEN 'Medium Value'
               ELSE 'Low Value' END AS CustomerSegment
FROM CustomerSpend;


/* 93. Calculate RFM-style recency, frequency, monetary value */
SELECT c.CustomerID, c.CustomerName,
       MAX(o.OrderDate) AS LastOrderDate,
       DATEDIFF(DAY, MAX(o.OrderDate), CAST(GETDATE() AS DATE)) AS RecencyDays,
       COUNT(o.OrderID) AS Frequency,
       COALESCE(SUM(o.TotalAmount), 0) AS MonetaryValue
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName;


/* 94. Find customers with a high-value recent order */
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.TotalAmount >= 1000
  AND o.OrderDate >= DATEADD(DAY, -30, GETDATE());


/* 95. Weekly sales summary */
SELECT DATEADD(DAY, 1 - DATEPART(WEEKDAY, CAST(OrderDate AS DATE)), CAST(OrderDate AS DATE)) AS WeekStart,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEADD(DAY, 1 - DATEPART(WEEKDAY, CAST(OrderDate AS DATE)), CAST(OrderDate AS DATE))
ORDER BY WeekStart;


/* 96. Build a reusable filtered dataset with a CTE */
WITH RecentCompletedOrders AS (
    SELECT OrderID, CustomerID, OrderDate, TotalAmount
    FROM dbo.Orders
    WHERE Status = 'Completed'
      AND OrderDate >= DATEADD(MONTH, -3, GETDATE())
)
SELECT CustomerID, COUNT(*) AS CompletedOrders, SUM(TotalAmount) AS Revenue
FROM RecentCompletedOrders
GROUP BY CustomerID
ORDER BY Revenue DESC;


/* 97. Create a temporary table for repeated analysis */
DROP TABLE IF EXISTS #MonthlySales;

SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       SUM(TotalAmount) AS Revenue
INTO #MonthlySales
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1);

SELECT SalesMonth, Revenue
FROM #MonthlySales
ORDER BY SalesMonth;


/* 98. Add a nonclustered index for a common filter (review before running) */
-- Review existing indexes and workload before creating indexes in production.
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate
ON dbo.Orders (OrderDate)
INCLUDE (CustomerID, Status, TotalAmount);


/* 99. Safely test a data update inside a transaction (review before running) */
BEGIN TRANSACTION;

UPDATE dbo.Products
SET Price = Price * 1.05
WHERE Category = 'Example Category';

-- Check affected rows and values before deciding:
SELECT ProductID, ProductName, Category, Price
FROM dbo.Products
WHERE Category = 'Example Category';

-- Run ONE of these after reviewing the result:
-- COMMIT TRANSACTION;
-- ROLLBACK TRANSACTION;


/* 100. Produce a compact data-quality summary for core tables */
SELECT 'Customers' AS TableName, COUNT(*) AS "RowCount" FROM dbo.Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM dbo.Orders
UNION ALL
SELECT 'OrderItems', COUNT(*) FROM dbo.OrderItems
UNION ALL
SELECT 'Products', COUNT(*) FROM dbo.Products
UNION ALL
SELECT 'Employees', COUNT(*) FROM dbo.Employees;



/*
SQL SERVER DATA ANALYST PRACTICE LIBRARY — ROUND 6 (QUERIES 01–100)
===================================================================

Dialect: Microsoft SQL Server (T-SQL)
Description: Round 6 iteration featuring fully seeded tables, shifted 
date baselines (2029/2030), updated numerical thresholds, and clean syntax.
*/

CREATE DATABASE SQLMastery_Round6;
GO
USE SQLMastery_Round6;
GO

-- ============================================================================
-- SETUP BLOCK: MOCK SCHEMA & SEED DATA
-- ============================================================================
CREATE TABLE dbo.Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE dbo.Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeName VARCHAR(100),
    DepartmentID INT FOREIGN KEY REFERENCES dbo.Departments(DepartmentID),
    Salary DECIMAL(18,2),
    HireDate DATE
);

CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50),
    Region VARCHAR(50)
);

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES dbo.Customers(CustomerID),
    OrderDate DATE,
    ShipDate DATE,
    Status VARCHAR(50),
    TotalAmount DECIMAL(18,2)
);

CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(18,2),
    CostPrice DECIMAL(18,2),
    OriginalPrice DECIMAL(18,2),
    StockQuantity INT,
    ReorderLevel INT
);

CREATE TABLE dbo.OrderItems (
    OrderID INT FOREIGN KEY REFERENCES dbo.Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES dbo.Products(ProductID),
    Quantity INT,
    UnitPrice DECIMAL(18,2)
);

-- Seed Data
INSERT INTO dbo.Departments VALUES 
(10, 'Executive Strategy'), 
(20, 'Data Science'), 
(30, 'Global Sales'), 
(40, 'Cloud Infrastructure');

INSERT INTO dbo.Employees (EmployeeName, DepartmentID, Salary, HireDate) VALUES 
('Tarek Zaki', 10, 140000.00, '2023-01-10'),
('Aya Mahmoud', 20, 120000.00, '2023-06-12'),
('Mahmoud Hassan', 30, 95000.00, '2024-02-15'),
('Yasmin Nour', 40, 105000.00, '2025-04-20');

INSERT INTO dbo.Customers VALUES 
(2001, 'Vertex Solutions', 'contact@vertex.io', 'London', 'UK'),
(2002, 'Summit Group', NULL, 'New York', 'North America'),
(2003, 'Pacific Logistics', 'ops@pacificlog.com', 'Sydney', 'APAC'),
(2004, 'Atlas Holdings', 'info@atlasholdings.com', 'London', 'UK');

INSERT INTO dbo.Products VALUES 
(501, 'Neural Workstation', 'Hardware', 6000.00, 4500.00, 6500.00, 5, 12),
(502, 'Advanced BI Suite', 'Software', 1800.00, 600.00, 2000.00, 75, 25),
(503, 'Cyber Defense Mesh', 'Services', 3500.00, 1200.00, 4000.00, 12, 6),
(504, 'Edge Router Pro', 'Hardware', 2500.00, 1800.00, 2750.00, 35, 15);

INSERT INTO dbo.Orders VALUES 
(20001, 2001, '2029-01-15', '2029-01-18', 'Completed', 7800.00),
(20002, 2002, '2029-03-10', '2029-03-15', 'Completed', 1800.00),
(20003, 2001, '2029-07-22', '2029-07-25', 'Shipped', 3500.00),
(20004, 2003, '2029-09-14', NULL, 'Pending', 6000.00),
(20005, 2004, '2029-11-05', '2029-11-08', 'Completed', 4300.00);

INSERT INTO dbo.OrderItems VALUES 
(20001, 501, 1, 6000.00),
(20001, 502, 1, 1800.00),
(20002, 502, 1, 1800.00),
(20003, 503, 1, 3500.00),
(20004, 501, 1, 6000.00),
(20005, 502, 1, 1800.00),
(20005, 504, 1, 2500.00);
GO


/* 01. Filter rows with WHERE */
SELECT OrderID, CustomerID, OrderDate, Status
FROM dbo.Orders
WHERE Status = 'Completed';


/* 02. Sort results */
SELECT ProductID, ProductName, Price
FROM dbo.Products
ORDER BY Price DESC;


/* 03. Return the top 10 records */
SELECT TOP (10) OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
ORDER BY TotalAmount DESC;


/* 04. Find distinct categories */
SELECT DISTINCT Category
FROM dbo.Products
ORDER BY Category;


/* 05. Count all rows vs non-NULL values */
SELECT COUNT(*) AS TotalRows,
       COUNT(Email) AS RowsWithEmail
FROM dbo.Customers;


/* 06. Find NULL values */
SELECT CustomerID, CustomerName, Email
FROM dbo.Customers
WHERE Email IS NULL;


/* 07. Use CASE to classify values */
SELECT ProductID, ProductName, Price,
       CASE WHEN Price >= 4000 THEN 'High'
            WHEN Price >= 2000 THEN 'Medium'
            ELSE 'Low' END AS PriceBand
FROM dbo.Products;


/* 08. Aggregate with GROUP BY */
SELECT Status, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY Status;


/* 09. Filter groups with HAVING */
SELECT CustomerID, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(*) >= 2;


/* 10. Calculate average salary */
SELECT AVG(CAST(Salary AS DECIMAL(18,2))) AS AverageSalary
FROM dbo.Employees;


/* 11. INNER JOIN two tables */
SELECT o.OrderID, c.CustomerName, o.OrderDate
FROM dbo.Orders AS o
INNER JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID;


/* 12. LEFT JOIN to keep unmatched customers */
SELECT c.CustomerID, c.CustomerName, o.OrderID
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID;


/* 13. Find customers with no orders */
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;


/* 14. Find products never ordered */
SELECT p.ProductID, p.ProductName
FROM dbo.Products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.OrderItems AS oi
    WHERE oi.ProductID = p.ProductID
);


/* 15. Join three tables */
SELECT o.OrderID, c.CustomerName, p.ProductName, oi.Quantity
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID;


/* 16. UNION vs UNION ALL pattern */
SELECT City FROM dbo.Customers
UNION
SELECT Region FROM dbo.Customers;


/* 17. Find duplicate emails */
SELECT Email, COUNT(*) AS DuplicateCount
FROM dbo.Customers
WHERE Email IS NOT NULL
GROUP BY Email
HAVING COUNT(*) > 1;


/* 18. Find the second-highest distinct salary */
WITH SalaryRanks AS (
    SELECT Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM dbo.Employees
    WHERE Salary IS NOT NULL
)
SELECT DISTINCT Salary
FROM SalaryRanks
WHERE SalaryRank = 2;


/* 19. Find the Nth-highest salary (change @N) */
DECLARE @N INT = 2;
WITH SalaryRanks AS (
    SELECT EmployeeID, EmployeeName, Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM dbo.Employees
    WHERE Salary IS NOT NULL
)
SELECT EmployeeID, EmployeeName, Salary
FROM SalaryRanks
WHERE SalaryRank = @N;


/* 20. Rank employees within each department */
SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
       RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
FROM dbo.Employees;


/* 21. Top 3 employees per department */
WITH RankedEmployees AS (
    SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
           ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC, EmployeeID) AS rn
    FROM dbo.Employees
)
SELECT EmployeeID, EmployeeName, DepartmentID, Salary
FROM RankedEmployees
WHERE rn <= 3;


/* 22. Compare ROW_NUMBER, RANK, DENSE_RANK */
SELECT EmployeeID, EmployeeName, Salary,
       ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNum,
       RANK() OVER (ORDER BY Salary DESC) AS SalaryRank,
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseSalaryRank
FROM dbo.Employees;


/* 23. Find employees paid above company average */
SELECT EmployeeID, EmployeeName, Salary
FROM dbo.Employees
WHERE Salary > (SELECT AVG(CAST(Salary AS DECIMAL(18,2))) FROM dbo.Employees);


/* 24. Find employees paid above their department average */
WITH DepartmentAverages AS (
    SELECT DepartmentID, AVG(CAST(Salary AS DECIMAL(18,2))) AS AvgSalary
    FROM dbo.Employees
    GROUP BY DepartmentID
)
SELECT e.EmployeeID, e.EmployeeName, e.DepartmentID, e.Salary
FROM dbo.Employees AS e
JOIN DepartmentAverages AS d ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > d.AvgSalary;


/* 25. Use a CTE to calculate order totals */
WITH OrderTotals AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS CalculatedTotal
    FROM dbo.OrderItems
    GROUP BY OrderID
)
SELECT OrderID, CalculatedTotal
FROM OrderTotals
ORDER BY CalculatedTotal DESC;


/* 26. Use EXISTS to find customers with orders */
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
WHERE EXISTS (
    SELECT 1 FROM dbo.Orders AS o
    WHERE o.CustomerID = c.CustomerID
);


/* 27. Find the latest order for each customer */
WITH RankedOrders AS (
    SELECT OrderID, CustomerID, OrderDate,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC) AS rn
    FROM dbo.Orders
)
SELECT OrderID, CustomerID, OrderDate
FROM RankedOrders
WHERE rn = 1;


/* 28. Find each customer's first order */
SELECT CustomerID, MIN(OrderDate) AS FirstOrderDate
FROM dbo.Orders
GROUP BY CustomerID;


/* 29. Calculate a running sales total */
WITH DailySales AS (
    SELECT CAST(OrderDate AS DATE) AS OrderDay, SUM(TotalAmount) AS Sales
    FROM dbo.Orders
    GROUP BY CAST(OrderDate AS DATE)
)
SELECT OrderDay, Sales,
       SUM(Sales) OVER (ORDER BY OrderDay ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningSales
FROM DailySales
ORDER BY OrderDay;


/* 30. Compare each month with the previous month */
WITH MonthlySales AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
SalesComparison AS (
    SELECT SalesMonth, Revenue,
           LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue
    FROM MonthlySales
)
SELECT SalesMonth, Revenue, PreviousMonthRevenue,
       (Revenue - PreviousMonthRevenue) * 100.0 / NULLIF(PreviousMonthRevenue, 0) AS MoMPercentChange
FROM SalesComparison
ORDER BY SalesMonth;


/* 31. Calculate each category's share of revenue */
WITH CategorySales AS (
    SELECT p.Category, SUM(oi.Quantity * oi.UnitPrice) AS Revenue
    FROM dbo.OrderItems AS oi
    JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
    GROUP BY p.Category
)
SELECT Category, Revenue,
       Revenue * 100.0 / NULLIF(SUM(Revenue) OVER (), 0) AS RevenueSharePercent
FROM CategorySales
ORDER BY Revenue DESC;


/* 32. Find customers above average order value */
WITH CustomerSpend AS (
    SELECT CustomerID, AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AvgOrderValue
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT CustomerID, AvgOrderValue
FROM CustomerSpend
WHERE AvgOrderValue > (SELECT AVG(CAST(TotalAmount AS DECIMAL(18,2))) FROM dbo.Orders);


/* 33. Find consecutive orders using LAG */
WITH OrderHistory AS (
    SELECT CustomerID, OrderID, OrderDate,
           LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate, OrderID) AS PreviousOrderDate
    FROM dbo.Orders
)
SELECT CustomerID, OrderID, OrderDate, PreviousOrderDate,
       DATEDIFF(DAY, PreviousOrderDate, OrderDate) AS DaysSincePreviousOrder
FROM OrderHistory;


/* 34. Calculate a 3-row moving average of daily sales */
WITH DailySales AS (
    SELECT CAST(OrderDate AS DATE) AS OrderDay, SUM(TotalAmount) AS Sales
    FROM dbo.Orders
    GROUP BY CAST(OrderDate AS DATE)
)
SELECT OrderDay, Sales,
       AVG(CAST(Sales AS DECIMAL(18,2))) OVER (
           ORDER BY OrderDay ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS MovingAverage3Rows
FROM DailySales
ORDER BY OrderDay;


/* 35. Find duplicate rows by business key and keep latest */
WITH Duplicates AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC
    ) AS rn
    FROM dbo.Orders
)
SELECT *
FROM Duplicates
WHERE rn = 1;


/* 36. Pivot order counts by status */
SELECT CustomerID,
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedOrders,
       SUM(CASE WHEN Status = 'Shipped' THEN 1 ELSE 0 END) AS ShippedOrders,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS PendingOrders
FROM dbo.Orders
GROUP BY CustomerID;


/* 37. Find the most expensive product in each category */
WITH RankedProducts AS (
    SELECT ProductID, ProductName, Category, Price,
           DENSE_RANK() OVER (PARTITION BY Category ORDER BY Price DESC) AS rn
    FROM dbo.Products
)
SELECT ProductID, ProductName, Category, Price
FROM RankedProducts
WHERE rn = 1;


/* 38. Find customers who ordered in one year but not another (Shifted to 2029/2030) */
SELECT DISTINCT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2029-01-01' AND OrderDate < '2030-01-01'
EXCEPT
SELECT DISTINCT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2030-01-01' AND OrderDate < '2031-01-01';


/* 39. Calculate order value including line items */
SELECT o.OrderID, o.CustomerID, o.OrderDate,
       SUM(oi.Quantity * oi.UnitPrice) AS CalculatedOrderValue
FROM dbo.Orders AS o
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
GROUP BY o.OrderID, o.CustomerID, o.OrderDate;


/* 40. Find orders where stored total differs from line total */
WITH LineTotals AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS LineTotal
    FROM dbo.OrderItems
    GROUP BY OrderID
)
SELECT o.OrderID, o.TotalAmount, l.LineTotal,
       o.TotalAmount - l.LineTotal AS Difference
FROM dbo.Orders AS o
JOIN LineTotals AS l ON l.OrderID = o.OrderID
WHERE ABS(o.TotalAmount - l.LineTotal) > 0.01;


/* 41. Calculate percentage of employees in each department */
SELECT DepartmentID, COUNT(*) AS EmployeeCount,
       COUNT(*) * 100.0 / NULLIF(SUM(COUNT(*)) OVER (), 0) AS PercentOfEmployees
FROM dbo.Employees
GROUP BY DepartmentID;


/* 42. Find employees hired in the last 12 months */
SELECT EmployeeID, EmployeeName, HireDate
FROM dbo.Employees
WHERE HireDate >= DATEADD(MONTH, -12, CAST(GETDATE() AS DATE))
  AND HireDate < DATEADD(DAY, 1, CAST(GETDATE() AS DATE));


/* 43. Calculate days between order and shipment */
SELECT OrderID, OrderDate, ShipDate,
       DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Orders
WHERE ShipDate IS NOT NULL;


/* 44. Find the median salary */
SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary)
       OVER () AS MedianSalary
FROM dbo.Employees
WHERE Salary IS NOT NULL;


/* 45. Identify outlier prices using IQR */
WITH Quartiles AS (
    SELECT DISTINCT
           PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Price) OVER () AS Q1,
           PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Price) OVER () AS Q3
    FROM dbo.Products
    WHERE Price IS NOT NULL
)
SELECT p.ProductID, p.ProductName, p.Price, q.Q1, q.Q3
FROM dbo.Products AS p
CROSS JOIN Quartiles AS q
WHERE p.Price < q.Q1 - 1.5 * (q.Q3 - q.Q1)
   OR p.Price > q.Q3 + 1.5 * (q.Q3 - q.Q1);


/* 46. Find missing dates in the order activity calendar */
WITH OrderDays AS (
    SELECT DISTINCT CAST(OrderDate AS DATE) AS OrderDay
    FROM dbo.Orders
),
DateRange AS (
    SELECT MIN(OrderDay) AS StartDay, MAX(OrderDay) AS EndDay
    FROM OrderDays
),
Calendar AS (
    SELECT StartDay AS CalendarDay, EndDay
    FROM DateRange
    UNION ALL
    SELECT DATEADD(DAY, 1, CalendarDay), EndDay
    FROM Calendar
    WHERE CalendarDay < EndDay
)
SELECT c.CalendarDay
FROM Calendar AS c
LEFT JOIN OrderDays AS o ON o.OrderDay = c.CalendarDay
WHERE o.OrderDay IS NULL
OPTION (MAXRECURSION 0);


/* 47. Find customers with orders in at least 3 distinct months */
SELECT CustomerID, COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) AS ActiveMonths
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) >= 3;


/* 48. Calculate customer repeat-purchase rate */
WITH CustomerOrders AS (
    SELECT CustomerID, COUNT(*) AS OrderCount
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT COUNT(CASE WHEN OrderCount >= 2 THEN 1 END) AS RepeatCustomers,
       COUNT(*) AS CustomersWithOrders,
       COUNT(CASE WHEN OrderCount >= 2 THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS RepeatPurchaseRatePercent
FROM CustomerOrders;


/* 49. Calculate customer retention by first-order cohort and next month */
WITH FirstOrder AS (
    SELECT CustomerID, MIN(DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) AS CohortMonth
    FROM dbo.Orders
    GROUP BY CustomerID
),
CustomerActivity AS (
    SELECT DISTINCT CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS ActivityMonth
    FROM dbo.Orders
)
SELECT f.CohortMonth,
       COUNT(DISTINCT f.CustomerID) AS CohortCustomers,
       COUNT(DISTINCT CASE WHEN a.ActivityMonth = DATEADD(MONTH, 1, f.CohortMonth) THEN f.CustomerID END) AS RetainedNextMonth,
       COUNT(DISTINCT CASE WHEN a.ActivityMonth = DATEADD(MONTH, 1, f.CohortMonth) THEN f.CustomerID END) * 100.0
           / NULLIF(COUNT(DISTINCT f.CustomerID), 0) AS NextMonthRetentionPercent
FROM FirstOrder AS f
LEFT JOIN CustomerActivity AS a ON a.CustomerID = f.CustomerID
GROUP BY f.CohortMonth
ORDER BY f.CohortMonth;


/* 50. Inspect query execution plan and IO/time (Shifted to 2029) */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT CustomerID, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
WHERE OrderDate >= '2029-01-01' AND OrderDate < '2030-01-01'
GROUP BY CustomerID;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;


/* 51. Daily sales summary */
SELECT CAST(OrderDate AS DATE) AS OrderDay,
       COUNT(*) AS OrderCount,
       SUM(TotalAmount) AS Revenue,
       AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AverageOrderValue
FROM dbo.Orders
WHERE OrderDate >= DATEADD(DAY, -30, CAST(GETDATE() AS DATE))
GROUP BY CAST(OrderDate AS DATE)
ORDER BY OrderDay;


/* 52. Sales by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 53. Sales by region */
SELECT c.Region, COUNT(o.OrderID) AS OrderCount, SUM(o.TotalAmount) AS Revenue
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
GROUP BY c.Region
ORDER BY Revenue DESC;


/* 54. Sales by product category */
SELECT p.Category, SUM(oi.Quantity) AS UnitsSold,
       SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM dbo.OrderItems AS oi
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
GROUP BY p.Category
ORDER BY Revenue DESC;


/* 55. Top 10 customers by lifetime revenue */
SELECT TOP (10) c.CustomerID, c.CustomerName,
       SUM(o.TotalAmount) AS LifetimeRevenue
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY LifetimeRevenue DESC;


/* 56. Top 10 products by units sold */
SELECT TOP (10) p.ProductID, p.ProductName,
       SUM(oi.Quantity) AS UnitsSold
FROM dbo.OrderItems AS oi
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY UnitsSold DESC;


/* 57. Revenue by order status */
SELECT Status, COUNT(*) AS OrderCount, SUM(TotalAmount) AS TotalAmount
FROM dbo.Orders
GROUP BY Status
ORDER BY TotalAmount DESC;


/* 58. Cancellation rate */
SELECT COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) AS CancelledOrders,
       COUNT(*) AS TotalOrders,
       COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS CancellationRatePercent
FROM dbo.Orders;


/* 59. Average order value by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AverageOrderValue
FROM dbo.Orders
WHERE TotalAmount IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 60. Customers who have not ordered in 90 days */
SELECT c.CustomerID, c.CustomerName, MAX(o.OrderDate) AS LastOrderDate
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING MAX(o.OrderDate) IS NULL
    OR MAX(o.OrderDate) < DATEADD(DAY, -90, GETDATE());


/* 61. Customers who ordered this month */
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderDate >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
  AND o.OrderDate < DATEADD(MONTH, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1));


/* 62. Orders above the overall average order value */
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE TotalAmount > (SELECT AVG(CAST(TotalAmount AS DECIMAL(18,2))) FROM dbo.Orders);


/* 63. Daily order count by status */
SELECT CAST(OrderDate AS DATE) AS OrderDay,
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS Completed,
       SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS Pending
FROM dbo.Orders
GROUP BY CAST(OrderDate AS DATE)
ORDER BY OrderDay;


/* 64. Check duplicate customer records */
SELECT CustomerName, Email, COUNT(*) AS RecordCount
FROM dbo.Customers
GROUP BY CustomerName, Email
HAVING COUNT(*) > 1;


/* 65. Check duplicate order IDs */
SELECT OrderID, COUNT(*) AS RecordCount
FROM dbo.Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;


/* 66. Check missing required values */
SELECT
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS MissingOrderDate,
    SUM(CASE WHEN TotalAmount IS NULL THEN 1 ELSE 0 END) AS MissingTotalAmount
FROM dbo.Orders;


/* 67. Find negative or zero order amounts */
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE TotalAmount <= 0;


/* 68. Find negative prices or quantities */
SELECT OrderID, ProductID, Quantity, UnitPrice
FROM dbo.OrderItems
WHERE Quantity <= 0 OR UnitPrice < 0;


/* 69. Find orders with no matching customer */
SELECT o.*
FROM dbo.Orders AS o
LEFT JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL;


/* 70. Find order items with no matching product */
SELECT oi.*
FROM dbo.OrderItems AS oi
LEFT JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
WHERE p.ProductID IS NULL;


/* 71. Standardize text for review (trim and lowercase) */
SELECT CustomerID, CustomerName, Email,
       LOWER(LTRIM(RTRIM(Email))) AS StandardizedEmail
FROM dbo.Customers;


/* 72. Find leading/trailing spaces in customer names */
SELECT CustomerID, CustomerName
FROM dbo.Customers
WHERE CustomerName <> LTRIM(RTRIM(CustomerName));


/* 73. Count distinct customers per month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       COUNT(DISTINCT CustomerID) AS ActiveCustomers
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 74. Compare current month and previous month revenue */
WITH MonthlyRevenue AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
)
SELECT SalesMonth, Revenue,
       LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue,
       Revenue - LAG(Revenue) OVER (ORDER BY SalesMonth) AS RevenueChange
FROM MonthlyRevenue
ORDER BY SalesMonth;


/* 75. Year-over-year revenue comparison */
WITH YearlyRevenue AS (
    SELECT YEAR(OrderDate) AS SalesYear, SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY YEAR(OrderDate)
)
SELECT SalesYear, Revenue,
       LAG(Revenue) OVER (ORDER BY SalesYear) AS PreviousYearRevenue,
       (Revenue - LAG(Revenue) OVER (ORDER BY SalesYear)) * 100.0
           / NULLIF(LAG(Revenue) OVER (ORDER BY SalesYear), 0) AS YoYPercentChange
FROM YearlyRevenue
ORDER BY SalesYear;


/* 76. Revenue by weekday */
SELECT DATENAME(WEEKDAY, OrderDate) AS WeekdayName,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATENAME(WEEKDAY, OrderDate), DATEPART(WEEKDAY, OrderDate)
ORDER BY DATEPART(WEEKDAY, OrderDate);

/* 77. Revenue by hour of day */
-- 1. Alter the columns from DATE to DATETIME
ALTER TABLE dbo.Orders ALTER COLUMN OrderDate DATETIME;
ALTER TABLE dbo.Orders ALTER COLUMN ShipDate DATETIME;
GO

-- 2. Update existing rows to include distinct hours for Query 77
UPDATE dbo.Orders SET OrderDate = DATEADD(HOUR, 9, CAST(OrderDate AS DATETIME)) WHERE OrderID = 20001;
UPDATE dbo.Orders SET OrderDate = DATEADD(HOUR, 11, CAST(OrderDate AS DATETIME)) WHERE OrderID = 20002;
UPDATE dbo.Orders SET OrderDate = DATEADD(HOUR, 14, CAST(OrderDate AS DATETIME)) WHERE OrderID = 20003;
UPDATE dbo.Orders SET OrderDate = DATEADD(HOUR, 16, CAST(OrderDate AS DATETIME)) WHERE OrderID = 20004;
UPDATE dbo.Orders SET OrderDate = DATEADD(HOUR, 8, CAST(OrderDate AS DATETIME)) WHERE OrderID = 20005;
GO
SELECT DATEPART(HOUR, OrderDate) AS OrderHour,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEPART(HOUR, OrderDate)
ORDER BY OrderHour;


/* 78. Average shipping time by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS OrderMonth,
       AVG(CAST(DATEDIFF(DAY, OrderDate, ShipDate) AS DECIMAL(10,2))) AS AvgDaysToShip
FROM dbo.Orders
WHERE ShipDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY OrderMonth;


/* 79. Late shipments */
SELECT OrderID, OrderDate, ShipDate,
       DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Orders
WHERE ShipDate > DATEADD(DAY, 3, OrderDate);


/* 80. Products below reorder level */
SELECT ProductID, ProductName, StockQuantity, ReorderLevel
FROM dbo.Products
WHERE StockQuantity <= ReorderLevel;


/* 81. Inventory value by category */
SELECT Category,
       SUM(CAST(StockQuantity AS DECIMAL(18,2)) * Price) AS InventoryValue
FROM dbo.Products
GROUP BY Category
ORDER BY InventoryValue DESC;


/* 82. Calculate gross margin per product */
SELECT ProductID, ProductName, Price, CostPrice,
       Price - CostPrice AS GrossProfitPerUnit,
       (Price - CostPrice) * 100.0 / NULLIF(Price, 0) AS GrossMarginPercent
FROM dbo.Products
WHERE Price IS NOT NULL AND CostPrice IS NOT NULL;


/* 83. Discount analysis */
SELECT ProductID, ProductName, OriginalPrice, Price,
       OriginalPrice - Price AS DiscountAmount,
       (OriginalPrice - Price) * 100.0 / NULLIF(OriginalPrice, 0) AS DiscountPercent
FROM dbo.Products
WHERE OriginalPrice > 0 AND Price IS NOT NULL;


/* 84. Average salary by department */
SELECT d.DepartmentName,
       AVG(CAST(e.Salary AS DECIMAL(18,2))) AS AverageSalary,
       MIN(e.Salary) AS MinimumSalary,
       MAX(e.Salary) AS MaximumSalary,
       COUNT(*) AS EmployeeCount
FROM dbo.Employees AS e
JOIN dbo.Departments AS d ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY AverageSalary DESC;


/* 85. Headcount by department */
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS Headcount
FROM dbo.Departments AS d
LEFT JOIN dbo.Employees AS e ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY Headcount DESC;


/* 86. Employees missing a department match */
SELECT e.EmployeeID, e.EmployeeName, e.DepartmentID
FROM dbo.Employees AS e
LEFT JOIN dbo.Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentID IS NULL;


/* 87. New hires by month */
SELECT DATEFROMPARTS(YEAR(HireDate), MONTH(HireDate), 1) AS HireMonth,
       COUNT(*) AS NewHires
FROM dbo.Employees
WHERE HireDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(HireDate), MONTH(HireDate), 1)
ORDER BY HireMonth;


/* 88. Employee salary compared with department average */
SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
       AVG(CAST(Salary AS DECIMAL(18,2))) OVER (PARTITION BY DepartmentID) AS DepartmentAverage
FROM dbo.Employees;


/* 89. Find customers with multiple orders on the same day */
SELECT CustomerID, CAST(OrderDate AS DATE) AS OrderDay, COUNT(*) AS OrdersThatDay
FROM dbo.Orders
GROUP BY CustomerID, CAST(OrderDate AS DATE)
HAVING COUNT(*) > 1;


/* 90. Calculate order-item contribution to order total */
WITH LineValues AS (
    SELECT OrderID, ProductID, Quantity * UnitPrice AS LineValue
    FROM dbo.OrderItems
),
OrderValues AS (
    SELECT OrderID, SUM(LineValue) AS OrderValue
    FROM LineValues
    GROUP BY OrderID
)
SELECT l.OrderID, l.ProductID, l.LineValue, o.OrderValue,
       l.LineValue * 100.0 / NULLIF(o.OrderValue, 0) AS PercentOfOrder
FROM LineValues AS l
JOIN OrderValues AS o ON o.OrderID = l.OrderID;


/* 91. Identify customers whose spending declined month over month */
WITH CustomerMonthlySpend AS (
    SELECT CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS MonthlySpend
    FROM dbo.Orders
    GROUP BY CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
SpendComparison AS (
    SELECT CustomerID, SalesMonth, MonthlySpend,
           LAG(MonthlySpend) OVER (PARTITION BY CustomerID ORDER BY SalesMonth) AS PreviousMonthSpend
    FROM CustomerMonthlySpend
)
SELECT CustomerID, SalesMonth, MonthlySpend, PreviousMonthSpend
FROM SpendComparison
WHERE PreviousMonthSpend IS NOT NULL AND MonthlySpend < PreviousMonthSpend;


/* 92. Segment customers by lifetime spending */
WITH CustomerSpend AS (
    SELECT c.CustomerID, c.CustomerName, COALESCE(SUM(o.TotalAmount), 0) AS LifetimeSpend
    FROM dbo.Customers AS c
    LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT *, CASE WHEN LifetimeSpend >= 10000 THEN 'High Value'
               WHEN LifetimeSpend >= 2500 THEN 'Medium Value'
               ELSE 'Low Value' END AS CustomerSegment
FROM CustomerSpend;


/* 93. Calculate RFM-style recency, frequency, monetary value */
SELECT c.CustomerID, c.CustomerName,
       MAX(o.OrderDate) AS LastOrderDate,
       DATEDIFF(DAY, MAX(o.OrderDate), CAST(GETDATE() AS DATE)) AS RecencyDays,
       COUNT(o.OrderID) AS Frequency,
       COALESCE(SUM(o.TotalAmount), 0) AS MonetaryValue
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName;


/* 94. Find customers with a high-value recent order */
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.TotalAmount >= 1000
  AND o.OrderDate >= DATEADD(DAY, -30, GETDATE());


/* 95. Weekly sales summary */
SELECT DATEADD(DAY, 1 - DATEPART(WEEKDAY, CAST(OrderDate AS DATE)), CAST(OrderDate AS DATE)) AS WeekStart,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEADD(DAY, 1 - DATEPART(WEEKDAY, CAST(OrderDate AS DATE)), CAST(OrderDate AS DATE))
ORDER BY WeekStart;


/* 96. Build a reusable filtered dataset with a CTE */
WITH RecentCompletedOrders AS (
    SELECT OrderID, CustomerID, OrderDate, TotalAmount
    FROM dbo.Orders
    WHERE Status = 'Completed'
      AND OrderDate >= DATEADD(MONTH, -3, GETDATE())
)
SELECT CustomerID, COUNT(*) AS CompletedOrders, SUM(TotalAmount) AS Revenue
FROM RecentCompletedOrders
GROUP BY CustomerID
ORDER BY Revenue DESC;


/* 97. Create a temporary table for repeated analysis */
DROP TABLE IF EXISTS #MonthlySales;

SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       SUM(TotalAmount) AS Revenue
INTO #MonthlySales
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1);

SELECT SalesMonth, Revenue
FROM #MonthlySales
ORDER BY SalesMonth;


/* 98. Add a nonclustered index for a common filter */
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate
ON dbo.Orders (OrderDate)
INCLUDE (CustomerID, Status, TotalAmount);


/* 99. Safely test a data update inside a transaction */
BEGIN TRANSACTION;

UPDATE dbo.Products
SET Price = Price * 1.05
WHERE Category = 'Hardware';

-- Check affected rows and values before deciding:
SELECT ProductID, ProductName, Category, Price
FROM dbo.Products
WHERE Category = 'Hardware';

-- Run ONE of these after reviewing the result:
-- COMMIT TRANSACTION;
-- ROLLBACK TRANSACTION;


/* 100. Produce a compact data-quality summary for core tables */
SELECT 'Departments' AS TableName, COUNT(*) AS "RowCount" FROM dbo.Departments
UNION ALL
SELECT 'Employees', COUNT(*) FROM dbo.Employees
UNION ALL
SELECT 'Customers', COUNT(*) FROM dbo.Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM dbo.Orders
UNION ALL
SELECT 'OrderItems', COUNT(*) FROM dbo.OrderItems
UNION ALL
SELECT 'Products', COUNT(*) FROM dbo.Products;



/*
SQL SERVER DATA ANALYST PRACTICE LIBRARY — ROUND 7 (QUERIES 01–100)
===================================================================

Dialect: Microsoft SQL Server (T-SQL)
Description: Round 7 iteration featuring fully seeded tables, DATETIME types 
for order timestamps (resolving hour extraction), shifted date baselines (2030/2031), 
updated numerical thresholds, and clean syntax.
*/

CREATE DATABASE SQLMastery_Round7;
GO
USE SQLMastery_Round7;
GO

-- ============================================================================
-- SETUP BLOCK: MOCK SCHEMA & SEED DATA (DATETIME used for timestamp support)
-- ============================================================================
CREATE TABLE dbo.Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE dbo.Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeName VARCHAR(100),
    DepartmentID INT FOREIGN KEY REFERENCES dbo.Departments(DepartmentID),
    Salary DECIMAL(18,2),
    HireDate DATE
);

CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50),
    Region VARCHAR(50)
);

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES dbo.Customers(CustomerID),
    OrderDate DATETIME,
    ShipDate DATETIME,
    Status VARCHAR(50),
    TotalAmount DECIMAL(18,2)
);

CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(18,2),
    CostPrice DECIMAL(18,2),
    OriginalPrice DECIMAL(18,2),
    StockQuantity INT,
    ReorderLevel INT
);

CREATE TABLE dbo.OrderItems (
    OrderID INT FOREIGN KEY REFERENCES dbo.Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES dbo.Products(ProductID),
    Quantity INT,
    UnitPrice DECIMAL(18,2)
);

-- Seed Data
INSERT INTO dbo.Departments VALUES 
(100, 'Executive Leadership'), 
(200, 'Advanced Analytics'), 
(300, 'Global Sales Ops'), 
(400, 'Cloud Engineering');

INSERT INTO dbo.Employees (EmployeeName, DepartmentID, Salary, HireDate) VALUES 
('Karim Nabil', 100, 150000.00, '2023-01-15'),
('Mariam Adel', 200, 125000.00, '2023-07-20'),
('Ahmed Samir', 300, 98000.00, '2024-03-10'),
('Dina Farouk', 400, 112000.00, '2025-05-18');

INSERT INTO dbo.Customers VALUES 
(3001, 'Quantum Dynamics', 'contact@quantumdyn.io', 'Toronto', 'North America'),
(3002, 'Nordic Systems', NULL, 'Stockholm', 'Europe'),
(3003, 'Aero Logistics', 'ops@aerolog.com', 'Tokyo', 'APAC'),
(3004, 'Titan Industries', 'info@titanind.com', 'Toronto', 'North America');

INSERT INTO dbo.Products VALUES 
(601, 'AI Supercluster Node', 'Hardware', 7000.00, 5200.00, 7500.00, 4, 10),
(602, 'Enterprise Data Fabric', 'Software', 2000.00, 700.00, 2200.00, 50, 20),
(603, 'Global Security Operations', 'Services', 4000.00, 1500.00, 4500.00, 10, 5),
(604, 'Core Switch Matrix', 'Hardware', 3000.00, 2200.00, 3300.00, 25, 12);

INSERT INTO dbo.Orders VALUES 
(30001, 3001, '2030-01-10 08:30:00', '2030-01-12 14:00:00', 'Completed', 9000.00),
(30002, 3002, '2030-04-15 10:15:00', '2030-04-20 16:45:00', 'Completed', 2000.00),
(30003, 3001, '2030-06-22 13:20:00', '2030-06-25 11:00:00', 'Shipped', 4000.00),
(30004, 3003, '2030-09-05 15:50:00', NULL, 'Pending', 7000.00),
(30005, 3004, '2030-11-12 09:10:00', '2030-11-15 12:30:00', 'Completed', 5000.00);

INSERT INTO dbo.OrderItems VALUES 
(30001, 601, 1, 7000.00),
(30001, 602, 1, 2000.00),
(30002, 602, 1, 2000.00),
(30003, 603, 1, 4000.00),
(30004, 601, 1, 7000.00),
(30005, 602, 1, 2000.00),
(30005, 604, 1, 3000.00);
GO


/* 01. Filter rows with WHERE */
SELECT OrderID, CustomerID, OrderDate, Status
FROM dbo.Orders
WHERE Status = 'Completed';


/* 02. Sort results */
SELECT ProductID, ProductName, Price
FROM dbo.Products
ORDER BY Price DESC;


/* 03. Return the top 10 records */
SELECT TOP (10) OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
ORDER BY TotalAmount DESC;


/* 04. Find distinct categories */
SELECT DISTINCT Category
FROM dbo.Products
ORDER BY Category;


/* 05. Count all rows vs non-NULL values */
SELECT COUNT(*) AS TotalRows,
       COUNT(Email) AS RowsWithEmail
FROM dbo.Customers;


/* 06. Find NULL values */
SELECT CustomerID, CustomerName, Email
FROM dbo.Customers
WHERE Email IS NULL;


/* 07. Use CASE to classify values */
SELECT ProductID, ProductName, Price,
       CASE WHEN Price >= 5000 THEN 'High'
            WHEN Price >= 2500 THEN 'Medium'
            ELSE 'Low' END AS PriceBand
FROM dbo.Products;


/* 08. Aggregate with GROUP BY */
SELECT Status, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY Status;


/* 09. Filter groups with HAVING */
SELECT CustomerID, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(*) >= 2;


/* 10. Calculate average salary */
SELECT AVG(CAST(Salary AS DECIMAL(18,2))) AS AverageSalary
FROM dbo.Employees;


/* 11. INNER JOIN two tables */
SELECT o.OrderID, c.CustomerName, o.OrderDate
FROM dbo.Orders AS o
INNER JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID;


/* 12. LEFT JOIN to keep unmatched customers */
SELECT c.CustomerID, c.CustomerName, o.OrderID
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID;


/* 13. Find customers with no orders */
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;


/* 14. Find products never ordered */
SELECT p.ProductID, p.ProductName
FROM dbo.Products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.OrderItems AS oi
    WHERE oi.ProductID = p.ProductID
);


/* 15. Join three tables */
SELECT o.OrderID, c.CustomerName, p.ProductName, oi.Quantity
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID;


/* 16. UNION vs UNION ALL pattern */
SELECT City FROM dbo.Customers
UNION
SELECT Region FROM dbo.Customers;


/* 17. Find duplicate emails */
SELECT Email, COUNT(*) AS DuplicateCount
FROM dbo.Customers
WHERE Email IS NOT NULL
GROUP BY Email
HAVING COUNT(*) > 1;


/* 18. Find the second-highest distinct salary */
WITH SalaryRanks AS (
    SELECT Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM dbo.Employees
    WHERE Salary IS NOT NULL
)
SELECT DISTINCT Salary
FROM SalaryRanks
WHERE SalaryRank = 2;


/* 19. Find the Nth-highest salary (change @N) */
DECLARE @N INT = 2;
WITH SalaryRanks AS (
    SELECT EmployeeID, EmployeeName, Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM dbo.Employees
    WHERE Salary IS NOT NULL
)
SELECT EmployeeID, EmployeeName, Salary
FROM SalaryRanks
WHERE SalaryRank = @N;


/* 20. Rank employees within each department */
SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
       RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
FROM dbo.Employees;


/* 21. Top 3 employees per department */
WITH RankedEmployees AS (
    SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
           ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC, EmployeeID) AS rn
    FROM dbo.Employees
)
SELECT EmployeeID, EmployeeName, DepartmentID, Salary
FROM RankedEmployees
WHERE rn <= 3;


/* 22. Compare ROW_NUMBER, RANK, DENSE_RANK */
SELECT EmployeeID, EmployeeName, Salary,
       ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNum,
       RANK() OVER (ORDER BY Salary DESC) AS SalaryRank,
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseSalaryRank
FROM dbo.Employees;


/* 23. Find employees paid above company average */
SELECT EmployeeID, EmployeeName, Salary
FROM dbo.Employees
WHERE Salary > (SELECT AVG(CAST(Salary AS DECIMAL(18,2))) FROM dbo.Employees);


/* 24. Find employees paid above their department average */
WITH DepartmentAverages AS (
    SELECT DepartmentID, AVG(CAST(Salary AS DECIMAL(18,2))) AS AvgSalary
    FROM dbo.Employees
    GROUP BY DepartmentID
)
SELECT e.EmployeeID, e.EmployeeName, e.DepartmentID, e.Salary
FROM dbo.Employees AS e
JOIN DepartmentAverages AS d ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > d.AvgSalary;


/* 25. Use a CTE to calculate order totals */
WITH OrderTotals AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS CalculatedTotal
    FROM dbo.OrderItems
    GROUP BY OrderID
)
SELECT OrderID, CalculatedTotal
FROM OrderTotals
ORDER BY CalculatedTotal DESC;


/* 26. Use EXISTS to find customers with orders */
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
WHERE EXISTS (
    SELECT 1 FROM dbo.Orders AS o
    WHERE o.CustomerID = c.CustomerID
);


/* 27. Find the latest order for each customer */
WITH RankedOrders AS (
    SELECT OrderID, CustomerID, OrderDate,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC) AS rn
    FROM dbo.Orders
)
SELECT OrderID, CustomerID, OrderDate
FROM RankedOrders
WHERE rn = 1;


/* 28. Find each customer's first order */
SELECT CustomerID, MIN(OrderDate) AS FirstOrderDate
FROM dbo.Orders
GROUP BY CustomerID;


/* 29. Calculate a running sales total */
WITH DailySales AS (
    SELECT CAST(OrderDate AS DATE) AS OrderDay, SUM(TotalAmount) AS Sales
    FROM dbo.Orders
    GROUP BY CAST(OrderDate AS DATE)
)
SELECT OrderDay, Sales,
       SUM(Sales) OVER (ORDER BY OrderDay ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningSales
FROM DailySales
ORDER BY OrderDay;


/* 30. Compare each month with the previous month */
WITH MonthlySales AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
SalesComparison AS (
    SELECT SalesMonth, Revenue,
           LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue
    FROM MonthlySales
)
SELECT SalesMonth, Revenue, PreviousMonthRevenue,
       (Revenue - PreviousMonthRevenue) * 100.0 / NULLIF(PreviousMonthRevenue, 0) AS MoMPercentChange
FROM SalesComparison
ORDER BY SalesMonth;


/* 31. Calculate each category's share of revenue */
WITH CategorySales AS (
    SELECT p.Category, SUM(oi.Quantity * oi.UnitPrice) AS Revenue
    FROM dbo.OrderItems AS oi
    JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
    GROUP BY p.Category
)
SELECT Category, Revenue,
       Revenue * 100.0 / NULLIF(SUM(Revenue) OVER (), 0) AS RevenueSharePercent
FROM CategorySales
ORDER BY Revenue DESC;


/* 32. Find customers above average order value */
WITH CustomerSpend AS (
    SELECT CustomerID, AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AvgOrderValue
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT CustomerID, AvgOrderValue
FROM CustomerSpend
WHERE AvgOrderValue > (SELECT AVG(CAST(TotalAmount AS DECIMAL(18,2))) FROM dbo.Orders);


/* 33. Find consecutive orders using LAG */
WITH OrderHistory AS (
    SELECT CustomerID, OrderID, OrderDate,
           LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate, OrderID) AS PreviousOrderDate
    FROM dbo.Orders
)
SELECT CustomerID, OrderID, OrderDate, PreviousOrderDate,
       DATEDIFF(DAY, PreviousOrderDate, OrderDate) AS DaysSincePreviousOrder
FROM OrderHistory;


/* 34. Calculate a 3-row moving average of daily sales */
WITH DailySales AS (
    SELECT CAST(OrderDate AS DATE) AS OrderDay, SUM(TotalAmount) AS Sales
    FROM dbo.Orders
    GROUP BY CAST(OrderDate AS DATE)
)
SELECT OrderDay, Sales,
       AVG(CAST(Sales AS DECIMAL(18,2))) OVER (
           ORDER BY OrderDay ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS MovingAverage3Rows
FROM DailySales
ORDER BY OrderDay;


/* 35. Find duplicate rows by business key and keep latest */
WITH Duplicates AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC
    ) AS rn
    FROM dbo.Orders
)
SELECT *
FROM Duplicates
WHERE rn = 1;


/* 36. Pivot order counts by status */
SELECT CustomerID,
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedOrders,
       SUM(CASE WHEN Status = 'Shipped' THEN 1 ELSE 0 END) AS ShippedOrders,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS PendingOrders
FROM dbo.Orders
GROUP BY CustomerID;


/* 37. Find the most expensive product in each category */
WITH RankedProducts AS (
    SELECT ProductID, ProductName, Category, Price,
           DENSE_RANK() OVER (PARTITION BY Category ORDER BY Price DESC) AS rn
    FROM dbo.Products
)
SELECT ProductID, ProductName, Category, Price
FROM RankedProducts
WHERE rn = 1;


/* 38. Find customers who ordered in one year but not another (Shifted to 2030/2031) */
SELECT DISTINCT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2030-01-01' AND OrderDate < '2031-01-01'
EXCEPT
SELECT DISTINCT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2031-01-01' AND OrderDate < '2032-01-01';


/* 39. Calculate order value including line items */
SELECT o.OrderID, o.CustomerID, o.OrderDate,
       SUM(oi.Quantity * oi.UnitPrice) AS CalculatedOrderValue
FROM dbo.Orders AS o
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
GROUP BY o.OrderID, o.CustomerID, o.OrderDate;


/* 40. Find orders where stored total differs from line total */
WITH LineTotals AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS LineTotal
    FROM dbo.OrderItems
    GROUP BY OrderID
)
SELECT o.OrderID, o.TotalAmount, l.LineTotal,
       o.TotalAmount - l.LineTotal AS Difference
FROM dbo.Orders AS o
JOIN LineTotals AS l ON l.OrderID = o.OrderID
WHERE ABS(o.TotalAmount - l.LineTotal) > 0.01;


/* 41. Calculate percentage of employees in each department */
SELECT DepartmentID, COUNT(*) AS EmployeeCount,
       COUNT(*) * 100.0 / NULLIF(SUM(COUNT(*)) OVER (), 0) AS PercentOfEmployees
FROM dbo.Employees
GROUP BY DepartmentID;


/* 42. Find employees hired in the last 12 months */
SELECT EmployeeID, EmployeeName, HireDate
FROM dbo.Employees
WHERE HireDate >= DATEADD(MONTH, -12, CAST(GETDATE() AS DATE))
  AND HireDate < DATEADD(DAY, 1, CAST(GETDATE() AS DATE));


/* 43. Calculate days between order and shipment */
SELECT OrderID, OrderDate, ShipDate,
       DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Orders
WHERE ShipDate IS NOT NULL;


/* 44. Find the median salary */
SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary)
       OVER () AS MedianSalary
FROM dbo.Employees
WHERE Salary IS NOT NULL;


/* 45. Identify outlier prices using IQR */
WITH Quartiles AS (
    SELECT DISTINCT
           PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Price) OVER () AS Q1,
           PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Price) OVER () AS Q3
    FROM dbo.Products
    WHERE Price IS NOT NULL
)
SELECT p.ProductID, p.ProductName, p.Price, q.Q1, q.Q3
FROM dbo.Products AS p
CROSS JOIN Quartiles AS q
WHERE p.Price < q.Q1 - 1.5 * (q.Q3 - q.Q1)
   OR p.Price > q.Q3 + 1.5 * (q.Q3 - q.Q1);


/* 46. Find missing dates in the order activity calendar */
WITH OrderDays AS (
    SELECT DISTINCT CAST(OrderDate AS DATE) AS OrderDay
    FROM dbo.Orders
),
DateRange AS (
    SELECT MIN(OrderDay) AS StartDay, MAX(OrderDay) AS EndDay
    FROM OrderDays
),
Calendar AS (
    SELECT StartDay AS CalendarDay, EndDay
    FROM DateRange
    UNION ALL
    SELECT DATEADD(DAY, 1, CalendarDay), EndDay
    FROM Calendar
    WHERE CalendarDay < EndDay
)
SELECT c.CalendarDay
FROM Calendar AS c
LEFT JOIN OrderDays AS o ON o.OrderDay = c.CalendarDay
WHERE o.OrderDay IS NULL
OPTION (MAXRECURSION 0);


/* 47. Find customers with orders in at least 3 distinct months */
SELECT CustomerID, COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) AS ActiveMonths
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) >= 3;


/* 48. Calculate customer repeat-purchase rate */
WITH CustomerOrders AS (
    SELECT CustomerID, COUNT(*) AS OrderCount
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT COUNT(CASE WHEN OrderCount >= 2 THEN 1 END) AS RepeatCustomers,
       COUNT(*) AS CustomersWithOrders,
       COUNT(CASE WHEN OrderCount >= 2 THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS RepeatPurchaseRatePercent
FROM CustomerOrders;


/* 49. Calculate customer retention by first-order cohort and next month */
WITH FirstOrder AS (
    SELECT CustomerID, MIN(DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) AS CohortMonth
    FROM dbo.Orders
    GROUP BY CustomerID
),
CustomerActivity AS (
    SELECT DISTINCT CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS ActivityMonth
    FROM dbo.Orders
)
SELECT f.CohortMonth,
       COUNT(DISTINCT f.CustomerID) AS CohortCustomers,
       COUNT(DISTINCT CASE WHEN a.ActivityMonth = DATEADD(MONTH, 1, f.CohortMonth) THEN f.CustomerID END) AS RetainedNextMonth,
       COUNT(DISTINCT CASE WHEN a.ActivityMonth = DATEADD(MONTH, 1, f.CohortMonth) THEN f.CustomerID END) * 100.0
           / NULLIF(COUNT(DISTINCT f.CustomerID), 0) AS NextMonthRetentionPercent
FROM FirstOrder AS f
LEFT JOIN CustomerActivity AS a ON a.CustomerID = f.CustomerID
GROUP BY f.CohortMonth
ORDER BY f.CohortMonth;


/* 50. Inspect query execution plan and IO/time (Shifted to 2030) */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT CustomerID, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
WHERE OrderDate >= '2030-01-01' AND OrderDate < '2031-01-01'
GROUP BY CustomerID;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;


/* 51. Daily sales summary */
SELECT CAST(OrderDate AS DATE) AS OrderDay,
       COUNT(*) AS OrderCount,
       SUM(TotalAmount) AS Revenue,
       AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AverageOrderValue
FROM dbo.Orders
WHERE OrderDate >= DATEADD(DAY, -30, CAST(GETDATE() AS DATE))
GROUP BY CAST(OrderDate AS DATE)
ORDER BY OrderDay;


/* 52. Sales by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 53. Sales by region */
SELECT c.Region, COUNT(o.OrderID) AS OrderCount, SUM(o.TotalAmount) AS Revenue
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
GROUP BY c.Region
ORDER BY Revenue DESC;


/* 54. Sales by product category */
SELECT p.Category, SUM(oi.Quantity) AS UnitsSold,
       SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM dbo.OrderItems AS oi
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
GROUP BY p.Category
ORDER BY Revenue DESC;


/* 55. Top 10 customers by lifetime revenue */
SELECT TOP (10) c.CustomerID, c.CustomerName,
       SUM(o.TotalAmount) AS LifetimeRevenue
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY LifetimeRevenue DESC;


/* 56. Top 10 products by units sold */
SELECT TOP (10) p.ProductID, p.ProductName,
       SUM(oi.Quantity) AS UnitsSold
FROM dbo.OrderItems AS oi
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY UnitsSold DESC;


/* 57. Revenue by order status */
SELECT Status, COUNT(*) AS OrderCount, SUM(TotalAmount) AS TotalAmount
FROM dbo.Orders
GROUP BY Status
ORDER BY TotalAmount DESC;


/* 58. Cancellation rate */
SELECT COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) AS CancelledOrders,
       COUNT(*) AS TotalOrders,
       COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS CancellationRatePercent
FROM dbo.Orders;


/* 59. Average order value by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AverageOrderValue
FROM dbo.Orders
WHERE TotalAmount IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 60. Customers who have not ordered in 90 days */
SELECT c.CustomerID, c.CustomerName, MAX(o.OrderDate) AS LastOrderDate
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING MAX(o.OrderDate) IS NULL
    OR MAX(o.OrderDate) < DATEADD(DAY, -90, GETDATE());


/* 61. Customers who ordered this month */
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderDate >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
  AND o.OrderDate < DATEADD(MONTH, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1));


/* 62. Orders above the overall average order value */
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE TotalAmount > (SELECT AVG(CAST(TotalAmount AS DECIMAL(18,2))) FROM dbo.Orders);


/* 63. Daily order count by status */
SELECT CAST(OrderDate AS DATE) AS OrderDay,
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS Completed,
       SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS Pending
FROM dbo.Orders
GROUP BY CAST(OrderDate AS DATE)
ORDER BY OrderDay;


/* 64. Check duplicate customer records */
SELECT CustomerName, Email, COUNT(*) AS RecordCount
FROM dbo.Customers
GROUP BY CustomerName, Email
HAVING COUNT(*) > 1;


/* 65. Check duplicate order IDs */
SELECT OrderID, COUNT(*) AS RecordCount
FROM dbo.Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;


/* 66. Check missing required values */
SELECT
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS MissingOrderDate,
    SUM(CASE WHEN TotalAmount IS NULL THEN 1 ELSE 0 END) AS MissingTotalAmount
FROM dbo.Orders;


/* 67. Find negative or zero order amounts */
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE TotalAmount <= 0;


/* 68. Find negative prices or quantities */
SELECT OrderID, ProductID, Quantity, UnitPrice
FROM dbo.OrderItems
WHERE Quantity <= 0 OR UnitPrice < 0;


/* 69. Find orders with no matching customer */
SELECT o.*
FROM dbo.Orders AS o
LEFT JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL;


/* 70. Find order items with no matching product */
SELECT oi.*
FROM dbo.OrderItems AS oi
LEFT JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
WHERE p.ProductID IS NULL;


/* 71. Standardize text for review (trim and lowercase) */
SELECT CustomerID, CustomerName, Email,
       LOWER(LTRIM(RTRIM(Email))) AS StandardizedEmail
FROM dbo.Customers;


/* 72. Find leading/trailing spaces in customer names */
SELECT CustomerID, CustomerName
FROM dbo.Customers
WHERE CustomerName <> LTRIM(RTRIM(CustomerName));


/* 73. Count distinct customers per month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       COUNT(DISTINCT CustomerID) AS ActiveCustomers
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 74. Compare current month and previous month revenue */
WITH MonthlyRevenue AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
)
SELECT SalesMonth, Revenue,
       LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue,
       Revenue - LAG(Revenue) OVER (ORDER BY SalesMonth) AS RevenueChange
FROM MonthlyRevenue
ORDER BY SalesMonth;


/* 75. Year-over-year revenue comparison */
WITH YearlyRevenue AS (
    SELECT YEAR(OrderDate) AS SalesYear, SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY YEAR(OrderDate)
)
SELECT SalesYear, Revenue,
       LAG(Revenue) OVER (ORDER BY SalesYear) AS PreviousYearRevenue,
       (Revenue - LAG(Revenue) OVER (ORDER BY SalesYear)) * 100.0
           / NULLIF(LAG(Revenue) OVER (ORDER BY SalesYear), 0) AS YoYPercentChange
FROM YearlyRevenue
ORDER BY SalesYear;


/* 76. Revenue by weekday */
SELECT DATENAME(WEEKDAY, OrderDate) AS WeekdayName,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATENAME(WEEKDAY, OrderDate), DATEPART(WEEKDAY, OrderDate)
ORDER BY DATEPART(WEEKDAY, OrderDate);


/* 77. Revenue by hour of day (Now fully supported with DATETIME) */
SELECT DATEPART(HOUR, OrderDate) AS OrderHour,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEPART(HOUR, OrderDate)
ORDER BY OrderHour;


/* 78. Average shipping time by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS OrderMonth,
       AVG(CAST(DATEDIFF(DAY, OrderDate, ShipDate) AS DECIMAL(10,2))) AS AvgDaysToShip
FROM dbo.Orders
WHERE ShipDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY OrderMonth;


/* 79. Late shipments */
SELECT OrderID, OrderDate, ShipDate,
       DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Orders
WHERE ShipDate > DATEADD(DAY, 3, OrderDate);


/* 80. Products below reorder level */
SELECT ProductID, ProductName, StockQuantity, ReorderLevel
FROM dbo.Products
WHERE StockQuantity <= ReorderLevel;


/* 81. Inventory value by category */
SELECT Category,
       SUM(CAST(StockQuantity AS DECIMAL(18,2)) * Price) AS InventoryValue
FROM dbo.Products
GROUP BY Category
ORDER BY InventoryValue DESC;


/* 82. Calculate gross margin per product */
SELECT ProductID, ProductName, Price, CostPrice,
       Price - CostPrice AS GrossProfitPerUnit,
       (Price - CostPrice) * 100.0 / NULLIF(Price, 0) AS GrossMarginPercent
FROM dbo.Products
WHERE Price IS NOT NULL AND CostPrice IS NOT NULL;


/* 83. Discount analysis */
SELECT ProductID, ProductName, OriginalPrice, Price,
       OriginalPrice - Price AS DiscountAmount,
       (OriginalPrice - Price) * 100.0 / NULLIF(OriginalPrice, 0) AS DiscountPercent
FROM dbo.Products
WHERE OriginalPrice > 0 AND Price IS NOT NULL;


/* 84. Average salary by department */
SELECT d.DepartmentName,
       AVG(CAST(e.Salary AS DECIMAL(18,2))) AS AverageSalary,
       MIN(e.Salary) AS MinimumSalary,
       MAX(e.Salary) AS MaximumSalary,
       COUNT(*) AS EmployeeCount
FROM dbo.Employees AS e
JOIN dbo.Departments AS d ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY AverageSalary DESC;


/* 85. Headcount by department */
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS Headcount
FROM dbo.Departments AS d
LEFT JOIN dbo.Employees AS e ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY Headcount DESC;


/* 86. Employees missing a department match */
SELECT e.EmployeeID, e.EmployeeName, e.DepartmentID
FROM dbo.Employees AS e
LEFT JOIN dbo.Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentID IS NULL;


/* 87. New hires by month */
SELECT DATEFROMPARTS(YEAR(HireDate), MONTH(HireDate), 1) AS HireMonth,
       COUNT(*) AS NewHires
FROM dbo.Employees
WHERE HireDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(HireDate), MONTH(HireDate), 1)
ORDER BY HireMonth;


/* 88. Employee salary compared with department average */
SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
       AVG(CAST(Salary AS DECIMAL(18,2))) OVER (PARTITION BY DepartmentID) AS DepartmentAverage
FROM dbo.Employees;


/* 89. Find customers with multiple orders on the same day */
SELECT CustomerID, CAST(OrderDate AS DATE) AS OrderDay, COUNT(*) AS OrdersThatDay
FROM dbo.Orders
GROUP BY CustomerID, CAST(OrderDate AS DATE)
HAVING COUNT(*) > 1;


/* 90. Calculate order-item contribution to order total */
WITH LineValues AS (
    SELECT OrderID, ProductID, Quantity * UnitPrice AS LineValue
    FROM dbo.OrderItems
),
OrderValues AS (
    SELECT OrderID, SUM(LineValue) AS OrderValue
    FROM LineValues
    GROUP BY OrderID
)
SELECT l.OrderID, l.ProductID, l.LineValue, o.OrderValue,
       l.LineValue * 100.0 / NULLIF(o.OrderValue, 0) AS PercentOfOrder
FROM LineValues AS l
JOIN OrderValues AS o ON o.OrderID = l.OrderID;


/* 91. Identify customers whose spending declined month over month */
WITH CustomerMonthlySpend AS (
    SELECT CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS MonthlySpend
    FROM dbo.Orders
    GROUP BY CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
SpendComparison AS (
    SELECT CustomerID, SalesMonth, MonthlySpend,
           LAG(MonthlySpend) OVER (PARTITION BY CustomerID ORDER BY SalesMonth) AS PreviousMonthSpend
    FROM CustomerMonthlySpend
)
SELECT CustomerID, SalesMonth, MonthlySpend, PreviousMonthSpend
FROM SpendComparison
WHERE PreviousMonthSpend IS NOT NULL AND MonthlySpend < PreviousMonthSpend;


/* 92. Segment customers by lifetime spending */
WITH CustomerSpend AS (
    SELECT c.CustomerID, c.CustomerName, COALESCE(SUM(o.TotalAmount), 0) AS LifetimeSpend
    FROM dbo.Customers AS c
    LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT *, CASE WHEN LifetimeSpend >= 10000 THEN 'High Value'
               WHEN LifetimeSpend >= 2500 THEN 'Medium Value'
               ELSE 'Low Value' END AS CustomerSegment
FROM CustomerSpend;


/* 93. Calculate RFM-style recency, frequency, monetary value */
SELECT c.CustomerID, c.CustomerName,
       MAX(o.OrderDate) AS LastOrderDate,
       DATEDIFF(DAY, MAX(o.OrderDate), CAST(GETDATE() AS DATE)) AS RecencyDays,
       COUNT(o.OrderID) AS Frequency,
       COALESCE(SUM(o.TotalAmount), 0) AS MonetaryValue
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName;


/* 94. Find customers with a high-value recent order */
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.TotalAmount >= 1000
  AND o.OrderDate >= DATEADD(DAY, -30, GETDATE());


/* 95. Weekly sales summary */
SELECT DATEADD(DAY, 1 - DATEPART(WEEKDAY, CAST(OrderDate AS DATE)), CAST(OrderDate AS DATE)) AS WeekStart,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEADD(DAY, 1 - DATEPART(WEEKDAY, CAST(OrderDate AS DATE)), CAST(OrderDate AS DATE))
ORDER BY WeekStart;


/* 96. Build a reusable filtered dataset with a CTE */
WITH RecentCompletedOrders AS (
    SELECT OrderID, CustomerID, OrderDate, TotalAmount
    FROM dbo.Orders
    WHERE Status = 'Completed'
      AND OrderDate >= DATEADD(MONTH, -3, GETDATE())
)
SELECT CustomerID, COUNT(*) AS CompletedOrders, SUM(TotalAmount) AS Revenue
FROM RecentCompletedOrders
GROUP BY CustomerID
ORDER BY Revenue DESC;


/* 97. Create a temporary table for repeated analysis */
DROP TABLE IF EXISTS #MonthlySales;

SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       SUM(TotalAmount) AS Revenue
INTO #MonthlySales
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1);

SELECT SalesMonth, Revenue
FROM #MonthlySales
ORDER BY SalesMonth;


/* 98. Add a nonclustered index for a common filter */
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate
ON dbo.Orders (OrderDate)
INCLUDE (CustomerID, Status, TotalAmount);


/* 99. Safely test a data update inside a transaction */
BEGIN TRANSACTION;

UPDATE dbo.Products
SET Price = Price * 1.05
WHERE Category = 'Hardware';

-- Check affected rows and values before deciding:
SELECT ProductID, ProductName, Category, Price
FROM dbo.Products
WHERE Category = 'Hardware';

-- Run ONE of these after reviewing the result:
-- COMMIT TRANSACTION;
-- ROLLBACK TRANSACTION;


/* 100. Produce a compact data-quality summary for core tables */
SELECT 'Departments' AS TableName, COUNT(*) AS "RowCount" FROM dbo.Departments
UNION ALL
SELECT 'Employees', COUNT(*) FROM dbo.Employees
UNION ALL
SELECT 'Customers', COUNT(*) FROM dbo.Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM dbo.Orders
UNION ALL
SELECT 'OrderItems', COUNT(*) FROM dbo.OrderItems
UNION ALL
SELECT 'Products', COUNT(*) FROM dbo.Products;




/*
SQL SERVER DATA ANALYST PRACTICE LIBRARY — ROUND 8 (QUERIES 01–100)
===================================================================

Dialect: Microsoft SQL Server (T-SQL)
Description: Round 8 iteration featuring fully seeded tables, DATETIME timestamps, 
shifted date baselines (2031/2032), updated numerical thresholds, and clean syntax.
*/

CREATE DATABASE SQLMastery_Round8;
GO
USE SQLMastery_Round8;
GO

-- ============================================================================
-- SETUP BLOCK: MOCK SCHEMA & SEED DATA
-- ============================================================================
CREATE TABLE dbo.Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE dbo.Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeName VARCHAR(100),
    DepartmentID INT FOREIGN KEY REFERENCES dbo.Departments(DepartmentID),
    Salary DECIMAL(18,2),
    HireDate DATE
);

CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50),
    Region VARCHAR(50)
);

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES dbo.Customers(CustomerID),
    OrderDate DATETIME,
    ShipDate DATETIME,
    Status VARCHAR(50),
    TotalAmount DECIMAL(18,2)
);

CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(18,2),
    CostPrice DECIMAL(18,2),
    OriginalPrice DECIMAL(18,2),
    StockQuantity INT,
    ReorderLevel INT
);

CREATE TABLE dbo.OrderItems (
    OrderID INT FOREIGN KEY REFERENCES dbo.Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES dbo.Products(ProductID),
    Quantity INT,
    UnitPrice DECIMAL(18,2)
);

-- Seed Data (Round 8 Values)
INSERT INTO dbo.Departments VALUES 
(500, 'Enterprise Architecture'), 
(600, 'Cloud Operations'), 
(700, 'Global Sales'), 
(800, 'Business Intelligence');

INSERT INTO dbo.Employees (EmployeeName, DepartmentID, Salary, HireDate) VALUES 
('Tarek Mounir', 500, 160000.00, '2023-02-10'),
('Noha Fikry', 600, 130000.00, '2023-08-15'),
('Ehab Tawfik', 700, 102000.00, '2024-04-12'),
('Rania Youssef', 800, 115000.00, '2025-06-20');

INSERT INTO dbo.Customers VALUES 
(4001, 'Apex Solutions', 'contact@apexsol.com', 'Melbourne', 'APAC'),
(4002, 'Vanguard Tech', NULL, 'Zurich', 'Europe'),
(4003, 'Global Freight', 'ops@globalfreight.net', 'Dubai', 'MENA'),
(4004, 'Sigma Holdings', 'info@sigmaholdings.org', 'Melbourne', 'APAC');

INSERT INTO dbo.Products VALUES 
(701, 'Quantum Rack Unit', 'Hardware', 8000.00, 6000.00, 8500.00, 3, 10),
(702, 'Enterprise Data Lake', 'Software', 2500.00, 900.00, 2800.00, 40, 15),
(703, 'Managed SOC 24/7', 'Services', 4500.00, 1800.00, 5000.00, 8, 4),
(704, 'Core Router Blade', 'Hardware', 3500.00, 2600.00, 3800.00, 20, 10);

INSERT INTO dbo.Orders VALUES 
(40001, 4001, '2031-01-15 09:00:00', '2031-01-17 15:00:00', 'Completed', 10500.00),
(40002, 4002, '2031-04-12 11:30:00', '2031-04-18 16:00:00', 'Completed', 2500.00),
(40003, 4001, '2031-07-20 14:10:00', '2031-07-23 10:30:00', 'Shipped', 4500.00),
(40004, 4003, '2031-09-18 16:20:00', NULL, 'Pending', 8000.00),
(40005, 4004, '2031-11-08 08:45:00', '2031-11-11 12:00:00', 'Completed', 6000.00);

INSERT INTO dbo.OrderItems VALUES 
(40001, 701, 1, 8000.00),
(40001, 702, 1, 2500.00),
(40002, 702, 1, 2500.00),
(40003, 703, 1, 4500.00),
(40004, 701, 1, 8000.00),
(40005, 702, 1, 2500.00),
(40005, 704, 1, 3500.00);
GO


/* 01. Filter rows with WHERE */
SELECT OrderID, CustomerID, OrderDate, Status
FROM dbo.Orders
WHERE Status = 'Completed';


/* 02. Sort results */
SELECT ProductID, ProductName, Price
FROM dbo.Products
ORDER BY Price DESC;


/* 03. Return the top 10 records */
SELECT TOP (10) OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
ORDER BY TotalAmount DESC;


/* 04. Find distinct categories */
SELECT DISTINCT Category
FROM dbo.Products
ORDER BY Category;


/* 05. Count all rows vs non-NULL values */
SELECT COUNT(*) AS TotalRows,
       COUNT(Email) AS RowsWithEmail
FROM dbo.Customers;


/* 06. Find NULL values */
SELECT CustomerID, CustomerName, Email
FROM dbo.Customers
WHERE Email IS NULL;


/* 07. Use CASE to classify values */
SELECT ProductID, ProductName, Price,
       CASE WHEN Price >= 6000 THEN 'High'
            WHEN Price >= 3000 THEN 'Medium'
            ELSE 'Low' END AS PriceBand
FROM dbo.Products;


/* 08. Aggregate with GROUP BY */
SELECT Status, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY Status;


/* 09. Filter groups with HAVING */
SELECT CustomerID, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(*) >= 2;


/* 10. Calculate average salary */
SELECT AVG(CAST(Salary AS DECIMAL(18,2))) AS AverageSalary
FROM dbo.Employees;


/* 11. INNER JOIN two tables */
SELECT o.OrderID, c.CustomerName, o.OrderDate
FROM dbo.Orders AS o
INNER JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID;


/* 12. LEFT JOIN to keep unmatched customers */
SELECT c.CustomerID, c.CustomerName, o.OrderID
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID;


/* 13. Find customers with no orders */
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;


/* 14. Find products never ordered */
SELECT p.ProductID, p.ProductName
FROM dbo.Products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.OrderItems AS oi
    WHERE oi.ProductID = p.ProductID
);


/* 15. Join three tables */
SELECT o.OrderID, c.CustomerName, p.ProductName, oi.Quantity
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID;


/* 16. UNION vs UNION ALL pattern */
SELECT City FROM dbo.Customers
UNION
SELECT Region FROM dbo.Customers;


/* 17. Find duplicate emails */
SELECT Email, COUNT(*) AS DuplicateCount
FROM dbo.Customers
WHERE Email IS NOT NULL
GROUP BY Email
HAVING COUNT(*) > 1;


/* 18. Find the second-highest distinct salary */
WITH SalaryRanks AS (
    SELECT Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM dbo.Employees
    WHERE Salary IS NOT NULL
)
SELECT DISTINCT Salary
FROM SalaryRanks
WHERE SalaryRank = 2;


/* 19. Find the Nth-highest salary (change @N) */
DECLARE @N INT = 2;
WITH SalaryRanks AS (
    SELECT EmployeeID, EmployeeName, Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM dbo.Employees
    WHERE Salary IS NOT NULL
)
SELECT EmployeeID, EmployeeName, Salary
FROM SalaryRanks
WHERE SalaryRank = @N;


/* 20. Rank employees within each department */
SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
       RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
FROM dbo.Employees;


/* 21. Top 3 employees per department */
WITH RankedEmployees AS (
    SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
           ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC, EmployeeID) AS rn
    FROM dbo.Employees
)
SELECT EmployeeID, EmployeeName, DepartmentID, Salary
FROM RankedEmployees
WHERE rn <= 3;


/* 22. Compare ROW_NUMBER, RANK, DENSE_RANK */
SELECT EmployeeID, EmployeeName, Salary,
       ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNum,
       RANK() OVER (ORDER BY Salary DESC) AS SalaryRank,
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseSalaryRank
FROM dbo.Employees;


/* 23. Find employees paid above company average */
SELECT EmployeeID, EmployeeName, Salary
FROM dbo.Employees
WHERE Salary > (SELECT AVG(CAST(Salary AS DECIMAL(18,2))) FROM dbo.Employees);


/* 24. Find employees paid above their department average */
WITH DepartmentAverages AS (
    SELECT DepartmentID, AVG(CAST(Salary AS DECIMAL(18,2))) AS AvgSalary
    FROM dbo.Employees
    GROUP BY DepartmentID
)
SELECT e.EmployeeID, e.EmployeeName, e.DepartmentID, e.Salary
FROM dbo.Employees AS e
JOIN DepartmentAverages AS d ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > d.AvgSalary;


/* 25. Use a CTE to calculate order totals */
WITH OrderTotals AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS CalculatedTotal
    FROM dbo.OrderItems
    GROUP BY OrderID
)
SELECT OrderID, CalculatedTotal
FROM OrderTotals
ORDER BY CalculatedTotal DESC;


/* 26. Use EXISTS to find customers with orders */
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
WHERE EXISTS (
    SELECT 1 FROM dbo.Orders AS o
    WHERE o.CustomerID = c.CustomerID
);


/* 27. Find the latest order for each customer */
WITH RankedOrders AS (
    SELECT OrderID, CustomerID, OrderDate,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC) AS rn
    FROM dbo.Orders
)
SELECT OrderID, CustomerID, OrderDate
FROM RankedOrders
WHERE rn = 1;


/* 28. Find each customer's first order */
SELECT CustomerID, MIN(OrderDate) AS FirstOrderDate
FROM dbo.Orders
GROUP BY CustomerID;


/* 29. Calculate a running sales total */
WITH DailySales AS (
    SELECT CAST(OrderDate AS DATE) AS OrderDay, SUM(TotalAmount) AS Sales
    FROM dbo.Orders
    GROUP BY CAST(OrderDate AS DATE)
)
SELECT OrderDay, Sales,
       SUM(Sales) OVER (ORDER BY OrderDay ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningSales
FROM DailySales
ORDER BY OrderDay;


/* 30. Compare each month with the previous month */
WITH MonthlySales AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
SalesComparison AS (
    SELECT SalesMonth, Revenue,
           LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue
    FROM MonthlySales
)
SELECT SalesMonth, Revenue, PreviousMonthRevenue,
       (Revenue - PreviousMonthRevenue) * 100.0 / NULLIF(PreviousMonthRevenue, 0) AS MoMPercentChange
FROM SalesComparison
ORDER BY SalesMonth;


/* 31. Calculate each category's share of revenue */
WITH CategorySales AS (
    SELECT p.Category, SUM(oi.Quantity * oi.UnitPrice) AS Revenue
    FROM dbo.OrderItems AS oi
    JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
    GROUP BY p.Category
)
SELECT Category, Revenue,
       Revenue * 100.0 / NULLIF(SUM(Revenue) OVER (), 0) AS RevenueSharePercent
FROM CategorySales
ORDER BY Revenue DESC;


/* 32. Find customers above average order value */
WITH CustomerSpend AS (
    SELECT CustomerID, AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AvgOrderValue
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT CustomerID, AvgOrderValue
FROM CustomerSpend
WHERE AvgOrderValue > (SELECT AVG(CAST(TotalAmount AS DECIMAL(18,2))) FROM dbo.Orders);


/* 33. Find consecutive orders using LAG */
WITH OrderHistory AS (
    SELECT CustomerID, OrderID, OrderDate,
           LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate, OrderID) AS PreviousOrderDate
    FROM dbo.Orders
)
SELECT CustomerID, OrderID, OrderDate, PreviousOrderDate,
       DATEDIFF(DAY, PreviousOrderDate, OrderDate) AS DaysSincePreviousOrder
FROM OrderHistory;


/* 34. Calculate a 3-row moving average of daily sales */
WITH DailySales AS (
    SELECT CAST(OrderDate AS DATE) AS OrderDay, SUM(TotalAmount) AS Sales
    FROM dbo.Orders
    GROUP BY CAST(OrderDate AS DATE)
)
SELECT OrderDay, Sales,
       AVG(CAST(Sales AS DECIMAL(18,2))) OVER (
           ORDER BY OrderDay ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS MovingAverage3Rows
FROM DailySales
ORDER BY OrderDay;


/* 35. Find duplicate rows by business key and keep latest */
WITH Duplicates AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC
    ) AS rn
    FROM dbo.Orders
)
SELECT *
FROM Duplicates
WHERE rn = 1;


/* 36. Pivot order counts by status */
SELECT CustomerID,
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedOrders,
       SUM(CASE WHEN Status = 'Shipped' THEN 1 ELSE 0 END) AS ShippedOrders,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS PendingOrders
FROM dbo.Orders
GROUP BY CustomerID;


/* 37. Find the most expensive product in each category */
WITH RankedProducts AS (
    SELECT ProductID, ProductName, Category, Price,
           DENSE_RANK() OVER (PARTITION BY Category ORDER BY Price DESC) AS rn
    FROM dbo.Products
)
SELECT ProductID, ProductName, Category, Price
FROM RankedProducts
WHERE rn = 1;


/* 38. Find customers who ordered in one year but not another (Shifted to 2031/2032) */
SELECT DISTINCT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2031-01-01' AND OrderDate < '2032-01-01'
EXCEPT
SELECT DISTINCT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2032-01-01' AND OrderDate < '2033-01-01';


/* 39. Calculate order value including line items */
SELECT o.OrderID, o.CustomerID, o.OrderDate,
       SUM(oi.Quantity * oi.UnitPrice) AS CalculatedOrderValue
FROM dbo.Orders AS o
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
GROUP BY o.OrderID, o.CustomerID, o.OrderDate;


/* 40. Find orders where stored total differs from line total */
WITH LineTotals AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS LineTotal
    FROM dbo.OrderItems
    GROUP BY OrderID
)
SELECT o.OrderID, o.TotalAmount, l.LineTotal,
       o.TotalAmount - l.LineTotal AS Difference
FROM dbo.Orders AS o
JOIN LineTotals AS l ON l.OrderID = o.OrderID
WHERE ABS(o.TotalAmount - l.LineTotal) > 0.01;


/* 41. Calculate percentage of employees in each department */
SELECT DepartmentID, COUNT(*) AS EmployeeCount,
       COUNT(*) * 100.0 / NULLIF(SUM(COUNT(*)) OVER (), 0) AS PercentOfEmployees
FROM dbo.Employees
GROUP BY DepartmentID;


/* 42. Find employees hired in the last 12 months */
SELECT EmployeeID, EmployeeName, HireDate
FROM dbo.Employees
WHERE HireDate >= DATEADD(MONTH, -12, CAST(GETDATE() AS DATE))
  AND HireDate < DATEADD(DAY, 1, CAST(GETDATE() AS DATE));


/* 43. Calculate days between order and shipment */
SELECT OrderID, OrderDate, ShipDate,
       DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Orders
WHERE ShipDate IS NOT NULL;


/* 44. Find the median salary */
SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary)
       OVER () AS MedianSalary
FROM dbo.Employees
WHERE Salary IS NOT NULL;


/* 45. Identify outlier prices using IQR */
WITH Quartiles AS (
    SELECT DISTINCT
           PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Price) OVER () AS Q1,
           PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Price) OVER () AS Q3
    FROM dbo.Products
    WHERE Price IS NOT NULL
)
SELECT p.ProductID, p.ProductName, p.Price, q.Q1, q.Q3
FROM dbo.Products AS p
CROSS JOIN Quartiles AS q
WHERE p.Price < q.Q1 - 1.5 * (q.Q3 - q.Q1)
   OR p.Price > q.Q3 + 1.5 * (q.Q3 - q.Q1);


/* 46. Find missing dates in the order activity calendar */
WITH OrderDays AS (
    SELECT DISTINCT CAST(OrderDate AS DATE) AS OrderDay
    FROM dbo.Orders
),
DateRange AS (
    SELECT MIN(OrderDay) AS StartDay, MAX(OrderDay) AS EndDay
    FROM OrderDays
),
Calendar AS (
    SELECT StartDay AS CalendarDay, EndDay
    FROM DateRange
    UNION ALL
    SELECT DATEADD(DAY, 1, CalendarDay), EndDay
    FROM Calendar
    WHERE CalendarDay < EndDay
)
SELECT c.CalendarDay
FROM Calendar AS c
LEFT JOIN OrderDays AS o ON o.OrderDay = c.CalendarDay
WHERE o.OrderDay IS NULL
OPTION (MAXRECURSION 0);


/* 47. Find customers with orders in at least 3 distinct months */
SELECT CustomerID, COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) AS ActiveMonths
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) >= 3;


/* 48. Calculate customer repeat-purchase rate */
WITH CustomerOrders AS (
    SELECT CustomerID, COUNT(*) AS OrderCount
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT COUNT(CASE WHEN OrderCount >= 2 THEN 1 END) AS RepeatCustomers,
       COUNT(*) AS CustomersWithOrders,
       COUNT(CASE WHEN OrderCount >= 2 THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS RepeatPurchaseRatePercent
FROM CustomerOrders;


/* 49. Calculate customer retention by first-order cohort and next month */
WITH FirstOrder AS (
    SELECT CustomerID, MIN(DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) AS CohortMonth
    FROM dbo.Orders
    GROUP BY CustomerID
),
CustomerActivity AS (
    SELECT DISTINCT CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS ActivityMonth
    FROM dbo.Orders
)
SELECT f.CohortMonth,
       COUNT(DISTINCT f.CustomerID) AS CohortCustomers,
       COUNT(DISTINCT CASE WHEN a.ActivityMonth = DATEADD(MONTH, 1, f.CohortMonth) THEN f.CustomerID END) AS RetainedNextMonth,
       COUNT(DISTINCT CASE WHEN a.ActivityMonth = DATEADD(MONTH, 1, f.CohortMonth) THEN f.CustomerID END) * 100.0
           / NULLIF(COUNT(DISTINCT f.CustomerID), 0) AS NextMonthRetentionPercent
FROM FirstOrder AS f
LEFT JOIN CustomerActivity AS a ON a.CustomerID = f.CustomerID
GROUP BY f.CohortMonth
ORDER BY f.CohortMonth;


/* 50. Inspect query execution plan and IO/time (Shifted to 2031) */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT CustomerID, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
WHERE OrderDate >= '2031-01-01' AND OrderDate < '2032-01-01'
GROUP BY CustomerID;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;


/* 51. Daily sales summary */
SELECT CAST(OrderDate AS DATE) AS OrderDay,
       COUNT(*) AS OrderCount,
       SUM(TotalAmount) AS Revenue,
       AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AverageOrderValue
FROM dbo.Orders
WHERE OrderDate >= DATEADD(DAY, -30, CAST(GETDATE() AS DATE))
GROUP BY CAST(OrderDate AS DATE)
ORDER BY OrderDay;


/* 52. Sales by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 53. Sales by region */
SELECT c.Region, COUNT(o.OrderID) AS OrderCount, SUM(o.TotalAmount) AS Revenue
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
GROUP BY c.Region
ORDER BY Revenue DESC;


/* 54. Sales by product category */
SELECT p.Category, SUM(oi.Quantity) AS UnitsSold,
       SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM dbo.OrderItems AS oi
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
GROUP BY p.Category
ORDER BY Revenue DESC;


/* 55. Top 10 customers by lifetime revenue */
SELECT TOP (10) c.CustomerID, c.CustomerName,
       SUM(o.TotalAmount) AS LifetimeRevenue
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY LifetimeRevenue DESC;


/* 56. Top 10 products by units sold */
SELECT TOP (10) p.ProductID, p.ProductName,
       SUM(oi.Quantity) AS UnitsSold
FROM dbo.OrderItems AS oi
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY UnitsSold DESC;


/* 57. Revenue by order status */
SELECT Status, COUNT(*) AS OrderCount, SUM(TotalAmount) AS TotalAmount
FROM dbo.Orders
GROUP BY Status
ORDER BY TotalAmount DESC;


/* 58. Cancellation rate */
SELECT COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) AS CancelledOrders,
       COUNT(*) AS TotalOrders,
       COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS CancellationRatePercent
FROM dbo.Orders;


/* 59. Average order value by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AverageOrderValue
FROM dbo.Orders
WHERE TotalAmount IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 60. Customers who have not ordered in 90 days */
SELECT c.CustomerID, c.CustomerName, MAX(o.OrderDate) AS LastOrderDate
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING MAX(o.OrderDate) IS NULL
    OR MAX(o.OrderDate) < DATEADD(DAY, -90, GETDATE());


/* 61. Customers who ordered this month */
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderDate >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
  AND o.OrderDate < DATEADD(MONTH, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1));


/* 62. Orders above the overall average order value */
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE TotalAmount > (SELECT AVG(CAST(TotalAmount AS DECIMAL(18,2))) FROM dbo.Orders);


/* 63. Daily order count by status */
SELECT CAST(OrderDate AS DATE) AS OrderDay,
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS Completed,
       SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS Pending
FROM dbo.Orders
GROUP BY CAST(OrderDate AS DATE)
ORDER BY OrderDay;


/* 64. Check duplicate customer records */
SELECT CustomerName, Email, COUNT(*) AS RecordCount
FROM dbo.Customers
GROUP BY CustomerName, Email
HAVING COUNT(*) > 1;


/* 65. Check duplicate order IDs */
SELECT OrderID, COUNT(*) AS RecordCount
FROM dbo.Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;


/* 66. Check missing required values */
SELECT
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS MissingOrderDate,
    SUM(CASE WHEN TotalAmount IS NULL THEN 1 ELSE 0 END) AS MissingTotalAmount
FROM dbo.Orders;


/* 67. Find negative or zero order amounts */
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE TotalAmount <= 0;


/* 68. Find negative prices or quantities */
SELECT OrderID, ProductID, Quantity, UnitPrice
FROM dbo.OrderItems
WHERE Quantity <= 0 OR UnitPrice < 0;


/* 69. Find orders with no matching customer */
SELECT o.*
FROM dbo.Orders AS o
LEFT JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL;


/* 70. Find order items with no matching product */
SELECT oi.*
FROM dbo.OrderItems AS oi
LEFT JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
WHERE p.ProductID IS NULL;


/* 71. Standardize text for review (trim and lowercase) */
SELECT CustomerID, CustomerName, Email,
       LOWER(LTRIM(RTRIM(Email))) AS StandardizedEmail
FROM dbo.Customers;


/* 72. Find leading/trailing spaces in customer names */
SELECT CustomerID, CustomerName
FROM dbo.Customers
WHERE CustomerName <> LTRIM(RTRIM(CustomerName));


/* 73. Count distinct customers per month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       COUNT(DISTINCT CustomerID) AS ActiveCustomers
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 74. Compare current month and previous month revenue */
WITH MonthlyRevenue AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
)
SELECT SalesMonth, Revenue,
       LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue,
       Revenue - LAG(Revenue) OVER (ORDER BY SalesMonth) AS RevenueChange
FROM MonthlyRevenue
ORDER BY SalesMonth;


/* 75. Year-over-year revenue comparison */
WITH YearlyRevenue AS (
    SELECT YEAR(OrderDate) AS SalesYear, SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY YEAR(OrderDate)
)
SELECT SalesYear, Revenue,
       LAG(Revenue) OVER (ORDER BY SalesYear) AS PreviousYearRevenue,
       (Revenue - LAG(Revenue) OVER (ORDER BY SalesYear)) * 100.0
           / NULLIF(LAG(Revenue) OVER (ORDER BY SalesYear), 0) AS YoYPercentChange
FROM YearlyRevenue
ORDER BY SalesYear;


/* 76. Revenue by weekday */
SELECT DATENAME(WEEKDAY, OrderDate) AS WeekdayName,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATENAME(WEEKDAY, OrderDate), DATEPART(WEEKDAY, OrderDate)
ORDER BY DATEPART(WEEKDAY, OrderDate);


/* 77. Revenue by hour of day (Fully supported with DATETIME) */
SELECT DATEPART(HOUR, OrderDate) AS OrderHour,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEPART(HOUR, OrderDate)
ORDER BY OrderHour;


/* 78. Average shipping time by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS OrderMonth,
       AVG(CAST(DATEDIFF(DAY, OrderDate, ShipDate) AS DECIMAL(10,2))) AS AvgDaysToShip
FROM dbo.Orders
WHERE ShipDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY OrderMonth;


/* 79. Late shipments */
SELECT OrderID, OrderDate, ShipDate,
       DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Orders
WHERE ShipDate > DATEADD(DAY, 3, OrderDate);


/* 80. Products below reorder level */
SELECT ProductID, ProductName, StockQuantity, ReorderLevel
FROM dbo.Products
WHERE StockQuantity <= ReorderLevel;


/* 81. Inventory value by category */
SELECT Category,
       SUM(CAST(StockQuantity AS DECIMAL(18,2)) * Price) AS InventoryValue
FROM dbo.Products
GROUP BY Category
ORDER BY InventoryValue DESC;


/* 82. Calculate gross margin per product */
SELECT ProductID, ProductName, Price, CostPrice,
       Price - CostPrice AS GrossProfitPerUnit,
       (Price - CostPrice) * 100.0 / NULLIF(Price, 0) AS GrossMarginPercent
FROM dbo.Products
WHERE Price IS NOT NULL AND CostPrice IS NOT NULL;


/* 83. Discount analysis */
SELECT ProductID, ProductName, OriginalPrice, Price,
       OriginalPrice - Price AS DiscountAmount,
       (OriginalPrice - Price) * 100.0 / NULLIF(OriginalPrice, 0) AS DiscountPercent
FROM dbo.Products
WHERE OriginalPrice > 0 AND Price IS NOT NULL;


/* 84. Average salary by department */
SELECT d.DepartmentName,
       AVG(CAST(e.Salary AS DECIMAL(18,2))) AS AverageSalary,
       MIN(e.Salary) AS MinimumSalary,
       MAX(e.Salary) AS MaximumSalary,
       COUNT(*) AS EmployeeCount
FROM dbo.Employees AS e
JOIN dbo.Departments AS d ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY AverageSalary DESC;


/* 85. Headcount by department */
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS Headcount
FROM dbo.Departments AS d
LEFT JOIN dbo.Employees AS e ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY Headcount DESC;


/* 86. Employees missing a department match */
SELECT e.EmployeeID, e.EmployeeName, e.DepartmentID
FROM dbo.Employees AS e
LEFT JOIN dbo.Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentID IS NULL;


/* 87. New hires by month */
SELECT DATEFROMPARTS(YEAR(HireDate), MONTH(HireDate), 1) AS HireMonth,
       COUNT(*) AS NewHires
FROM dbo.Employees
WHERE HireDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(HireDate), MONTH(HireDate), 1)
ORDER BY HireMonth;


/* 88. Employee salary compared with department average */
SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
       AVG(CAST(Salary AS DECIMAL(18,2))) OVER (PARTITION BY DepartmentID) AS DepartmentAverage
FROM dbo.Employees;


/* 89. Find customers with multiple orders on the same day */
SELECT CustomerID, CAST(OrderDate AS DATE) AS OrderDay, COUNT(*) AS OrdersThatDay
FROM dbo.Orders
GROUP BY CustomerID, CAST(OrderDate AS DATE)
HAVING COUNT(*) > 1;


/* 90. Calculate order-item contribution to order total */
WITH LineValues AS (
    SELECT OrderID, ProductID, Quantity * UnitPrice AS LineValue
    FROM dbo.OrderItems
),
OrderValues AS (
    SELECT OrderID, SUM(LineValue) AS OrderValue
    FROM LineValues
    GROUP BY OrderID
)
SELECT l.OrderID, l.ProductID, l.LineValue, o.OrderValue,
       l.LineValue * 100.0 / NULLIF(o.OrderValue, 0) AS PercentOfOrder
FROM LineValues AS l
JOIN OrderValues AS o ON o.OrderID = l.OrderID;


/* 91. Identify customers whose spending declined month over month */
WITH CustomerMonthlySpend AS (
    SELECT CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS MonthlySpend
    FROM dbo.Orders
    GROUP BY CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
SpendComparison AS (
    SELECT CustomerID, SalesMonth, MonthlySpend,
           LAG(MonthlySpend) OVER (PARTITION BY CustomerID ORDER BY SalesMonth) AS PreviousMonthSpend
    FROM CustomerMonthlySpend
)
SELECT CustomerID, SalesMonth, MonthlySpend, PreviousMonthSpend
FROM SpendComparison
WHERE PreviousMonthSpend IS NOT NULL AND MonthlySpend < PreviousMonthSpend;


/* 92. Segment customers by lifetime spending */
WITH CustomerSpend AS (
    SELECT c.CustomerID, c.CustomerName, COALESCE(SUM(o.TotalAmount), 0) AS LifetimeSpend
    FROM dbo.Customers AS c
    LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT *, CASE WHEN LifetimeSpend >= 10000 THEN 'High Value'
               WHEN LifetimeSpend >= 2500 THEN 'Medium Value'
               ELSE 'Low Value' END AS CustomerSegment
FROM CustomerSpend;


/* 93. Calculate RFM-style recency, frequency, monetary value */
SELECT c.CustomerID, c.CustomerName,
       MAX(o.OrderDate) AS LastOrderDate,
       DATEDIFF(DAY, MAX(o.OrderDate), CAST(GETDATE() AS DATE)) AS RecencyDays,
       COUNT(o.OrderID) AS Frequency,
       COALESCE(SUM(o.TotalAmount), 0) AS MonetaryValue
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName;


/* 94. Find customers with a high-value recent order */
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.TotalAmount >= 1000
  AND o.OrderDate >= DATEADD(DAY, -30, GETDATE());


/* 95. Weekly sales summary */
SELECT DATEADD(DAY, 1 - DATEPART(WEEKDAY, CAST(OrderDate AS DATE)), CAST(OrderDate AS DATE)) AS WeekStart,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEADD(DAY, 1 - DATEPART(WEEKDAY, CAST(OrderDate AS DATE)), CAST(OrderDate AS DATE))
ORDER BY WeekStart;


/* 96. Build a reusable filtered dataset with a CTE */
WITH RecentCompletedOrders AS (
    SELECT OrderID, CustomerID, OrderDate, TotalAmount
    FROM dbo.Orders
    WHERE Status = 'Completed'
      AND OrderDate >= DATEADD(MONTH, -3, GETDATE())
)
SELECT CustomerID, COUNT(*) AS CompletedOrders, SUM(TotalAmount) AS Revenue
FROM RecentCompletedOrders
GROUP BY CustomerID
ORDER BY Revenue DESC;


/* 97. Create a temporary table for repeated analysis */
DROP TABLE IF EXISTS #MonthlySales;

SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       SUM(TotalAmount) AS Revenue
INTO #MonthlySales
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1);

SELECT SalesMonth, Revenue
FROM #MonthlySales
ORDER BY SalesMonth;


/* 98. Add a nonclustered index for a common filter */
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate
ON dbo.Orders (OrderDate)
INCLUDE (CustomerID, Status, TotalAmount);


/* 99. Safely test a data update inside a transaction */
BEGIN TRANSACTION;

UPDATE dbo.Products
SET Price = Price * 1.05
WHERE Category = 'Hardware';

-- Check affected rows and values before deciding:
SELECT ProductID, ProductName, Category, Price
FROM dbo.Products
WHERE Category = 'Hardware';

-- Run ONE of these after reviewing the result:
-- COMMIT TRANSACTION;
-- ROLLBACK TRANSACTION;


/* 100. Produce a compact data-quality summary for core tables */
SELECT 'Departments' AS TableName, COUNT(*) AS "RowCount" FROM dbo.Departments
UNION ALL
SELECT 'Employees', COUNT(*) FROM dbo.Employees
UNION ALL
SELECT 'Customers', COUNT(*) FROM dbo.Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM dbo.Orders
UNION ALL
SELECT 'OrderItems', COUNT(*) FROM dbo.OrderItems
UNION ALL
SELECT 'Products', COUNT(*) FROM dbo.Products;


/*
SQL SERVER DATA ANALYST PRACTICE LIBRARY — ROUND 9 (QUERIES 01–100)
===================================================================

Dialect: Microsoft SQL Server (T-SQL)
Description: Round 9 iteration featuring fully seeded tables, DATETIME timestamps, 
shifted date baselines (2032/2033), updated numerical thresholds, and clean syntax.
*/

CREATE DATABASE SQLMastery_Round9;
GO
USE SQLMastery_Round9;
GO

-- ============================================================================
-- SETUP BLOCK: MOCK SCHEMA & SEED DATA
-- ============================================================================
CREATE TABLE dbo.Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE dbo.Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeName VARCHAR(100),
    DepartmentID INT FOREIGN KEY REFERENCES dbo.Departments(DepartmentID),
    Salary DECIMAL(18,2),
    HireDate DATE
);

CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50),
    Region VARCHAR(50)
);

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES dbo.Customers(CustomerID),
    OrderDate DATETIME,
    ShipDate DATETIME,
    Status VARCHAR(50),
    TotalAmount DECIMAL(18,2)
);

CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(18,2),
    CostPrice DECIMAL(18,2),
    OriginalPrice DECIMAL(18,2),
    StockQuantity INT,
    ReorderLevel INT
);

CREATE TABLE dbo.OrderItems (
    OrderID INT FOREIGN KEY REFERENCES dbo.Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES dbo.Products(ProductID),
    Quantity INT,
    UnitPrice DECIMAL(18,2)
);

-- Seed Data (Round 9 Values)
INSERT INTO dbo.Departments VALUES 
(900, 'Cloud Infrastructure'), 
(1000, 'Cybersecurity'), 
(1100, 'Global Sales'), 
(1200, 'Data Strategy');

INSERT INTO dbo.Employees (EmployeeName, DepartmentID, Salary, HireDate) VALUES 
('Sherif Adel', 900, 165000.00, '2023-01-15'),
('Mona Zaki', 1000, 135000.00, '2023-07-20'),
('Karim Said', 1100, 105000.00, '2024-03-10'),
('Dina Magdy', 1200, 120000.00, '2025-05-18');

INSERT INTO dbo.Customers VALUES 
(5001, 'Zenith Systems', 'contact@zenithsys.io', 'Berlin', 'Europe'),
(5002, 'Pioneer Tech', NULL, 'Tokyo', 'APAC'),
(5003, 'Alpha Logistics', 'ops@alphalog.net', 'London', 'Europe'),
(5004, 'Omega Industries', 'info@omegaind.org', 'Berlin', 'Europe');

INSERT INTO dbo.Products VALUES 
(801, 'Quantum Server Blade', 'Hardware', 8500.00, 6500.00, 9000.00, 4, 10),
(802, 'Enterprise Analytics Engine', 'Software', 3000.00, 1000.00, 3300.00, 45, 15),
(803, 'Managed Threat Response', 'Services', 5000.00, 2000.00, 5500.00, 10, 4),
(804, 'High-Speed Core Switch', 'Hardware', 4000.00, 3000.00, 4300.00, 25, 10);

INSERT INTO dbo.Orders VALUES 
(50001, 5001, '2032-01-10 08:30:00', '2032-01-12 14:00:00', 'Completed', 11500.00),
(50002, 5002, '2032-04-15 10:15:00', '2032-04-20 16:45:00', 'Completed', 3000.00),
(50003, 5001, '2032-06-22 13:20:00', '2032-06-25 11:00:00', 'Shipped', 5000.00),
(50004, 5003, '2032-09-05 15:50:00', NULL, 'Pending', 8500.00),
(50005, 5004, '2032-11-12 09:10:00', '2032-11-15 12:30:00', 'Completed', 7000.00);

INSERT INTO dbo.OrderItems VALUES 
(50001, 801, 1, 8500.00),
(50001, 802, 1, 3000.00),
(50002, 802, 1, 3000.00),
(50003, 803, 1, 5000.00),
(50004, 801, 1, 8500.00),
(50005, 802, 1, 3000.00),
(50005, 804, 1, 4000.00);
GO


/* 01. Filter rows with WHERE */
SELECT OrderID, CustomerID, OrderDate, Status
FROM dbo.Orders
WHERE Status = 'Completed';


/* 02. Sort results */
SELECT ProductID, ProductName, Price
FROM dbo.Products
ORDER BY Price DESC;


/* 03. Return the top 10 records */
SELECT TOP (10) OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
ORDER BY TotalAmount DESC;


/* 04. Find distinct categories */
SELECT DISTINCT Category
FROM dbo.Products
ORDER BY Category;


/* 05. Count all rows vs non-NULL values */
SELECT COUNT(*) AS TotalRows,
       COUNT(Email) AS RowsWithEmail
FROM dbo.Customers;


/* 06. Find NULL values */
SELECT CustomerID, CustomerName, Email
FROM dbo.Customers
WHERE Email IS NULL;


/* 07. Use CASE to classify values */
SELECT ProductID, ProductName, Price,
       CASE WHEN Price >= 6000 THEN 'High'
            WHEN Price >= 3000 THEN 'Medium'
            ELSE 'Low' END AS PriceBand
FROM dbo.Products;


/* 08. Aggregate with GROUP BY */
SELECT Status, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY Status;


/* 09. Filter groups with HAVING */
SELECT CustomerID, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(*) >= 2;


/* 10. Calculate average salary */
SELECT AVG(CAST(Salary AS DECIMAL(18,2))) AS AverageSalary
FROM dbo.Employees;


/* 11. INNER JOIN two tables */
SELECT o.OrderID, c.CustomerName, o.OrderDate
FROM dbo.Orders AS o
INNER JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID;


/* 12. LEFT JOIN to keep unmatched customers */
SELECT c.CustomerID, c.CustomerName, o.OrderID
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID;


/* 13. Find customers with no orders */
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;


/* 14. Find products never ordered */
SELECT p.ProductID, p.ProductName
FROM dbo.Products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.OrderItems AS oi
    WHERE oi.ProductID = p.ProductID
);


/* 15. Join three tables */
SELECT o.OrderID, c.CustomerName, p.ProductName, oi.Quantity
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID;


/* 16. UNION vs UNION ALL pattern */
SELECT City FROM dbo.Customers
UNION
SELECT Region FROM dbo.Customers;


/* 17. Find duplicate emails */
SELECT Email, COUNT(*) AS DuplicateCount
FROM dbo.Customers
WHERE Email IS NOT NULL
GROUP BY Email
HAVING COUNT(*) > 1;


/* 18. Find the second-highest distinct salary */
WITH SalaryRanks AS (
    SELECT Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM dbo.Employees
    WHERE Salary IS NOT NULL
)
SELECT DISTINCT Salary
FROM SalaryRanks
WHERE SalaryRank = 2;


/* 19. Find the Nth-highest salary (change @N) */
DECLARE @N INT = 2;
WITH SalaryRanks AS (
    SELECT EmployeeID, EmployeeName, Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM dbo.Employees
    WHERE Salary IS NOT NULL
)
SELECT EmployeeID, EmployeeName, Salary
FROM SalaryRanks
WHERE SalaryRank = @N;


/* 20. Rank employees within each department */
SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
       RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
FROM dbo.Employees;


/* 21. Top 3 employees per department */
WITH RankedEmployees AS (
    SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
           ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC, EmployeeID) AS rn
    FROM dbo.Employees
)
SELECT EmployeeID, EmployeeName, DepartmentID, Salary
FROM RankedEmployees
WHERE rn <= 3;


/* 22. Compare ROW_NUMBER, RANK, DENSE_RANK */
SELECT EmployeeID, EmployeeName, Salary,
       ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNum,
       RANK() OVER (ORDER BY Salary DESC) AS SalaryRank,
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseSalaryRank
FROM dbo.Employees;


/* 23. Find employees paid above company average */
SELECT EmployeeID, EmployeeName, Salary
FROM dbo.Employees
WHERE Salary > (SELECT AVG(CAST(Salary AS DECIMAL(18,2))) FROM dbo.Employees);


/* 24. Find employees paid above their department average */
WITH DepartmentAverages AS (
    SELECT DepartmentID, AVG(CAST(Salary AS DECIMAL(18,2))) AS AvgSalary
    FROM dbo.Employees
    GROUP BY DepartmentID
)
SELECT e.EmployeeID, e.EmployeeName, e.DepartmentID, e.Salary
FROM dbo.Employees AS e
JOIN DepartmentAverages AS d ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > d.AvgSalary;


/* 25. Use a CTE to calculate order totals */
WITH OrderTotals AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS CalculatedTotal
    FROM dbo.OrderItems
    GROUP BY OrderID
)
SELECT OrderID, CalculatedTotal
FROM OrderTotals
ORDER BY CalculatedTotal DESC;


/* 26. Use EXISTS to find customers with orders */
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
WHERE EXISTS (
    SELECT 1 FROM dbo.Orders AS o
    WHERE o.CustomerID = c.CustomerID
);


/* 27. Find the latest order for each customer */
WITH RankedOrders AS (
    SELECT OrderID, CustomerID, OrderDate,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC) AS rn
    FROM dbo.Orders
)
SELECT OrderID, CustomerID, OrderDate
FROM RankedOrders
WHERE rn = 1;


/* 28. Find each customer's first order */
SELECT CustomerID, MIN(OrderDate) AS FirstOrderDate
FROM dbo.Orders
GROUP BY CustomerID;


/* 29. Calculate a running sales total */
WITH DailySales AS (
    SELECT CAST(OrderDate AS DATE) AS OrderDay, SUM(TotalAmount) AS Sales
    FROM dbo.Orders
    GROUP BY CAST(OrderDate AS DATE)
)
SELECT OrderDay, Sales,
       SUM(Sales) OVER (ORDER BY OrderDay ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningSales
FROM DailySales
ORDER BY OrderDay;


/* 30. Compare each month with the previous month */
WITH MonthlySales AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
SalesComparison AS (
    SELECT SalesMonth, Revenue,
           LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue
    FROM MonthlySales
)
SELECT SalesMonth, Revenue, PreviousMonthRevenue,
       (Revenue - PreviousMonthRevenue) * 100.0 / NULLIF(PreviousMonthRevenue, 0) AS MoMPercentChange
FROM SalesComparison
ORDER BY SalesMonth;


/* 31. Calculate each category's share of revenue */
WITH CategorySales AS (
    SELECT p.Category, SUM(oi.Quantity * oi.UnitPrice) AS Revenue
    FROM dbo.OrderItems AS oi
    JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
    GROUP BY p.Category
)
SELECT Category, Revenue,
       Revenue * 100.0 / NULLIF(SUM(Revenue) OVER (), 0) AS RevenueSharePercent
FROM CategorySales
ORDER BY Revenue DESC;


/* 32. Find customers above average order value */
WITH CustomerSpend AS (
    SELECT CustomerID, AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AvgOrderValue
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT CustomerID, AvgOrderValue
FROM CustomerSpend
WHERE AvgOrderValue > (SELECT AVG(CAST(TotalAmount AS DECIMAL(18,2))) FROM dbo.Orders);


/* 33. Find consecutive orders using LAG */
WITH OrderHistory AS (
    SELECT CustomerID, OrderID, OrderDate,
           LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate, OrderID) AS PreviousOrderDate
    FROM dbo.Orders
)
SELECT CustomerID, OrderID, OrderDate, PreviousOrderDate,
       DATEDIFF(DAY, PreviousOrderDate, OrderDate) AS DaysSincePreviousOrder
FROM OrderHistory;


/* 34. Calculate a 3-row moving average of daily sales */
WITH DailySales AS (
    SELECT CAST(OrderDate AS DATE) AS OrderDay, SUM(TotalAmount) AS Sales
    FROM dbo.Orders
    GROUP BY CAST(OrderDate AS DATE)
)
SELECT OrderDay, Sales,
       AVG(CAST(Sales AS DECIMAL(18,2))) OVER (
           ORDER BY OrderDay ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS MovingAverage3Rows
FROM DailySales
ORDER BY OrderDay;


/* 35. Find duplicate rows by business key and keep latest */
WITH Duplicates AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC
    ) AS rn
    FROM dbo.Orders
)
SELECT *
FROM Duplicates
WHERE rn = 1;


/* 36. Pivot order counts by status */
SELECT CustomerID,
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedOrders,
       SUM(CASE WHEN Status = 'Shipped' THEN 1 ELSE 0 END) AS ShippedOrders,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS PendingOrders
FROM dbo.Orders
GROUP BY CustomerID;


/* 37. Find the most expensive product in each category */
WITH RankedProducts AS (
    SELECT ProductID, ProductName, Category, Price,
           DENSE_RANK() OVER (PARTITION BY Category ORDER BY Price DESC) AS rn
    FROM dbo.Products
)
SELECT ProductID, ProductName, Category, Price
FROM RankedProducts
WHERE rn = 1;


/* 38. Find customers who ordered in one year but not another (Shifted to 2032/2033) */
SELECT DISTINCT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2032-01-01' AND OrderDate < '2033-01-01'
EXCEPT
SELECT DISTINCT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2033-01-01' AND OrderDate < '2034-01-01';


/* 39. Calculate order value including line items */
SELECT o.OrderID, o.CustomerID, o.OrderDate,
       SUM(oi.Quantity * oi.UnitPrice) AS CalculatedOrderValue
FROM dbo.Orders AS o
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
GROUP BY o.OrderID, o.CustomerID, o.OrderDate;


/* 40. Find orders where stored total differs from line total */
WITH LineTotals AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS LineTotal
    FROM dbo.OrderItems
    GROUP BY OrderID
)
SELECT o.OrderID, o.TotalAmount, l.LineTotal,
       o.TotalAmount - l.LineTotal AS Difference
FROM dbo.Orders AS o
JOIN LineTotals AS l ON l.OrderID = o.OrderID
WHERE ABS(o.TotalAmount - l.LineTotal) > 0.01;


/* 41. Calculate percentage of employees in each department */
SELECT DepartmentID, COUNT(*) AS EmployeeCount,
       COUNT(*) * 100.0 / NULLIF(SUM(COUNT(*)) OVER (), 0) AS PercentOfEmployees
FROM dbo.Employees
GROUP BY DepartmentID;


/* 42. Find employees hired in the last 12 months */
SELECT EmployeeID, EmployeeName, HireDate
FROM dbo.Employees
WHERE HireDate >= DATEADD(MONTH, -12, CAST(GETDATE() AS DATE))
  AND HireDate < DATEADD(DAY, 1, CAST(GETDATE() AS DATE));


/* 43. Calculate days between order and shipment */
SELECT OrderID, OrderDate, ShipDate,
       DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Orders
WHERE ShipDate IS NOT NULL;


/* 44. Find the median salary */
SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary)
       OVER () AS MedianSalary
FROM dbo.Employees
WHERE Salary IS NOT NULL;


/* 45. Identify outlier prices using IQR */
WITH Quartiles AS (
    SELECT DISTINCT
           PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Price) OVER () AS Q1,
           PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Price) OVER () AS Q3
    FROM dbo.Products
    WHERE Price IS NOT NULL
)
SELECT p.ProductID, p.ProductName, p.Price, q.Q1, q.Q3
FROM dbo.Products AS p
CROSS JOIN Quartiles AS q
WHERE p.Price < q.Q1 - 1.5 * (q.Q3 - q.Q1)
   OR p.Price > q.Q3 + 1.5 * (q.Q3 - q.Q1);


/* 46. Find missing dates in the order activity calendar */
WITH OrderDays AS (
    SELECT DISTINCT CAST(OrderDate AS DATE) AS OrderDay
    FROM dbo.Orders
),
DateRange AS (
    SELECT MIN(OrderDay) AS StartDay, MAX(OrderDay) AS EndDay
    FROM OrderDays
),
Calendar AS (
    SELECT StartDay AS CalendarDay, EndDay
    FROM DateRange
    UNION ALL
    SELECT DATEADD(DAY, 1, CalendarDay), EndDay
    FROM Calendar
    WHERE CalendarDay < EndDay
)
SELECT c.CalendarDay
FROM Calendar AS c
LEFT JOIN OrderDays AS o ON o.OrderDay = c.CalendarDay
WHERE o.OrderDay IS NULL
OPTION (MAXRECURSION 0);


/* 47. Find customers with orders in at least 3 distinct months */
SELECT CustomerID, COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) AS ActiveMonths
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) >= 3;


/* 48. Calculate customer repeat-purchase rate */
WITH CustomerOrders AS (
    SELECT CustomerID, COUNT(*) AS OrderCount
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT COUNT(CASE WHEN OrderCount >= 2 THEN 1 END) AS RepeatCustomers,
       COUNT(*) AS CustomersWithOrders,
       COUNT(CASE WHEN OrderCount >= 2 THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS RepeatPurchaseRatePercent
FROM CustomerOrders;


/* 49. Calculate customer retention by first-order cohort and next month */
WITH FirstOrder AS (
    SELECT CustomerID, MIN(DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) AS CohortMonth
    FROM dbo.Orders
    GROUP BY CustomerID
),
CustomerActivity AS (
    SELECT DISTINCT CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS ActivityMonth
    FROM dbo.Orders
)
SELECT f.CohortMonth,
       COUNT(DISTINCT f.CustomerID) AS CohortCustomers,
       COUNT(DISTINCT CASE WHEN a.ActivityMonth = DATEADD(MONTH, 1, f.CohortMonth) THEN f.CustomerID END) AS RetainedNextMonth,
       COUNT(DISTINCT CASE WHEN a.ActivityMonth = DATEADD(MONTH, 1, f.CohortMonth) THEN f.CustomerID END) * 100.0
           / NULLIF(COUNT(DISTINCT f.CustomerID), 0) AS NextMonthRetentionPercent
FROM FirstOrder AS f
LEFT JOIN CustomerActivity AS a ON a.CustomerID = f.CustomerID
GROUP BY f.CohortMonth
ORDER BY f.CohortMonth;


/* 50. Inspect query execution plan and IO/time (Shifted to 2032) */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT CustomerID, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
WHERE OrderDate >= '2032-01-01' AND OrderDate < '2033-01-01'
GROUP BY CustomerID;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;


/* 51. Daily sales summary */
SELECT CAST(OrderDate AS DATE) AS OrderDay,
       COUNT(*) AS OrderCount,
       SUM(TotalAmount) AS Revenue,
       AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AverageOrderValue
FROM dbo.Orders
WHERE OrderDate >= DATEADD(DAY, -30, CAST(GETDATE() AS DATE))
GROUP BY CAST(OrderDate AS DATE)
ORDER BY OrderDay;


/* 52. Sales by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 53. Sales by region */
SELECT c.Region, COUNT(o.OrderID) AS OrderCount, SUM(o.TotalAmount) AS Revenue
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
GROUP BY c.Region
ORDER BY Revenue DESC;


/* 54. Sales by product category */
SELECT p.Category, SUM(oi.Quantity) AS UnitsSold,
       SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM dbo.OrderItems AS oi
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
GROUP BY p.Category
ORDER BY Revenue DESC;


/* 55. Top 10 customers by lifetime revenue */
SELECT TOP (10) c.CustomerID, c.CustomerName,
       SUM(o.TotalAmount) AS LifetimeRevenue
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY LifetimeRevenue DESC;


/* 56. Top 10 products by units sold */
SELECT TOP (10) p.ProductID, p.ProductName,
       SUM(oi.Quantity) AS UnitsSold
FROM dbo.OrderItems AS oi
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY UnitsSold DESC;


/* 57. Revenue by order status */
SELECT Status, COUNT(*) AS OrderCount, SUM(TotalAmount) AS TotalAmount
FROM dbo.Orders
GROUP BY Status
ORDER BY TotalAmount DESC;


/* 58. Cancellation rate */
SELECT COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) AS CancelledOrders,
       COUNT(*) AS TotalOrders,
       COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS CancellationRatePercent
FROM dbo.Orders;


/* 59. Average order value by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AverageOrderValue
FROM dbo.Orders
WHERE TotalAmount IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 60. Customers who have not ordered in 90 days */
SELECT c.CustomerID, c.CustomerName, MAX(o.OrderDate) AS LastOrderDate
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING MAX(o.OrderDate) IS NULL
    OR MAX(o.OrderDate) < DATEADD(DAY, -90, GETDATE());


/* 61. Customers who ordered this month */
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderDate >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
  AND o.OrderDate < DATEADD(MONTH, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1));


/* 62. Orders above the overall average order value */
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE TotalAmount > (SELECT AVG(CAST(TotalAmount AS DECIMAL(18,2))) FROM dbo.Orders);


/* 63. Daily order count by status */
SELECT CAST(OrderDate AS DATE) AS OrderDay,
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS Completed,
       SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS Pending
FROM dbo.Orders
GROUP BY CAST(OrderDate AS DATE)
ORDER BY OrderDay;


/* 64. Check duplicate customer records */
SELECT CustomerName, Email, COUNT(*) AS RecordCount
FROM dbo.Customers
GROUP BY CustomerName, Email
HAVING COUNT(*) > 1;


/* 65. Check duplicate order IDs */
SELECT OrderID, COUNT(*) AS RecordCount
FROM dbo.Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;


/* 66. Check missing required values */
SELECT
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS MissingOrderDate,
    SUM(CASE WHEN TotalAmount IS NULL THEN 1 ELSE 0 END) AS MissingTotalAmount
FROM dbo.Orders;


/* 67. Find negative or zero order amounts */
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE TotalAmount <= 0;


/* 68. Find negative prices or quantities */
SELECT OrderID, ProductID, Quantity, UnitPrice
FROM dbo.OrderItems
WHERE Quantity <= 0 OR UnitPrice < 0;


/* 69. Find orders with no matching customer */
SELECT o.*
FROM dbo.Orders AS o
LEFT JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL;


/* 70. Find order items with no matching product */
SELECT oi.*
FROM dbo.OrderItems AS oi
LEFT JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
WHERE p.ProductID IS NULL;


/* 71. Standardize text for review (trim and lowercase) */
SELECT CustomerID, CustomerName, Email,
       LOWER(LTRIM(RTRIM(Email))) AS StandardizedEmail
FROM dbo.Customers;


/* 72. Find leading/trailing spaces in customer names */
SELECT CustomerID, CustomerName
FROM dbo.Customers
WHERE CustomerName <> LTRIM(RTRIM(CustomerName));


/* 73. Count distinct customers per month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       COUNT(DISTINCT CustomerID) AS ActiveCustomers
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 74. Compare current month and previous month revenue */
WITH MonthlyRevenue AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
)
SELECT SalesMonth, Revenue,
       LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue,
       Revenue - LAG(Revenue) OVER (ORDER BY SalesMonth) AS RevenueChange
FROM MonthlyRevenue
ORDER BY SalesMonth;


/* 75. Year-over-year revenue comparison */
WITH YearlyRevenue AS (
    SELECT YEAR(OrderDate) AS SalesYear, SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY YEAR(OrderDate)
)
SELECT SalesYear, Revenue,
       LAG(Revenue) OVER (ORDER BY SalesYear) AS PreviousYearRevenue,
       (Revenue - LAG(Revenue) OVER (ORDER BY SalesYear)) * 100.0
           / NULLIF(LAG(Revenue) OVER (ORDER BY SalesYear), 0) AS YoYPercentChange
FROM YearlyRevenue
ORDER BY SalesYear;


/* 76. Revenue by weekday */
SELECT DATENAME(WEEKDAY, OrderDate) AS WeekdayName,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATENAME(WEEKDAY, OrderDate), DATEPART(WEEKDAY, OrderDate)
ORDER BY DATEPART(WEEKDAY, OrderDate);


/* 77. Revenue by hour of day (Fully supported with DATETIME) */
SELECT DATEPART(HOUR, OrderDate) AS OrderHour,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEPART(HOUR, OrderDate)
ORDER BY OrderHour;


/* 78. Average shipping time by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS OrderMonth,
       AVG(CAST(DATEDIFF(DAY, OrderDate, ShipDate) AS DECIMAL(10,2))) AS AvgDaysToShip
FROM dbo.Orders
WHERE ShipDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY OrderMonth;


/* 79. Late shipments */
SELECT OrderID, OrderDate, ShipDate,
       DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Orders
WHERE ShipDate > DATEADD(DAY, 3, OrderDate);


/* 80. Products below reorder level */
SELECT ProductID, ProductName, StockQuantity, ReorderLevel
FROM dbo.Products
WHERE StockQuantity <= ReorderLevel;


/* 81. Inventory value by category */
SELECT Category,
       SUM(CAST(StockQuantity AS DECIMAL(18,2)) * Price) AS InventoryValue
FROM dbo.Products
GROUP BY Category
ORDER BY InventoryValue DESC;


/* 82. Calculate gross margin per product */
SELECT ProductID, ProductName, Price, CostPrice,
       Price - CostPrice AS GrossProfitPerUnit,
       (Price - CostPrice) * 100.0 / NULLIF(Price, 0) AS GrossMarginPercent
FROM dbo.Products
WHERE Price IS NOT NULL AND CostPrice IS NOT NULL;


/* 83. Discount analysis */
SELECT ProductID, ProductName, OriginalPrice, Price,
       OriginalPrice - Price AS DiscountAmount,
       (OriginalPrice - Price) * 100.0 / NULLIF(OriginalPrice, 0) AS DiscountPercent
FROM dbo.Products
WHERE OriginalPrice > 0 AND Price IS NOT NULL;


/* 84. Average salary by department */
SELECT d.DepartmentName,
       AVG(CAST(e.Salary AS DECIMAL(18,2))) AS AverageSalary,
       MIN(e.Salary) AS MinimumSalary,
       MAX(e.Salary) AS MaximumSalary,
       COUNT(*) AS EmployeeCount
FROM dbo.Employees AS e
JOIN dbo.Departments AS d ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY AverageSalary DESC;


/* 85. Headcount by department */
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS Headcount
FROM dbo.Departments AS d
LEFT JOIN dbo.Employees AS e ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY Headcount DESC;


/* 86. Employees missing a department match */
SELECT e.EmployeeID, e.EmployeeName, e.DepartmentID
FROM dbo.Employees AS e
LEFT JOIN dbo.Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentID IS NULL;


/* 87. New hires by month */
SELECT DATEFROMPARTS(YEAR(HireDate), MONTH(HireDate), 1) AS HireMonth,
       COUNT(*) AS NewHires
FROM dbo.Employees
WHERE HireDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(HireDate), MONTH(HireDate), 1)
ORDER BY HireMonth;


/* 88. Employee salary compared with department average */
SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
       AVG(CAST(Salary AS DECIMAL(18,2))) OVER (PARTITION BY DepartmentID) AS DepartmentAverage
FROM dbo.Employees;


/* 89. Find customers with multiple orders on the same day */
SELECT CustomerID, CAST(OrderDate AS DATE) AS OrderDay, COUNT(*) AS OrdersThatDay
FROM dbo.Orders
GROUP BY CustomerID, CAST(OrderDate AS DATE)
HAVING COUNT(*) > 1;


/* 90. Calculate order-item contribution to order total */
WITH LineValues AS (
    SELECT OrderID, ProductID, Quantity * UnitPrice AS LineValue
    FROM dbo.OrderItems
),
OrderValues AS (
    SELECT OrderID, SUM(LineValue) AS OrderValue
    FROM LineValues
    GROUP BY OrderID
)
SELECT l.OrderID, l.ProductID, l.LineValue, o.OrderValue,
       l.LineValue * 100.0 / NULLIF(o.OrderValue, 0) AS PercentOfOrder
FROM LineValues AS l
JOIN OrderValues AS o ON o.OrderID = l.OrderID;


/* 91. Identify customers whose spending declined month over month */
WITH CustomerMonthlySpend AS (
    SELECT CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS MonthlySpend
    FROM dbo.Orders
    GROUP BY CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
SpendComparison AS (
    SELECT CustomerID, SalesMonth, MonthlySpend,
           LAG(MonthlySpend) OVER (PARTITION BY CustomerID ORDER BY SalesMonth) AS PreviousMonthSpend
    FROM CustomerMonthlySpend
)
SELECT CustomerID, SalesMonth, MonthlySpend, PreviousMonthSpend
FROM SpendComparison
WHERE PreviousMonthSpend IS NOT NULL AND MonthlySpend < PreviousMonthSpend;


/* 92. Segment customers by lifetime spending */
WITH CustomerSpend AS (
    SELECT c.CustomerID, c.CustomerName, COALESCE(SUM(o.TotalAmount), 0) AS LifetimeSpend
    FROM dbo.Customers AS c
    LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT *, CASE WHEN LifetimeSpend >= 10000 THEN 'High Value'
               WHEN LifetimeSpend >= 2500 THEN 'Medium Value'
               ELSE 'Low Value' END AS CustomerSegment
FROM CustomerSpend;


/* 93. Calculate RFM-style recency, frequency, monetary value */
SELECT c.CustomerID, c.CustomerName,
       MAX(o.OrderDate) AS LastOrderDate,
       DATEDIFF(DAY, MAX(o.OrderDate), CAST(GETDATE() AS DATE)) AS RecencyDays,
       COUNT(o.OrderID) AS Frequency,
       COALESCE(SUM(o.TotalAmount), 0) AS MonetaryValue
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName;


/* 94. Find customers with a high-value recent order */
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.TotalAmount >= 1000
  AND o.OrderDate >= DATEADD(DAY, -30, GETDATE());


/* 95. Weekly sales summary */
SELECT DATEADD(DAY, 1 - DATEPART(WEEKDAY, CAST(OrderDate AS DATE)), CAST(OrderDate AS DATE)) AS WeekStart,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEADD(DAY, 1 - DATEPART(WEEKDAY, CAST(OrderDate AS DATE)), CAST(OrderDate AS DATE))
ORDER BY WeekStart;


/* 96. Build a reusable filtered dataset with a CTE */
WITH RecentCompletedOrders AS (
    SELECT OrderID, CustomerID, OrderDate, TotalAmount
    FROM dbo.Orders
    WHERE Status = 'Completed'
      AND OrderDate >= DATEADD(MONTH, -3, GETDATE())
)
SELECT CustomerID, COUNT(*) AS CompletedOrders, SUM(TotalAmount) AS Revenue
FROM RecentCompletedOrders
GROUP BY CustomerID
ORDER BY Revenue DESC;


/* 97. Create a temporary table for repeated analysis */
DROP TABLE IF EXISTS #MonthlySales;

SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       SUM(TotalAmount) AS Revenue
INTO #MonthlySales
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1);

SELECT SalesMonth, Revenue
FROM #MonthlySales
ORDER BY SalesMonth;


/* 98. Add a nonclustered index for a common filter */
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate
ON dbo.Orders (OrderDate)
INCLUDE (CustomerID, Status, TotalAmount);


/* 99. Safely test a data update inside a transaction */
BEGIN TRANSACTION;

UPDATE dbo.Products
SET Price = Price * 1.05
WHERE Category = 'Hardware';

-- Check affected rows and values before deciding:
SELECT ProductID, ProductName, Category, Price
FROM dbo.Products
WHERE Category = 'Hardware';

-- Run ONE of these after reviewing the result:
-- COMMIT TRANSACTION;
-- ROLLBACK TRANSACTION;


/* 100. Produce a compact data-quality summary for core tables */
SELECT 'Departments' AS TableName, COUNT(*) AS "RowCount" FROM dbo.Departments
UNION ALL
SELECT 'Employees', COUNT(*) FROM dbo.Employees
UNION ALL
SELECT 'Customers', COUNT(*) FROM dbo.Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM dbo.Orders
UNION ALL
SELECT 'OrderItems', COUNT(*) FROM dbo.OrderItems
UNION ALL
SELECT 'Products', COUNT(*) FROM dbo.Products;




/*
SQL SERVER DATA ANALYST PRACTICE LIBRARY — ROUND 10 (QUERIES 01–100)
===================================================================

Dialect: Microsoft SQL Server (T-SQL)
Description: Round 10 (Final Round) iteration featuring fully seeded tables, 
DATETIME timestamps, shifted date baselines (2033/2034), updated numerical 
thresholds, and clean syntax to complete your 1,000-query mastery project.
*/

CREATE DATABASE SQLMastery_Round10;
GO
USE SQLMastery_Round10;
GO

-- ============================================================================
-- SETUP BLOCK: MOCK SCHEMA & SEED DATA
-- ============================================================================
CREATE TABLE dbo.Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE dbo.Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeName VARCHAR(100),
    DepartmentID INT FOREIGN KEY REFERENCES dbo.Departments(DepartmentID),
    Salary DECIMAL(18,2),
    HireDate DATE
);

CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50),
    Region VARCHAR(50)
);

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES dbo.Customers(CustomerID),
    OrderDate DATETIME,
    ShipDate DATETIME,
    Status VARCHAR(50),
    TotalAmount DECIMAL(18,2)
);

CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(18,2),
    CostPrice DECIMAL(18,2),
    OriginalPrice DECIMAL(18,2),
    StockQuantity INT,
    ReorderLevel INT
);

CREATE TABLE dbo.OrderItems (
    OrderID INT FOREIGN KEY REFERENCES dbo.Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES dbo.Products(ProductID),
    Quantity INT,
    UnitPrice DECIMAL(18,2)
);

-- Seed Data (Round 10 Final Values)
INSERT INTO dbo.Departments VALUES 
(1300, 'Enterprise Solutions'), 
(1400, 'Artificial Intelligence'), 
(1500, 'Global Partnerships'), 
(1600, 'Operations Strategy');

INSERT INTO dbo.Employees (EmployeeName, DepartmentID, Salary, HireDate) VALUES 
('Hassan Farahat', 1300, 175000.00, '2023-01-15'),
('Salma Hafez', 1400, 145000.00, '2023-07-20'),
('Omar Sherif', 1500, 110000.00, '2024-03-10'),
('Nourhan Tarek', 1600, 125000.00, '2025-05-18');

INSERT INTO dbo.Customers VALUES 
(6001, 'Apex Global', 'contact@apexglobal.io', 'Singapore', 'APAC'),
(6002, 'Vanguard Tech', NULL, 'London', 'Europe'),
(6003, 'Summit Logistics', 'ops@summitlog.net', 'New York', 'North America'),
(6004, 'Titan Solutions', 'info@titansolutions.org', 'Singapore', 'APAC');

INSERT INTO dbo.Products VALUES 
(901, 'Exascale Server Node', 'Hardware', 9000.00, 7000.00, 9500.00, 4, 10),
(902, 'Cognitive Analytics Suite', 'Software', 3500.00, 1200.00, 3800.00, 40, 15),
(903, 'Autonomous Cyber Defense', 'Services', 5500.00, 2200.00, 6000.00, 8, 4),
(904, 'Ultra-High Core Router', 'Hardware', 4500.00, 3400.00, 4800.00, 20, 10);

INSERT INTO dbo.Orders VALUES 
(60001, 6001, '2033-01-10 08:30:00', '2033-01-12 14:00:00', 'Completed', 12500.00),
(60002, 6002, '2033-04-15 10:15:00', '2033-04-20 16:45:00', 'Completed', 3500.00),
(60003, 6001, '2033-06-22 13:20:00', '2033-06-25 11:00:00', 'Shipped', 5500.00),
(60004, 6003, '2033-09-05 15:50:00', NULL, 'Pending', 9000.00),
(60005, 6004, '2033-11-12 09:10:00', '2033-11-15 12:30:00', 'Completed', 8000.00);

INSERT INTO dbo.OrderItems VALUES 
(60001, 901, 1, 9000.00),
(60001, 902, 1, 3500.00),
(60002, 902, 1, 3500.00),
(60003, 903, 1, 5500.00),
(60004, 901, 1, 9000.00),
(60005, 902, 1, 3500.00),
(60005, 904, 1, 4500.00);
GO


/* 01. Filter rows with WHERE */
SELECT OrderID, CustomerID, OrderDate, Status
FROM dbo.Orders
WHERE Status = 'Completed';


/* 02. Sort results */
SELECT ProductID, ProductName, Price
FROM dbo.Products
ORDER BY Price DESC;


/* 03. Return the top 10 records */
SELECT TOP (10) OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
ORDER BY TotalAmount DESC;


/* 04. Find distinct categories */
SELECT DISTINCT Category
FROM dbo.Products
ORDER BY Category;


/* 05. Count all rows vs non-NULL values */
SELECT COUNT(*) AS TotalRows,
       COUNT(Email) AS RowsWithEmail
FROM dbo.Customers;


/* 06. Find NULL values */
SELECT CustomerID, CustomerName, Email
FROM dbo.Customers
WHERE Email IS NULL;


/* 07. Use CASE to classify values */
SELECT ProductID, ProductName, Price,
       CASE WHEN Price >= 7000 THEN 'High'
            WHEN Price >= 4000 THEN 'Medium'
            ELSE 'Low' END AS PriceBand
FROM dbo.Products;


/* 08. Aggregate with GROUP BY */
SELECT Status, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY Status;


/* 09. Filter groups with HAVING */
SELECT CustomerID, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(*) >= 2;


/* 10. Calculate average salary */
SELECT AVG(CAST(Salary AS DECIMAL(18,2))) AS AverageSalary
FROM dbo.Employees;


/* 11. INNER JOIN two tables */
SELECT o.OrderID, c.CustomerName, o.OrderDate
FROM dbo.Orders AS o
INNER JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID;


/* 12. LEFT JOIN to keep unmatched customers */
SELECT c.CustomerID, c.CustomerName, o.OrderID
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID;


/* 13. Find customers with no orders */
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;


/* 14. Find products never ordered */
SELECT p.ProductID, p.ProductName
FROM dbo.Products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.OrderItems AS oi
    WHERE oi.ProductID = p.ProductID
);


/* 15. Join three tables */
SELECT o.OrderID, c.CustomerName, p.ProductName, oi.Quantity
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID;


/* 16. UNION vs UNION ALL pattern */
SELECT City FROM dbo.Customers
UNION
SELECT Region FROM dbo.Customers;


/* 17. Find duplicate emails */
SELECT Email, COUNT(*) AS DuplicateCount
FROM dbo.Customers
WHERE Email IS NOT NULL
GROUP BY Email
HAVING COUNT(*) > 1;


/* 18. Find the second-highest distinct salary */
WITH SalaryRanks AS (
    SELECT Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM dbo.Employees
    WHERE Salary IS NOT NULL
)
SELECT DISTINCT Salary
FROM SalaryRanks
WHERE SalaryRank = 2;


/* 19. Find the Nth-highest salary (change @N) */
DECLARE @N INT = 2;
WITH SalaryRanks AS (
    SELECT EmployeeID, EmployeeName, Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM dbo.Employees
    WHERE Salary IS NOT NULL
)
SELECT EmployeeID, EmployeeName, Salary
FROM SalaryRanks
WHERE SalaryRank = @N;


/* 20. Rank employees within each department */
SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
       RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
FROM dbo.Employees;


/* 21. Top 3 employees per department */
WITH RankedEmployees AS (
    SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
           ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC, EmployeeID) AS rn
    FROM dbo.Employees
)
SELECT EmployeeID, EmployeeName, DepartmentID, Salary
FROM RankedEmployees
WHERE rn <= 3;


/* 22. Compare ROW_NUMBER, RANK, DENSE_RANK */
SELECT EmployeeID, EmployeeName, Salary,
       ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNum,
       RANK() OVER (ORDER BY Salary DESC) AS SalaryRank,
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseSalaryRank
FROM dbo.Employees;


/* 23. Find employees paid above company average */
SELECT EmployeeID, EmployeeName, Salary
FROM dbo.Employees
WHERE Salary > (SELECT AVG(CAST(Salary AS DECIMAL(18,2))) FROM dbo.Employees);


/* 24. Find employees paid above their department average */
WITH DepartmentAverages AS (
    SELECT DepartmentID, AVG(CAST(Salary AS DECIMAL(18,2))) AS AvgSalary
    FROM dbo.Employees
    GROUP BY DepartmentID
)
SELECT e.EmployeeID, e.EmployeeName, e.DepartmentID, e.Salary
FROM dbo.Employees AS e
JOIN DepartmentAverages AS d ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > d.AvgSalary;


/* 25. Use a CTE to calculate order totals */
WITH OrderTotals AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS CalculatedTotal
    FROM dbo.OrderItems
    GROUP BY OrderID
)
SELECT OrderID, CalculatedTotal
FROM OrderTotals
ORDER BY CalculatedTotal DESC;


/* 26. Use EXISTS to find customers with orders */
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
WHERE EXISTS (
    SELECT 1 FROM dbo.Orders AS o
    WHERE o.CustomerID = c.CustomerID
);


/* 27. Find the latest order for each customer */
WITH RankedOrders AS (
    SELECT OrderID, CustomerID, OrderDate,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC) AS rn
    FROM dbo.Orders
)
SELECT OrderID, CustomerID, OrderDate
FROM RankedOrders
WHERE rn = 1;


/* 28. Find each customer's first order */
SELECT CustomerID, MIN(OrderDate) AS FirstOrderDate
FROM dbo.Orders
GROUP BY CustomerID;


/* 29. Calculate a running sales total */
WITH DailySales AS (
    SELECT CAST(OrderDate AS DATE) AS OrderDay, SUM(TotalAmount) AS Sales
    FROM dbo.Orders
    GROUP BY CAST(OrderDate AS DATE)
)
SELECT OrderDay, Sales,
       SUM(Sales) OVER (ORDER BY OrderDay ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningSales
FROM DailySales
ORDER BY OrderDay;


/* 30. Compare each month with the previous month */
WITH MonthlySales AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
SalesComparison AS (
    SELECT SalesMonth, Revenue,
           LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue
    FROM MonthlySales
)
SELECT SalesMonth, Revenue, PreviousMonthRevenue,
       (Revenue - PreviousMonthRevenue) * 100.0 / NULLIF(PreviousMonthRevenue, 0) AS MoMPercentChange
FROM SalesComparison
ORDER BY SalesMonth;


/* 31. Calculate each category's share of revenue */
WITH CategorySales AS (
    SELECT p.Category, SUM(oi.Quantity * oi.UnitPrice) AS Revenue
    FROM dbo.OrderItems AS oi
    JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
    GROUP BY p.Category
)
SELECT Category, Revenue,
       Revenue * 100.0 / NULLIF(SUM(Revenue) OVER (), 0) AS RevenueSharePercent
FROM CategorySales
ORDER BY Revenue DESC;


/* 32. Find customers above average order value */
WITH CustomerSpend AS (
    SELECT CustomerID, AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AvgOrderValue
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT CustomerID, AvgOrderValue
FROM CustomerSpend
WHERE AvgOrderValue > (SELECT AVG(CAST(TotalAmount AS DECIMAL(18,2))) FROM dbo.Orders);


/* 33. Find consecutive orders using LAG */
WITH OrderHistory AS (
    SELECT CustomerID, OrderID, OrderDate,
           LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate, OrderID) AS PreviousOrderDate
    FROM dbo.Orders
)
SELECT CustomerID, OrderID, OrderDate, PreviousOrderDate,
       DATEDIFF(DAY, PreviousOrderDate, OrderDate) AS DaysSincePreviousOrder
FROM OrderHistory;


/* 34. Calculate a 3-row moving average of daily sales */
WITH DailySales AS (
    SELECT CAST(OrderDate AS DATE) AS OrderDay, SUM(TotalAmount) AS Sales
    FROM dbo.Orders
    GROUP BY CAST(OrderDate AS DATE)
)
SELECT OrderDay, Sales,
       AVG(CAST(Sales AS DECIMAL(18,2))) OVER (
           ORDER BY OrderDay ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS MovingAverage3Rows
FROM DailySales
ORDER BY OrderDay;


/* 35. Find duplicate rows by business key and keep latest */
WITH Duplicates AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC
    ) AS rn
    FROM dbo.Orders
)
SELECT *
FROM Duplicates
WHERE rn = 1;


/* 36. Pivot order counts by status */
SELECT CustomerID,
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedOrders,
       SUM(CASE WHEN Status = 'Shipped' THEN 1 ELSE 0 END) AS ShippedOrders,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS PendingOrders
FROM dbo.Orders
GROUP BY CustomerID;


/* 37. Find the most expensive product in each category */
WITH RankedProducts AS (
    SELECT ProductID, ProductName, Category, Price,
           DENSE_RANK() OVER (PARTITION BY Category ORDER BY Price DESC) AS rn
    FROM dbo.Products
)
SELECT ProductID, ProductName, Category, Price
FROM RankedProducts
WHERE rn = 1;


/* 38. Find customers who ordered in one year but not another (Shifted to 2033/2034) */
SELECT DISTINCT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2033-01-01' AND OrderDate < '2034-01-01'
EXCEPT
SELECT DISTINCT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2034-01-01' AND OrderDate < '2035-01-01';


/* 39. Calculate order value including line items */
SELECT o.OrderID, o.CustomerID, o.OrderDate,
       SUM(oi.Quantity * oi.UnitPrice) AS CalculatedOrderValue
FROM dbo.Orders AS o
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
GROUP BY o.OrderID, o.CustomerID, o.OrderDate;


/* 40. Find orders where stored total differs from line total */
WITH LineTotals AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS LineTotal
    FROM dbo.OrderItems
    GROUP BY OrderID
)
SELECT o.OrderID, o.TotalAmount, l.LineTotal,
       o.TotalAmount - l.LineTotal AS Difference
FROM dbo.Orders AS o
JOIN LineTotals AS l ON l.OrderID = o.OrderID
WHERE ABS(o.TotalAmount - l.LineTotal) > 0.01;


/* 41. Calculate percentage of employees in each department */
SELECT DepartmentID, COUNT(*) AS EmployeeCount,
       COUNT(*) * 100.0 / NULLIF(SUM(COUNT(*)) OVER (), 0) AS PercentOfEmployees
FROM dbo.Employees
GROUP BY DepartmentID;


/* 42. Find employees hired in the last 12 months */
SELECT EmployeeID, EmployeeName, HireDate
FROM dbo.Employees
WHERE HireDate >= DATEADD(MONTH, -12, CAST(GETDATE() AS DATE))
  AND HireDate < DATEADD(DAY, 1, CAST(GETDATE() AS DATE));


/* 43. Calculate days between order and shipment */
SELECT OrderID, OrderDate, ShipDate,
       DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Orders
WHERE ShipDate IS NOT NULL;


/* 44. Find the median salary */
SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary)
       OVER () AS MedianSalary
FROM dbo.Employees
WHERE Salary IS NOT NULL;


/* 45. Identify outlier prices using IQR */
WITH Quartiles AS (
    SELECT DISTINCT
           PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Price) OVER () AS Q1,
           PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Price) OVER () AS Q3
    FROM dbo.Products
    WHERE Price IS NOT NULL
)
SELECT p.ProductID, p.ProductName, p.Price, q.Q1, q.Q3
FROM dbo.Products AS p
CROSS JOIN Quartiles AS q
WHERE p.Price < q.Q1 - 1.5 * (q.Q3 - q.Q1)
   OR p.Price > q.Q3 + 1.5 * (q.Q3 - q.Q1);


/* 46. Find missing dates in the order activity calendar */
WITH OrderDays AS (
    SELECT DISTINCT CAST(OrderDate AS DATE) AS OrderDay
    FROM dbo.Orders
),
DateRange AS (
    SELECT MIN(OrderDay) AS StartDay, MAX(OrderDay) AS EndDay
    FROM OrderDays
),
Calendar AS (
    SELECT StartDay AS CalendarDay, EndDay
    FROM DateRange
    UNION ALL
    SELECT DATEADD(DAY, 1, CalendarDay), EndDay
    FROM Calendar
    WHERE CalendarDay < EndDay
)
SELECT c.CalendarDay
FROM Calendar AS c
LEFT JOIN OrderDays AS o ON o.OrderDay = c.CalendarDay
WHERE o.OrderDay IS NULL
OPTION (MAXRECURSION 0);


/* 47. Find customers with orders in at least 3 distinct months */
SELECT CustomerID, COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) AS ActiveMonths
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(DISTINCT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) >= 3;


/* 48. Calculate customer repeat-purchase rate */
WITH CustomerOrders AS (
    SELECT CustomerID, COUNT(*) AS OrderCount
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT COUNT(CASE WHEN OrderCount >= 2 THEN 1 END) AS RepeatCustomers,
       COUNT(*) AS CustomersWithOrders,
       COUNT(CASE WHEN OrderCount >= 2 THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS RepeatPurchaseRatePercent
FROM CustomerOrders;


/* 49. Calculate customer retention by first-order cohort and next month */
WITH FirstOrder AS (
    SELECT CustomerID, MIN(DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)) AS CohortMonth
    FROM dbo.Orders
    GROUP BY CustomerID
),
CustomerActivity AS (
    SELECT DISTINCT CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS ActivityMonth
    FROM dbo.Orders
)
SELECT f.CohortMonth,
       COUNT(DISTINCT f.CustomerID) AS CohortCustomers,
       COUNT(DISTINCT CASE WHEN a.ActivityMonth = DATEADD(MONTH, 1, f.CohortMonth) THEN f.CustomerID END) AS RetainedNextMonth,
       COUNT(DISTINCT CASE WHEN a.ActivityMonth = DATEADD(MONTH, 1, f.CohortMonth) THEN f.CustomerID END) * 100.0
           / NULLIF(COUNT(DISTINCT f.CustomerID), 0) AS NextMonthRetentionPercent
FROM FirstOrder AS f
LEFT JOIN CustomerActivity AS a ON a.CustomerID = f.CustomerID
GROUP BY f.CohortMonth
ORDER BY f.CohortMonth;


/* 50. Inspect query execution plan and IO/time (Shifted to 2033) */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT CustomerID, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
WHERE OrderDate >= '2033-01-01' AND OrderDate < '2034-01-01'
GROUP BY CustomerID;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;


/* 51. Daily sales summary */
SELECT CAST(OrderDate AS DATE) AS OrderDay,
       COUNT(*) AS OrderCount,
       SUM(TotalAmount) AS Revenue,
       AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AverageOrderValue
FROM dbo.Orders
WHERE OrderDate >= DATEADD(DAY, -30, CAST(GETDATE() AS DATE))
GROUP BY CAST(OrderDate AS DATE)
ORDER BY OrderDay;


/* 52. Sales by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 53. Sales by region */
SELECT c.Region, COUNT(o.OrderID) AS OrderCount, SUM(o.TotalAmount) AS Revenue
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
GROUP BY c.Region
ORDER BY Revenue DESC;


/* 54. Sales by product category */
SELECT p.Category, SUM(oi.Quantity) AS UnitsSold,
       SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM dbo.OrderItems AS oi
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
GROUP BY p.Category
ORDER BY Revenue DESC;


/* 55. Top 10 customers by lifetime revenue */
SELECT TOP (10) c.CustomerID, c.CustomerName,
       SUM(o.TotalAmount) AS LifetimeRevenue
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY LifetimeRevenue DESC;


/* 56. Top 10 products by units sold */
SELECT TOP (10) p.ProductID, p.ProductName,
       SUM(oi.Quantity) AS UnitsSold
FROM dbo.OrderItems AS oi
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY UnitsSold DESC;


/* 57. Revenue by order status */
SELECT Status, COUNT(*) AS OrderCount, SUM(TotalAmount) AS TotalAmount
FROM dbo.Orders
GROUP BY Status
ORDER BY TotalAmount DESC;


/* 58. Cancellation rate */
SELECT COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) AS CancelledOrders,
       COUNT(*) AS TotalOrders,
       COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS CancellationRatePercent
FROM dbo.Orders;


/* 59. Average order value by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       AVG(CAST(TotalAmount AS DECIMAL(18,2))) AS AverageOrderValue
FROM dbo.Orders
WHERE TotalAmount IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 60. Customers who have not ordered in 90 days */
SELECT c.CustomerID, c.CustomerName, MAX(o.OrderDate) AS LastOrderDate
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING MAX(o.OrderDate) IS NULL
    OR MAX(o.OrderDate) < DATEADD(DAY, -90, GETDATE());


/* 61. Customers who ordered this month */
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderDate >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
  AND o.OrderDate < DATEADD(MONTH, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1));


/* 62. Orders above the overall average order value */
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE TotalAmount > (SELECT AVG(CAST(TotalAmount AS DECIMAL(18,2))) FROM dbo.Orders);


/* 63. Daily order count by status */
SELECT CAST(OrderDate AS DATE) AS OrderDay,
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS Completed,
       SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled,
       SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS Pending
FROM dbo.Orders
GROUP BY CAST(OrderDate AS DATE)
ORDER BY OrderDay;


/* 64. Check duplicate customer records */
SELECT CustomerName, Email, COUNT(*) AS RecordCount
FROM dbo.Customers
GROUP BY CustomerName, Email
HAVING COUNT(*) > 1;


/* 65. Check duplicate order IDs */
SELECT OrderID, COUNT(*) AS RecordCount
FROM dbo.Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;


/* 66. Check missing required values */
SELECT
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS MissingOrderDate,
    SUM(CASE WHEN TotalAmount IS NULL THEN 1 ELSE 0 END) AS MissingTotalAmount
FROM dbo.Orders;


/* 67. Find negative or zero order amounts */
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE TotalAmount <= 0;


/* 68. Find negative prices or quantities */
SELECT OrderID, ProductID, Quantity, UnitPrice
FROM dbo.OrderItems
WHERE Quantity <= 0 OR UnitPrice < 0;


/* 69. Find orders with no matching customer */
SELECT o.*
FROM dbo.Orders AS o
LEFT JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL;


/* 70. Find order items with no matching product */
SELECT oi.*
FROM dbo.OrderItems AS oi
LEFT JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
WHERE p.ProductID IS NULL;


/* 71. Standardize text for review (trim and lowercase) */
SELECT CustomerID, CustomerName, Email,
       LOWER(LTRIM(RTRIM(Email))) AS StandardizedEmail
FROM dbo.Customers;


/* 72. Find leading/trailing spaces in customer names */
SELECT CustomerID, CustomerName
FROM dbo.Customers
WHERE CustomerName <> LTRIM(RTRIM(CustomerName));


/* 73. Count distinct customers per month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       COUNT(DISTINCT CustomerID) AS ActiveCustomers
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY SalesMonth;


/* 74. Compare current month and previous month revenue */
WITH MonthlyRevenue AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
)
SELECT SalesMonth, Revenue,
       LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue,
       Revenue - LAG(Revenue) OVER (ORDER BY SalesMonth) AS RevenueChange
FROM MonthlyRevenue
ORDER BY SalesMonth;


/* 75. Year-over-year revenue comparison */
WITH YearlyRevenue AS (
    SELECT YEAR(OrderDate) AS SalesYear, SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY YEAR(OrderDate)
)
SELECT SalesYear, Revenue,
       LAG(Revenue) OVER (ORDER BY SalesYear) AS PreviousYearRevenue,
       (Revenue - LAG(Revenue) OVER (ORDER BY SalesYear)) * 100.0
           / NULLIF(LAG(Revenue) OVER (ORDER BY SalesYear), 0) AS YoYPercentChange
FROM YearlyRevenue
ORDER BY SalesYear;


/* 76. Revenue by weekday */
SELECT DATENAME(WEEKDAY, OrderDate) AS WeekdayName,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATENAME(WEEKDAY, OrderDate), DATEPART(WEEKDAY, OrderDate)
ORDER BY DATEPART(WEEKDAY, OrderDate);


/* 77. Revenue by hour of day */
SELECT DATEPART(HOUR, OrderDate) AS OrderHour,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEPART(HOUR, OrderDate)
ORDER BY OrderHour;


/* 78. Average shipping time by month */
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS OrderMonth,
       AVG(CAST(DATEDIFF(DAY, OrderDate, ShipDate) AS DECIMAL(10,2))) AS AvgDaysToShip
FROM dbo.Orders
WHERE ShipDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
ORDER BY OrderMonth;


/* 79. Late shipments */
SELECT OrderID, OrderDate, ShipDate,
       DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Orders
WHERE ShipDate > DATEADD(DAY, 3, OrderDate);


/* 80. Products below reorder level */
SELECT ProductID, ProductName, StockQuantity, ReorderLevel
FROM dbo.Products
WHERE StockQuantity <= ReorderLevel;


/* 81. Inventory value by category */
SELECT Category,
       SUM(CAST(StockQuantity AS DECIMAL(18,2)) * Price) AS InventoryValue
FROM dbo.Products
GROUP BY Category
ORDER BY InventoryValue DESC;


/* 82. Calculate gross margin per product */
SELECT ProductID, ProductName, Price, CostPrice,
       Price - CostPrice AS GrossProfitPerUnit,
       (Price - CostPrice) * 100.0 / NULLIF(Price, 0) AS GrossMarginPercent
FROM dbo.Products
WHERE Price IS NOT NULL AND CostPrice IS NOT NULL;


/* 83. Discount analysis */
SELECT ProductID, ProductName, OriginalPrice, Price,
       OriginalPrice - Price AS DiscountAmount,
       (OriginalPrice - Price) * 100.0 / NULLIF(OriginalPrice, 0) AS DiscountPercent
FROM dbo.Products
WHERE OriginalPrice > 0 AND Price IS NOT NULL;


/* 84. Average salary by department */
SELECT d.DepartmentName,
       AVG(CAST(e.Salary AS DECIMAL(18,2))) AS AverageSalary,
       MIN(e.Salary) AS MinimumSalary,
       MAX(e.Salary) AS MaximumSalary,
       COUNT(*) AS EmployeeCount
FROM dbo.Employees AS e
JOIN dbo.Departments AS d ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY AverageSalary DESC;


/* 85. Headcount by department */
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS Headcount
FROM dbo.Departments AS d
LEFT JOIN dbo.Employees AS e ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY Headcount DESC;


/* 86. Employees missing a department match */
SELECT e.EmployeeID, e.EmployeeName, e.DepartmentID
FROM dbo.Employees AS e
LEFT JOIN dbo.Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentID IS NULL;


/* 87. New hires by month */
SELECT DATEFROMPARTS(YEAR(HireDate), MONTH(HireDate), 1) AS HireMonth,
       COUNT(*) AS NewHires
FROM dbo.Employees
WHERE HireDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(HireDate), MONTH(HireDate), 1)
ORDER BY HireMonth;


/* 88. Employee salary compared with department average */
SELECT EmployeeID, EmployeeName, DepartmentID, Salary,
       AVG(CAST(Salary AS DECIMAL(18,2))) OVER (PARTITION BY DepartmentID) AS DepartmentAverage
FROM dbo.Employees;


/* 89. Find customers with multiple orders on the same day */
SELECT CustomerID, CAST(OrderDate AS DATE) AS OrderDay, COUNT(*) AS OrdersThatDay
FROM dbo.Orders
GROUP BY CustomerID, CAST(OrderDate AS DATE)
HAVING COUNT(*) > 1;


/* 90. Calculate order-item contribution to order total */
WITH LineValues AS (
    SELECT OrderID, ProductID, Quantity * UnitPrice AS LineValue
    FROM dbo.OrderItems
),
OrderValues AS (
    SELECT OrderID, SUM(LineValue) AS OrderValue
    FROM LineValues
    GROUP BY OrderID
)
SELECT l.OrderID, l.ProductID, l.LineValue, o.OrderValue,
       l.LineValue * 100.0 / NULLIF(o.OrderValue, 0) AS PercentOfOrder
FROM LineValues AS l
JOIN OrderValues AS o ON o.OrderID = l.OrderID;


/* 91. Identify customers whose spending declined month over month */
WITH CustomerMonthlySpend AS (
    SELECT CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
           SUM(TotalAmount) AS MonthlySpend
    FROM dbo.Orders
    GROUP BY CustomerID, DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
),
SpendComparison AS (
    SELECT CustomerID, SalesMonth, MonthlySpend,
           LAG(MonthlySpend) OVER (PARTITION BY CustomerID ORDER BY SalesMonth) AS PreviousMonthSpend
    FROM CustomerMonthlySpend
)
SELECT CustomerID, SalesMonth, MonthlySpend, PreviousMonthSpend
FROM SpendComparison
WHERE PreviousMonthSpend IS NOT NULL AND MonthlySpend < PreviousMonthSpend;


/* 92. Segment customers by lifetime spending */
WITH CustomerSpend AS (
    SELECT c.CustomerID, c.CustomerName, COALESCE(SUM(o.TotalAmount), 0) AS LifetimeSpend
    FROM dbo.Customers AS c
    LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT *, CASE WHEN LifetimeSpend >= 10000 THEN 'High Value'
               WHEN LifetimeSpend >= 2500 THEN 'Medium Value'
               ELSE 'Low Value' END AS CustomerSegment
FROM CustomerSpend;


/* 93. Calculate RFM-style recency, frequency, monetary value */
SELECT c.CustomerID, c.CustomerName,
       MAX(o.OrderDate) AS LastOrderDate,
       DATEDIFF(DAY, MAX(o.OrderDate), CAST(GETDATE() AS DATE)) AS RecencyDays,
       COUNT(o.OrderID) AS Frequency,
       COALESCE(SUM(o.TotalAmount), 0) AS MonetaryValue
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName;


/* 94. Find customers with a high-value recent order */
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.TotalAmount >= 1000
  AND o.OrderDate >= DATEADD(DAY, -30, GETDATE());


/* 95. Weekly sales summary */
SELECT DATEADD(DAY, 1 - DATEPART(WEEKDAY, CAST(OrderDate AS DATE)), CAST(OrderDate AS DATE)) AS WeekStart,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY DATEADD(DAY, 1 - DATEPART(WEEKDAY, CAST(OrderDate AS DATE)), CAST(OrderDate AS DATE))
ORDER BY WeekStart;


/* 96. Build a reusable filtered dataset with a CTE */
WITH RecentCompletedOrders AS (
    SELECT OrderID, CustomerID, OrderDate, TotalAmount
    FROM dbo.Orders
    WHERE Status = 'Completed'
      AND OrderDate >= DATEADD(MONTH, -3, GETDATE())
)
SELECT CustomerID, COUNT(*) AS CompletedOrders, SUM(TotalAmount) AS Revenue
FROM RecentCompletedOrders
GROUP BY CustomerID
ORDER BY Revenue DESC;


/* 97. Create a temporary table for repeated analysis */
DROP TABLE IF EXISTS #MonthlySales;

SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS SalesMonth,
       SUM(TotalAmount) AS Revenue
INTO #MonthlySales
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1);

SELECT SalesMonth, Revenue
FROM #MonthlySales
ORDER BY SalesMonth;


/* 98. Add a nonclustered index for a common filter */
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate
ON dbo.Orders (OrderDate)
INCLUDE (CustomerID, Status, TotalAmount);


/* 99. Safely test a data update inside a transaction */
BEGIN TRANSACTION;

UPDATE dbo.Products
SET Price = Price * 1.05
WHERE Category = 'Hardware';

-- Check affected rows and values before deciding:
SELECT ProductID, ProductName, Category, Price
FROM dbo.Products
WHERE Category = 'Hardware';

-- Run ONE of these after reviewing the result:
-- COMMIT TRANSACTION;
-- ROLLBACK TRANSACTION;


/* 100. Produce a compact data-quality summary for core tables */
SELECT 'Departments' AS TableName, COUNT(*) AS "RowCount" FROM dbo.Departments
UNION ALL
SELECT 'Employees', COUNT(*) FROM dbo.Employees
UNION ALL
SELECT 'Customers', COUNT(*) FROM dbo.Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM dbo.Orders
UNION ALL
SELECT 'OrderItems', COUNT(*) FROM dbo.OrderItems
UNION ALL
SELECT 'Products', COUNT(*) FROM dbo.Products;