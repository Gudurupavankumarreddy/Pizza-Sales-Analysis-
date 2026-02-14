select * from pavan.dbo.pizza_sales;

select TOP 10 * from pavan.dbo.pizza_sales;

select count(*) as total_rows from pavan.dbo.pizza_sales;

SELECT order_id, pizza_id, COUNT(*) AS duplicate_count
FROM pavan.dbo.pizza_sales
GROUP BY order_id, pizza_id
HAVING COUNT(*) > 1;

SELECT 
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS Null_Order_ID,
    SUM(CASE WHEN pizza_id IS NULL THEN 1 ELSE 0 END) AS Null_Pizza_ID,
    SUM(CASE WHEN pizza_name_id IS NULL THEN 1 ELSE 0 END) AS Null_Pizza_Name_ID,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS Null_Quantity,
    SUM(CASE WHEN total_price IS NULL THEN 1 ELSE 0 END) AS Null_Total_Price,
    SUM(CASE WHEN pizza_size IS NULL THEN 1 ELSE 0 END) AS Null_Pizza_Size,
    SUM(CASE WHEN pizza_category IS NULL THEN 1 ELSE 0 END) AS Null_Pizza_Category
FROM pavan.dbo.pizza_sales;


-- Use a TRANSACTION to ensure all changes either succeed or fail together, 
-- and to allow you to easily UNDO the changes if necessary.

BEGIN TRANSACTION;

UPDATE pavan.dbo.pizza_sales
SET pizza_size = 
    CASE pizza_size
        WHEN 'S' THEN 'Small'
        WHEN 'M' THEN 'Medium'
        WHEN 'L' THEN 'Large'
        WHEN 'XL' THEN 'Extra Large'
        WHEN 'XXL' THEN 'Double Extra Large'
        ELSE pizza_size -- Leave any other value as is (for safety)
    END
WHERE pizza_size IN ('S', 'M', 'L', 'XL', 'XXL'); -- Only update rows that need fixing

select * from pavan.dbo.pizza_sales;


SELECT pizza_size, COUNT(*) AS CountOfOrders
FROM pavan.dbo.pizza_sales
GROUP BY pizza_size;

COMMIT TRANSACTION;

ROLLBACK TRANSACTION;




BEGIN TRANSACTION;

-- Revert the pizza_size column from full names to single-letter abbreviations
UPDATE pavan.dbo.pizza_sales
SET pizza_size = 
    CASE pizza_size
        WHEN 'Small' THEN 'S'
        WHEN 'Medium' THEN 'M'
        WHEN 'Large' THEN 'L'
        WHEN 'Extra Large' THEN 'XL'
        WHEN 'Double Extra Large' THEN 'XXL'
        ELSE pizza_size -- Keep any other value as-is
    END
WHERE pizza_size IN ('Small', 'Medium', 'Large', 'Extra Large', 'Double Extra Large');

-- Verify the change (optional, but recommended)
SELECT DISTINCT pizza_size, COUNT(*) FROM pavan.dbo.pizza_sales GROUP BY pizza_size;

-- If the output shows S, M, L, XL, XXL, then make the change permanent
COMMIT TRANSACTION;


SELECT *
FROM pavan.dbo.pizza_sales
WHERE quantity <= 0 OR total_price <= 0;

SELECT TOP 5 
    order_date,
    order_time,
    ISDATE(order_date) AS Valid_Date,
    ISDATE(order_time) AS Valid_Time
FROM pavan.dbo.pizza_sales;

-- View all unique sizes and their counts
SELECT pizza_size, COUNT(*) AS CountOfOrders
FROM pavan.dbo.pizza_sales
GROUP BY pizza_size;

-- View all unique categories and their counts
SELECT pizza_category, COUNT(*) AS CountOfOrders
FROM pavan.dbo.pizza_sales
GROUP BY pizza_category;



















