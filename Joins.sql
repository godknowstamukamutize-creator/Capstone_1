/* Name: [G]
   Category/Vendor of Choice: Vodka
   Section: Joins — Questions 9 through 16 */

-- 9. Find all sales records where the category_name is either your chosen category
--    or a closely related competitor category (e.g., 'VODKA 80 PROOF' vs 'IMPORTED VODKA').
--    (Threat: Comparing performance against direct substitutes).
SELECT
	store,
	description,
	s.category_name,
	total
FROM sales s 
JOIN products p
	ON s.item = p.item_no
WHERE  p.category_name ILIKE '%vodka%'
ORDER BY p.category_name, total DESC;

-- 10. List all transactions where the state bottle cost was between $10 and $20 for Vodka
-- (Opportunity: Analyzing performance in the "mid-tier" price bracket).
SELECT 
	date,
	store,
	description,
	state_btl_cost,
	category_name,
	total
FROM sales
WHERE  category_name    ILIKE '%vodka%'
  AND  state_btl_cost::numeric BETWEEN 10 AND 20
ORDER BY state_btl_cost DESC;

-- 11. Write a query that displays each store's total sales for Vodka
--  along with the store's name and address from the stores_table.
--  (Strength: Mapping your physical sales footprint).
SELECT 
	s.store,
	st.name AS store_name,
	store_address,
	SUM(total) AS total_sales_revenue
FROM sales s
JOIN stores st
	ON s.store = st.store
WHERE s.category_name ILIKE '%vodka%'
GROUP BY s.store, st.name, store_address
ORDER BY total_sales_revenue DESC;

-- 12. For each sale in Vodka, display the transaction date, total amount,
--     and the population of the county where the sale occurred by joining with counties_table.
--     (Opportunity: Correlating sales volume with population density).
SELECT
	s.date,
	s.county,
	total,
	c.population
FROM sales s
JOIN counties c
	ON s.county = c.county
WHERE  s.category_name ILIKE '%vodka%'
ORDER BY s.date DESC;

-- 13. Write a query that shows total sales for Vodka by county.
--     Which county generates the most revenue for you?
--     (Strength: Identifying your geographic stronghold).

SELECT 
	s.county,
	c.population,
	SUM(total) AS total_sales_revenue
FROM sales s
JOIN counties c
	ON s.county = c.county
WHERE  s.category_name ILIKE '%vodka%'
GROUP BY s.county, c.population
ORDER BY total_sales_revenue DESC;
-- Polk county generates more revenue

-- 14. Join the sales_table and products_table to show total revenue for your Vodka
--     alongside the proof and pack size of the items.
--     (Strength: Determining if higher proof or larger packs drive more revenue).
SELECT
	p.item_description,
	p.pack,
	p.proof,
	SUM(s.total) AS total_sales_revenue
FROM sales s
JOIN products p
	ON s.item = p.item_no
WHERE s.category_name ILIKE '%vodka%'
GROUP BY p.item_description, p.proof, p.pack
ORDER BY total_sales_revenue DESC

-- 15. Are there any counties in the counties_table that have a population over 10,000
--     but zero sales for your Vodka
--     (Opportunity: Identifying untapped markets).
SELECT
	s.total,
	c.county,
    c.population
FROM counties c
LEFT JOIN sales s
	ON UPPER(s.county) = UPPER(c.county)
	AND s.category_name ILIKE '%vodka%'
WHERE  c.population > 10000
  AND  s.total IS NULL
ORDER BY c.population DESC;
-- All counties with populations over 10000 have above zero sales

-- 16. Display total revenue for your Vodka grouped by the store_status
--     (from stores_table). Are active stores ('A') performing significantly better than others?
--     (Threat: Assessing the risk of sales tied to inactive or closed locations).
SELECT 
	COUNT(DISTINCT s.store),
	st.store_status,
	SUM(total) AS total_sales_revenue
FROM sales s
JOIN stores st
	ON s.store = st.store
WHERE s.category_name ILIKE '%vodka%'
GROUP BY st.store_status
ORDER BY total_sales_revenue DESC;
-- vodka transaction in the dataset is linked to a store with status 'A' (active) 
-- there are no vodka sales rows that join to stores with any other status.




