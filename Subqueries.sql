-- 17. Using a subquery, find all transactions for your [Category/Vendor] from stores
--     located in a specific high-growth city (e.g., 'Des Moines') found in the stores_table.
--     (Opportunity: Drilling down into urban market performance).
SELECT *
FROM sales s
WHERE s.category_name ILIKE '%vodka%'
AND s.county IN (
    SELECT county
    FROM counties
    WHERE population > 50000)

-- 18. Which stores had total sales for Vodka that were above the
-- average store revenue for that same group?
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

-- 19. Find the top 5 highest-grossing items for your [Vendor], then use a subquery
--     to look up their full details (like case_cost and proof) from the products_table.
--     (Strength: Deep-dive into the specs of your most profitable inventory).

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

-- 20. Write a query using a subquery to find all sales records for your [Category]
--     from stores that have an 'A' (Active) status in the stores_table.
--     (No label given — confirms active store sales footprint).
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

