CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- Revenue Summary by Membership Tier
SELECT 
    `Membership Type`, 
    COUNT(*) AS total_customers, 
    ROUND(AVG(`Total Spend`), 2) AS avg_spend, 
    ROUND(SUM(`Total Spend`), 2) AS total_revenue, 
    ROUND(MIN(`Total Spend`), 2) AS min_spend,
    ROUND(MAX(`Total Spend`), 2) AS max_spend 
FROM customers 
GROUP BY `Membership Type` 
ORDER BY avg_spend DESC;

-- City Performance Ranking 
SELECT 
    City, 
    COUNT(*) AS customer_count, 
    ROUND(AVG(`Total Spend`), 2) AS avg_spend, 
    ROUND(AVG(`Average Rating`), 2) AS avg_rating, 
    ROUND(AVG(`Days Since Last Purchase`), 1) AS avg_days_inactive 
FROM customers 
GROUP BY City 
ORDER BY avg_spend DESC;

-- Satisfaction Level Breakdown by Membership
SELECT 
    `Membership Type`, 
    `Satisfaction Level`, 
    COUNT(*) AS customer_count, 
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER 
          (PARTITION BY `Membership Type`), 1) AS pct_of_tier 
FROM customers 
GROUP BY `Membership Type`, `Satisfaction Level` 
ORDER BY `Membership Type`, customer_count DESC;

-- Churn Risk Analysis 
SELECT 
    CASE 
        WHEN `Days Since Last Purchase` > 45 THEN 'High Risk' 
        WHEN `Days Since Last Purchase` > 25 THEN 'Medium Risk' 
        ELSE 'Low Risk' 
    END AS churn_risk, 
    COUNT(*) AS customer_count, 
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers), 1) AS pct_total, 
    ROUND(AVG(`Total Spend`), 2) AS avg_spend, 
    ROUND(AVG(`Average Rating`), 2) AS avg_rating 
FROM customers 
GROUP BY churn_risk 
ORDER BY customer_count DESC;

-- Discount Effectiveness 
SELECT 
    `Discount Applied`, 
    COUNT(*) AS customers, 
    ROUND(AVG(`Total Spend`), 2) AS avg_spend, 
    ROUND(AVG(`Items Purchased`), 1) AS avg_items, 
    ROUND(AVG(`Average Rating`), 2) AS avg_rating, 
    ROUND(AVG(`Days Since Last Purchase`), 1) AS avg_days_inactive 
FROM customers 
GROUP BY `Discount Applied`;

-- Top 10 Highest-Value Customers 
SELECT 
    `Customer ID`, 
    Gender, 
    Age, 
    City, 
    `Membership Type`, 
    `Total Spend`, 
    `Satisfaction Level`, 
    RANK() OVER (ORDER BY `Total Spend` DESC) AS spend_rank 
FROM customers 
ORDER BY `Total Spend` DESC 
LIMIT 10;

-- Gender x Membership Spend Matrix 
SELECT 
    Gender, 
    `Membership Type`, 
    COUNT(*) AS customers, 
    ROUND(AVG(`Total Spend`), 2) AS avg_spend, 
    ROUND(SUM(CASE WHEN `Satisfaction Level` = 'Satisfied' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS pct_satisfied 
FROM customers 
GROUP BY Gender, `Membership Type` 
ORDER BY Gender, avg_spend DESC;


