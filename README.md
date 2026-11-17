<p align="center">
  <strong>End-to-End SQL Business Analysis Project</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/SQL-PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/Database-Management-blue?style=for-the-badge" alt="Database Management">
  <img src="https://img.shields.io/badge/Business-Analytics-orange?style=for-the-badge" alt="Business Analytics">
  <img src="https://img.shields.io/badge/Project-Portfolio-green?style=for-the-badge" alt="Portfolio Project">
</p>

📌 01. Project Overview
This project focuses on analyzing pizza sales data using PostgreSQL and SQL to uncover meaningful business insights.

The analysis explores sales performance, product popularity, revenue contribution, ordering trends, pricing, and discount patterns.

A total of 32 selected business questions were addressed using SQL techniques ranging from basic queries to advanced concepts such as Common Table Expressions (CTEs), correlated subqueries, and window functions.

The objective is to demonstrate how structured transactional data can be transformed into meaningful information to support business analysis and decision-making.

🎯 02. Business Objectives
The analysis focuses on answering important business questions related to pizza sales.

📈 Sales Performance
- Evaluate overall sales performance and revenue.
- Calculate total orders and quantities sold.
- Understand average order value.
🍕 Product Performance
- Identify the best-selling pizza varieties.
- Find products generating the highest revenue.
- Compare sales across pizza categories and sizes.
⏰ Time-Based Analysis
- Examine monthly sales trends.
- Compare weekday sales performance.
- Analyze hourly ordering patterns.
💰 Financial Analysis
- Examine product prices and costs.
- Understand discount structures.
- Analyze revenue contribution and profitability-related metrics.

🗄️ 03. Database Architecture & Schema
The project uses a relational database developed in PostgreSQL, consisting of five interconnected tables. Each table manages a specific part of the business data.
📦 Database Structure at a Glance
🍕 Product Catalogue — pizza_types

Maintains information about pizza varieties.

pizza_type_id · name · category · ingredients

💰 Product Pricing — pizzas

Stores pizza variants, available sizes, selling prices, and product costs.

pizza_id · pizza_type_id · size · price · cost

📅 Order Management — orders

Maintains order-level information and timestamps.

order_id · order_date · order_time

🧾 Sales Transactions — order_details

Records the individual pizza items included in customer orders.

order_details_id · order_id · pizza_id · quantity · discount_id

🏷️ Discount Management — discount_structure

Maintains discount names and their corresponding percentages.

discount_id · discount_name · discount_percentage
🔗 Database Relationship Flow
The five tables are connected through common identifiers:
                 pizza_types
                      |
                 pizza_type_id
                      |
                    pizzas
                      |
                   pizza_id
                      |
                 order_details
                   /       \
             order_id    discount_id
                /             \
             orders      discount_structure
💡 Business Relevance
This relational structure allows information from different tables to be combined using SQL JOIN operations.

It supports product performance analysis, revenue calculations, order trend analysis, and discount-related analysis.

📊 04. Dataset Overview
The project uses a Pizza Sales practice dataset containing product, pricing, order, transaction, and discount information.
Dataset Composition
🍕 Product Information
- 10 Pizza Types
- 24 Pizza Variants
📦 Transaction Information
- 500 Orders
- 1,500 Order Details
🏷️ Discount Information
- 4 Discount Structures
These records form the foundation for the SQL queries and business analysis performed throughout the project.

🛠️ 05. Tools & Technologies
🐘 PostgreSQL

Used for relational database creation, data storage, querying, and business analysis.

🖥️ pgAdmin

Used for database management and executing SQL queries.

💻 SQL

Used for data exploration, joining tables, aggregations, analytical calculations, and solving business questions.

📊 Microsoft Excel

Used for organizing and reviewing the SQL query results.

🐙 GitHub

Used for project documentation, version control, and portfolio presentation.

