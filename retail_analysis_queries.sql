-- Retail Business Performance & Profitability Analysis
-- Database: MySQL 8+. Import retail_sales_cleaned.csv into a table named retail_sales.
-- Suggested column types are included below.

CREATE TABLE IF NOT EXISTS retail_sales (
  order_id VARCHAR(20) PRIMARY KEY,
  order_date DATE,
  region VARCHAR(30),
  category VARCHAR(50),
  product VARCHAR(80),
  units_sold INT,
  unit_price DECIMAL(12,2),
  discount_rate DECIMAL(5,2),
  sales DECIMAL(12,2),
  cost DECIMAL(12,2),
  profit DECIMAL(12,2),
  inventory_days INT,
  season VARCHAR(20)
);

-- 1. Overall business KPIs
SELECT COUNT(*) AS total_orders, SUM(units_sold) AS units_sold,
       ROUND(SUM(sales),2) AS total_sales,
       ROUND(SUM(profit),2) AS total_profit,
       ROUND(100*SUM(profit)/NULLIF(SUM(sales),0),2) AS profit_margin_pct
FROM retail_sales;

-- 2. Profitability by category and sub-category/product
SELECT category, product, SUM(sales) AS total_sales, SUM(profit) AS total_profit,
       ROUND(100*SUM(profit)/NULLIF(SUM(sales),0),2) AS profit_margin_pct
FROM retail_sales GROUP BY category, product
ORDER BY total_profit DESC;

-- 3. Regional performance
SELECT region, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM retail_sales GROUP BY region ORDER BY total_profit DESC;

-- 4. Seasonal product behavior
SELECT season, category, SUM(units_sold) AS units_sold,
       SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM retail_sales GROUP BY season, category
ORDER BY season, total_sales DESC;

-- 5. Inventory turnover proxy: average days held by product
SELECT product, category, AVG(inventory_days) AS avg_inventory_days,
       SUM(units_sold) AS units_sold, SUM(profit) AS total_profit
FROM retail_sales GROUP BY product, category
ORDER BY avg_inventory_days DESC;

-- 6. Flag slow-moving / high-inventory products (review threshold: 60 days)
SELECT product, category, AVG(inventory_days) AS avg_inventory_days,
       SUM(units_sold) AS units_sold, SUM(profit) AS total_profit
FROM retail_sales GROUP BY product, category
HAVING AVG(inventory_days) >= 60
ORDER BY avg_inventory_days DESC;

-- 7. Monthly trend
SELECT DATE_FORMAT(order_date,'%Y-%m') AS sales_month,
       SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM retail_sales GROUP BY DATE_FORMAT(order_date,'%Y-%m')
ORDER BY sales_month;

-- 8. Discount impact
SELECT CASE WHEN discount_rate=0 THEN 'No discount'
            WHEN discount_rate<=0.10 THEN 'Up to 10%'
            ELSE 'Above 10%' END AS discount_band,
       SUM(sales) AS total_sales, SUM(profit) AS total_profit,
       ROUND(100*SUM(profit)/NULLIF(SUM(sales),0),2) AS profit_margin_pct
FROM retail_sales GROUP BY discount_band;
