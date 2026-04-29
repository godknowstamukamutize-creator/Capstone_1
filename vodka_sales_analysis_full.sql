/* Name: Godknows_Mutize
   Category/Vendor of Choice: Vodka
*/
-----------------------------------------------------------------------------------------------
-- 1. Create a list of all transactions for your chosen [Category/Vendor] that took place in  
--    the last quarter of 2014, sorted by the total sale amount from highest to lowest. 
--    (Strength: Identifying high-volume peak periods). 
-----------------------------------------------------------------------------------------------
-- SELECT, Filtering & Sorting

SELECT
    date,
    store,
    description,
    bottle_qty,
	category_name,
    total
FROM sales
WHERE  category_name ILIKE '%vodka%'
  AND  date BETWEEN '2014-10-01' AND '2014-12-31'
ORDER BY total DESC;

-----------------------------------------------------------------------------------------------
-- 2. Which Vodka transactions had a bottle quantity greater than 12?
--    Display: date, store number, item description, total
--    (Strength: Identifying bulk buyers)
-----------------------------------------------------------------------------------------------
SELECT
	date,
	store,
	description,
	bottle_qty,
	total
FROM sales
WHERE category_name ILIKE '%vodka%'
	AND bottle_qty > 12
ORDER BY total DESC;

-----------------------------------------------------------------------------------------------
-- 3. Find all products in the products_table whose item_description contains a specific
--    keyword (e.g., 'Limited', 'Spiced'). What categories do they belong to?
--    (Opportunity: Identifying niche product variants).
-----------------------------------------------------------------------------------------------
SELECT
	item_description,
	category_name
FROM public.products
WHERE item_description ILIKE '%Limited%'
	OR item_description ILIKE '%Spiced%'
ORDER BY category_name, item_description;


   Section: Aggregation — Questions 4 through 8 */
-----------------------------------------------------------------------------------------------
 -- 4. What is the total sales revenue and the average bottle price (btl_price) for Vodka?  
 --    (Strength/Baseline: Establishing the financial footprint)
-----------------------------------------------------------------------------------------------
 SELECT 
 	SUM(total) AS total_sales_revenue,
	 ROUND(AVG(btl_price::numeric),2) AS avg_btl_price
FROM sales
WHERE category_name ILIKE '%vodka%';
-- total_sales_revenue = 92993705.16
-- avg_btl_price = 12.09

-----------------------------------------------------------------------------------------------
-- 5. How many transactions were recorded for each specific item description within Vodka
-- Which specific product is the most frequently purchased? 
-- (Strength: Identifying your "hero" product). 
-----------------------------------------------------------------------------------------------

SELECT 
	description,
	COUNT(*) AS transaction_count
FROM sales
WHERE category_name ILIKE '%vodka%'
GROUP BY description
ORDER BY transaction_count DESC;
-- Hawkeye Vodka is the most frequently purchased 

-----------------------------------------------------------------------------------------------
-- 6. Which store generated the highest total revenue for your Vodka?
--    Which generated the lowest (but still greater than zero)?
--    (Strength vs. Weakness: Identifying your best and worst retail partners).
-----------------------------------------------------------------------------------------------
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

-----------------------------------------------------------------------------------------------
-- 7. What is the total revenue for every vendor for Vodka,
-- sorted from highest to lowest?
-- (Threat: Identifying your top competitors in that space)
-----------------------------------------------------------------------------------------------

SELECT
	vendor,
	SUM(total) AS total_sales_revenue
FROM sales
WHERE  category_name ILIKE '%vodka%'
GROUP BY vendor
ORDER BY total_sales_revenue DESC
-- The top competitor is Diageo Americas with total sales revenue of 19082595.37

-----------------------------------------------------------------------------------------------
-- 8. Which stores had total sales revenue for your Vodka exceeding $2,000?
--  (Hint: Use HAVING to filter aggregated store totals).
--  (Strength: Pinpointing high-performing retail locations).
-----------------------------------------------------------------------------------------------

SELECT
	store,
	SUM(total) AS total_sales_revenue
FROM sales 
WHERE category_name ILIKE '%vodka%'
GROUP BY store
HAVING SUM(total) > 2000
ORDER BY total_sales_revenue DESC
-- 1292 Stores had a total sales revenue exceeding 2000


   Section: Joins — Questions 9 through 16 */
-----------------------------------------------------------------------------------------------
-- 9. Find all sales records where the category_name is either your chosen category
--    or a closely related competitor category (e.g., 'VODKA 80 PROOF' vs 'IMPORTED VODKA').
--    (Threat: Comparing performance against direct substitutes).
-----------------------------------------------------------------------------------------------

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

