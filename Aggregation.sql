/* Name: Godknows_Mutize
   Category: Vodka
   Section: Aggregation — Questions 4 through 8 */

 -- 4. What is the total sales revenue and the average bottle price (btl_price) for Vodka?  
 --    (Strength/Baseline: Establishing the financial footprint)
 SELECT 
 	SUM(total) AS total_sales_revenue,
	 ROUND(AVG(btl_price::numeric),2) AS avg_btl_price
FROM sales
WHERE category_name ILIKE '%vodka%';
-- total_sales_revenue = 92993705.16
-- avg_btl_price = 12.09

-- 5. How many transactions were recorded for each specific item description within Vodka
-- Which specific product is the most frequently purchased? 
-- (Strength: Identifying your "hero" product). 
SELECT 
	description,
	COUNT(*) AS transaction_count
FROM sales
WHERE category_name ILIKE '%vodka%'
GROUP BY description
ORDER BY transaction_count DESC;
-- Hawkeye Vodka is the most frequently purchased 

-- 6. Which store generated the highest total revenue for your Vodka?
--    Which generated the lowest (but still greater than zero)?
--    (Strength vs. Weakness: Identifying your best and worst retail partners).
SELECT 
	store,
	SUM(total) AS total_sales_revenue
FROM sales
WHERE  category_name ILIKE '%vodka%'
GROUP BY store
ORDER BY total_sales_revenue DESC
LIMIT 1;
--Store 2633 generated the highest total revenue

-- Lowest revenue store (greater than zero):
SELECT 
	store,
	SUM(total) AS total_sales_revenue
FROM sales
WHERE  category_name ILIKE '%vodka%'
GROUP BY store
HAVING SUM(total) > 0
ORDER BY total_sales_revenue ASC
LIMIT 1;
-- Store 4460 generates the lowest revenue

-- 7. What is the total revenue for every vendor for Vodka,
-- sorted from highest to lowest?
-- (Threat: Identifying your top competitors in that space)
SELECT
	vendor,
	SUM(total) AS total_sales_revenue
FROM sales
WHERE  category_name ILIKE '%vodka%'
GROUP BY vendor
ORDER BY total_sales_revenue DESC
-- The top competitor is Diageo Americas with total sales revenue of 19082595.37

-- 8. Which stores had total sales revenue for your Vodka exceeding $2,000?
--  (Hint: Use HAVING to filter aggregated store totals).
--  (Strength: Pinpointing high-performing retail locations).
SELECT
	store,
	SUM(total) AS total_sales_revenue
FROM sales 
WHERE category_name ILIKE '%vodka%'
GROUP BY store
HAVING SUM(total) > 2000
ORDER BY total_sales_revenue DESC
-- 1292 Stores had a total sales revenue exceeding 2000

