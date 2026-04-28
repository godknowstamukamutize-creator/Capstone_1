/* Name: Godknows_Mutize
   Category/Vendor of Choice: Vodka
*/
-- 1. Create a list of all transactions for your chosen [Category/Vendor] that took place in  
--    the last quarter of 2014, sorted by the total sale amount from highest to lowest. 
--    (Strength: Identifying high-volume peak periods). 

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


-- 2. Which Vodka transactions had a bottle quantity greater than 12?
--    Display: date, store number, item description, total
--    (Strength: Identifying bulk buyers)

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

-- 3. Find all products in the products_table whose item_description contains a specific
--    keyword (e.g., 'Limited', 'Spiced'). What categories do they belong to?
--    (Opportunity: Identifying niche product variants).

SELECT
	item_description,
	category_name
FROM public.products
WHERE item_description ILIKE '%Limited%'
	OR item_description ILIKE '%Spiced%'
ORDER BY category_name, item_description;