-----------------------------------------------------------------------------------------------
-- 10. List all transactions where the state bottle cost was between $10 and $20 for Vodka
-- (Opportunity: Analyzing performance in the "mid-tier" price bracket).
-----------------------------------------------------------------------------------------------

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

-----------------------------------------------------------------------------------------------
-- 11. Write a query that displays each store's total sales for Vodka
--  along with the store's name and address from the stores_table.
--  (Strength: Mapping your physical sales footprint).
-----------------------------------------------------------------------------------------------

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

-----------------------------------------------------------------------------------------------
-- 12. For each sale in Vodka, display the transaction date, total amount,
--     and the population of the county where the sale occurred by joining with counties_table.
--     (Opportunity: Correlating sales volume with population density).
-----------------------------------------------------------------------------------------------

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

-----------------------------------------------------------------------------------------------
-- 13. Write a query that shows total sales for Vodka by county.
--     Which county generates the most revenue for you?
--     (Strength: Identifying your geographic stronghold).
-----------------------------------------------------------------------------------------------

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

-----------------------------------------------------------------------------------------------
-- 14. Join the sales_table and products_table to show total revenue for your Vodka
--     alongside the proof and pack size of the items.
--     (Strength: Determining if higher proof or larger packs drive more revenue).
-----------------------------------------------------------------------------------------------

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

-----------------------------------------------------------------------------------------------
-- 15. Are there any counties in the counties_table that have a population over 10,000
--     but zero sales for your Vodka
--     (Opportunity: Identifying untapped markets).
-----------------------------------------------------------------------------------------------

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

-----------------------------------------------------------------------------------------------
-- 16. Display total revenue for your Vodka grouped by the store_status
--     (from stores_table). Are active stores ('A') performing significantly better than others?
--     (Threat: Assessing the risk of sales tied to inactive or closed locations).
-----------------------------------------------------------------------------------------------

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


-----------------------------------------------------------------------------------------------
-- 17. Using a subquery, find all transactions for your [Category/Vendor] from stores
--     located in a specific high-growth city (e.g., 'Des Moines') found in the stores_table.
--     (Opportunity: Drilling down into urban market performance).
-----------------------------------------------------------------------------------------------

SELECT *
FROM sales s
WHERE s.category_name ILIKE '%vodka%'
AND s.county IN (
    SELECT county
    FROM counties
    WHERE population > 50000)

-----------------------------------------------------------------------------------------------
-- 18. Which stores had total sales for Vodka that were above the
-- average store revenue for that same group?
-----------------------------------------------------------------------------------------------

SELECT 
    store,
    SUM(total) AS total_sales_revenue
FROM sales
WHERE category_name  ILIKE '%vodka%'
GROUP BY store
HAVING SUM(total) > (
    SELECT AVG(store_total)
    FROM (
        SELECT SUM(total) AS store_total
        FROM sales
        WHERE vendor ILIKE '%vodka%'
        GROUP BY store
    ) AS store_totals
)
ORDER BY total_sales_revenue DESC

-----------------------------------------------------------------------------------------------
-- 19. Find the top 5 highest-grossing items for your [Vendor], then use a subquery
--     to look up their full details (like case_cost and proof) from the products_table.
--     (Strength: Deep-dive into the specs of your most profitable inventory).
-----------------------------------------------------------------------------------------------


SELECT
    p.item_no,
    p.item_description,
    p.proof,
    p.pack,
    p.case_cost,
    top5.total_sales_revenue
FROM   products p
JOIN  (
    SELECT
        item,
        SUM(total) AS total_sales_revenue
    FROM   sales s
    WHERE  category_name ILIKE '%vodka%'
    GROUP BY item
    ORDER BY total_sales_revenue DESC
    LIMIT  5
) AS top5 ON p.item_no = top5.item
ORDER BY top5.total_sales_revenue DESC;

-----------------------------------------------------------------------------------------------
-- 20. Write a query using a subquery to find all sales records for your [Category]
--     from stores that have an 'A' (Active) status in the stores_table.
--     (No label given — confirms active store sales footprint).
-----------------------------------------------------------------------------------------------

SELECT
    s.date,
    s.store,
    s.description,
    s.total AS total_sales_revenue
FROM  sales s
WHERE  s.category_name ILIKE '%vodka%'
  AND  s.store IN (
           SELECT store
           FROM   stores
           WHERE  store_status = 'A'
       )
ORDER BY s.total DESC;