💻 06. SQL Skills & Concepts Applied
The project covers SQL concepts from fundamental querying to advanced analytical techniques.
🟢 Fundamental SQL
- SELECT, FROM, WHERE
- DISTINCT, ORDER BY, LIMIT
- GROUP BY and HAVING
- Aggregate Functions: SUM, COUNT, AVG, MIN, MAX
🟡 Intermediate SQL
- INNER JOIN and LEFT JOIN
- Subqueries
- CASE Statements
- UNION ALL
- Date and Time Functions
🔴 Advanced SQL
- Common Table Expressions (CTEs)
- Correlated Subqueries
- Window Functions
- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- PARTITION BY
- LAG()
- Running Totals
- Percentage Contribution
- EXISTS
- CREATE VIEW

🔎 07. Business Questions & Analysis Areas
A total of 32 selected SQL business questions were addressed across multiple analytical areas.
📈 Sales Performance Analysis
- Total orders
- Total pizzas sold
- Gross revenue
- Average order value
🍕 Product Performance Analysis
- Top-selling pizza varieties
- Highest-revenue pizza types
- Above-average pizza prices
📊 Category & Size Analysis
- Revenue by pizza category
- Quantity sold by pizza size
- Product-level sales comparisons
⏰ Time-Based Analysis
- Monthly revenue trends
- Weekday revenue analysis
- Hourly order distribution
💰 Revenue & Financial Analysis
- Revenue contribution
- Running revenue totals
- Discount-related calculations
- Product cost and pricing analysis
🧠 Advanced SQL Analysis
- Ranking and dense ranking
- CTE-based analysis
- Correlated subqueries
- Window functions
- Existence checks
- Reusable SQL views

📁 08. Project Files & Repository Structure
The repository is organized to keep the original dataset, SQL queries, and analytical outputs accessible.
Pizza-Sales-SQL-Analysis/
│
├── Dataset/
│   └── Pizza_Sales_Practice_Dataset.xlsx
│
├── SQL_Results/
│   └── Pizza_Sales_32_Approved_SQL_Answers.xlsx
│
├── Pizza_Sales_Approved_SQL_Queries.sql
│
└── README.md
📂 What's Included?
1. Dataset

Pizza_Sales_Practice_Dataset.xlsx

Contains the original practice dataset used for the analysis.

2. SQL Query Script

Pizza_Sales_Approved_SQL_Queries.sql

Contains the SQL solutions for the 32 selected business questions.

3. SQL Results

Pizza_Sales_32_Approved_SQL_Answers.xlsx

Contains the consolidated Excel workbook with the corresponding query results.

4. Project Documentation

README.md

Provides an overview of the project, database structure, analytical objectives, SQL concepts, and workflow.

🔄 09. Project Workflow
The project was completed through the following stages:

STEP 01 — Database Creation

Created the PostgreSQL database and established the required relational tables.

STEP 02 — Data Preparation

Structured and populated the database with product, order, transaction, and discount information.

STEP 03 — Data Exploration

Performed initial exploration using basic SQL queries and aggregate functions.

STEP 04 — Business Problem Solving

Developed SQL queries to answer practical questions related to sales, products, revenue, and ordering trends.

STEP 05 — Advanced SQL Analysis

Applied JOINs, CTEs, subqueries, correlated queries, and window functions.

STEP 06 — Results Organization

Collected and organized the query outputs in Microsoft Excel.

STEP 07 — Project Documentation

Prepared the SQL script, consolidated results, and GitHub documentation.

💡 10. Key Learning Outcomes
Through this project, I gained practical experience in:
- Designing and working with relational databases.
- Writing SQL queries to solve business-oriented problems.
- Combining multiple tables using JOIN operations.
- Performing data aggregation and analytical calculations.
- Applying advanced SQL concepts and window functions.
- Analyzing product and sales performance.
- Organizing query outputs and documenting analytical work.
The project strengthened my SQL knowledge and helped me understand how database querying can support business analysis.

👩‍💻 11. About the Author
Devika Sutar

Aspiring Data Analyst | SQL | Microsoft Excel | Python | Power BI

Interested in transforming data into meaningful business insights through analytical thinking, structured problem-solving, and data-driven decision-making.

🔗 GitHub: devika72-95

🔗 LinkedIn: Devika Sutar

<p align="center">
  <strong>Thank you for exploring my Pizza Sales SQL Analysis project! 🍕</strong>
</p>
