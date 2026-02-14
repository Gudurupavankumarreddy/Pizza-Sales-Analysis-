-- KPI QUERIES 

    -- KPI 1: Total Revenue (The sum of all sales)
    SELECT SUM(total_price) AS [Total Revenue] from pavan.dbo.pizza_sales;

    -- KPI 2: Average Order Value (Total Revenue / Total Orders)
    -- CAST is used to ensure the result has two decimal places.
    SELECT CAST(SUM(total_price) / COUNT(DISTINCT order_id) AS DECIMAL(10, 2)) AS [Average Order Value] from pavan.dbo.pizza_sales;
    
    -- KPI 3: Total Pizzas Sold (The sum of all quantity)
     SELECT SUM(quantity) AS [Total Pizzas Sold] from pavan.dbo.pizza_sales;
	
	-- KPI 4: Total Orders (The total number of unique order IDs)
     SELECT COUNT(DISTINCT order_id) AS [Total Orders] from pavan.dbo.pizza_sales;
    
    -- KPI 5: Average Pizzas per Order (Total Pizzas Sold / Total Orders)
    -- Multiplying by 1.0 forces decimal division for accuracy before casting.
    SELECT CAST(SUM(quantity) * 1.0 / COUNT(DISTINCT order_id) AS DECIMAL(10, 2)) AS [Average Pizzas Per Order] from pavan.dbo.pizza_sales



-- Time-Based KPIs 
-- These analyze orders by day of the week and month to identify trends.


-- KPI 6: Orders by Day of Week

SET DATEFIRST 1;  -- Monday = 1

SELECT
    DATENAME(dw, order_date) AS [Day Name],       -- Full day name
    DATEPART(dw, order_date) AS [Day Number],    -- Day number for sorting
    LEFT(DATENAME(dw, order_date), 3) AS [Day Abbrev], -- 3-letter abbreviation
    COUNT(DISTINCT order_id) AS [Total Orders]   -- Total orders on that day
FROM pavan.dbo.pizza_sales
GROUP BY
    DATENAME(dw, order_date),
    DATEPART(dw, order_date)
ORDER BY
    DATEPART(dw, order_date);

	
	
-- KPI 7: Orders by Month

SELECT
    DATENAME(month, order_date) AS [Month Name],  -- Full month name
    DATEPART(month, order_date) AS [Month Number], -- Month number for sorting
	LEFT(DATENAME(month, order_date), 3) AS [Day Abbrev], -- 3-letter abbreviation
    COUNT(DISTINCT order_id) AS [Total Orders]    -- Total orders in that month
FROM pavan.dbo.pizza_sales
GROUP BY
    DATENAME(month, order_date),
    DATEPART(month, order_date)
ORDER BY
    DATEPART(month, order_date); -- Ensures chronological order



-- Category and Size Breakdown KPIs 
-- These show revenue and volume distributions.  

-- KPI 8: Revenue by Pizza Category
-- Shows total revenue per pizza category and its percentage of overall revenue
-- Ordered by percentage ascending (least profitable first)

WITH CategoryRevenue AS (
    SELECT 
        pizza_category,
        SUM(total_price) AS Total_Amount,               -- Total revenue for this category
        SUM(SUM(total_price)) OVER () AS Grand_Total_Revenue -- Total revenue across all categories
    FROM pavan.dbo.pizza_sales
    GROUP BY pizza_category
)
SELECT
    pizza_category AS [Pizza Category],
    Total_Amount AS [Total Amount],
    CAST(Total_Amount * 100.0 / Grand_Total_Revenue AS DECIMAL(10, 2)) AS [Percentage]
FROM CategoryRevenue
ORDER BY [Percentage] ; -- least profitable category first


   -- KPI 9: Revenue by Pizza Size
-- Shows total revenue per pizza size and its percentage of overall revenue
-- Ordered by percentage descending (most profitable first)

WITH SizeRevenue AS (
    SELECT 
        pizza_size,
        SUM(total_price) AS Total_Amount,               -- Total revenue for this size
        SUM(SUM(total_price)) OVER () AS Grand_Total_Revenue -- Total revenue across all sizes
    FROM pavan.dbo.pizza_sales
    GROUP BY pizza_size
)
SELECT
    pizza_size AS [Pizza Size],
    Total_Amount AS [Total Amount],
    CAST(Total_Amount * 100.0 / Grand_Total_Revenue AS DECIMAL(10, 2)) AS [Percentage]
FROM SizeRevenue
ORDER BY [Percentage] DESC; -- most profitable size first



-- KPI 10: Pizza Count by Category
-- Shows total number of pizzas sold per category
-- Ordered ascending to identify least popular categories

SELECT
    pizza_category AS [Pizza Category],
    SUM(quantity) AS [Pizza Count]  -- Total pizzas sold per category
FROM pavan.dbo.pizza_sales
GROUP BY pizza_category
ORDER BY [Pizza Count] ASC; -- least popular category first



-- Top and Bottom Performer KPIs 
-- These highlight best and worst-selling pizzas based on unique orders.


-- KPI 11: Top 5 Pizzas by Orders
-- Shows the 5 pizzas included in the highest number of unique orders

SELECT TOP 5
    pizza_name AS [Pizza Name],
    COUNT(DISTINCT order_id) AS [Total Orders]  -- Number of unique orders including this pizza
FROM pavan.dbo.pizza_sales
GROUP BY pizza_name
ORDER BY [Total Orders] DESC; -- Most popular pizzas first


-- KPI 12: Bottom 5 Pizzas by Orders
-- Shows the 5 pizzas included in the fewest number of unique orders

SELECT TOP 5
    pizza_name AS [Pizza Name],
    COUNT(DISTINCT order_id) AS [Total Orders]  -- Number of unique orders including this pizza
FROM pavan.dbo.pizza_sales
GROUP BY pizza_name
ORDER BY [Total Orders] ASC; -- Least popular pizzas first


