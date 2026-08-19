-- =========================================================
-- EDA Step 1: Overall Business KPIs
-- =========================================================
SELECT 
    COUNT(DISTINCT `Order ID`) AS total_orders,
    COUNT(DISTINCT `Customer ID`) AS total_customers,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    SUM(Quantity) AS total_quantity_sold,
    round(sum(Profit) / SUM(Sales) * 100,2)  AS overall_profit_margin_
FROM orders1;

-- =========================================================
-- EDA Step 2: Monthly Sales & Profit Trends
-- =========================================================
SELECT 
    DATE_FORMAT(`Order Date`, '%Y') AS `year_month`,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM orders1
GROUP BY `year_month`
ORDER BY  `year_month` DESC;


-- =========================================================
-- EDA Step 3: Performance by Category & Sub-Category
-- =========================================================
SELECT 
    Category,
    `Sub-Category`,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin_pct
FROM orders1
GROUP BY Category, `Sub-Category`
ORDER BY total_profit ASC;


select `Sub-Category`,
round(AVG(Discount),2) AS AVG_DISCOUNT,
ROUND(SUM(PROFIT),2) AS TOTAL_PROFIT
FROM ORDERS1
group by `Sub-Category`
order by AVG_DISCOUNT DESC;

-- =========================================================
-- EDA Step 4: Discount Level vs. Profitability
-- =========================================================
SELECT 
    Discount,
    COUNT(*) AS total_orders,
    ROUND(AVG(SALES),2) AS AVG_SALES_PER_ORDER, 
     ROUND(SUM(SALES),2) AS SUM_SALES_PER_ORDER, 
    ROUND(AVG(Profit), 2) AS avg_profit_per_order,
    ROUND(SUM(Profit), 2) AS total_profit
FROM orders1
GROUP BY Discount
ORDER BY Discount DESC;

-------------------------------------------------------------------------
-- EDA Step 5.1: top category by total profit

select Category,
ROUND(SUM(PROFIT),2) AS TOTAL_PROFIT
FROM ORDERS1
GROUP BY Category
ORDER  BY TOTAL_PROFIT DESC
LIMIT 1;

-- EDA Step 5.2: top 10 customers by by Total profit

Select `Customer Name`,
COUNT(distinct`Order ID`) AS TOTAL_ORDERS,
round(SUM(SALES),2) AS TOTAL_SALES,
ROUND(SUM(PROFIT),2) AS TOTAL_PROFIT
FROM ORDERS1
GROUP BY `Customer Name`
ORDER  BY TOTAL_PROFIT DESC
LIMIT 10;


-----------------------------------------------------------------------
-- EDA Step 6:  Market and Region Performence 
-- 6.1 Market Performence

select market, 
round(sum(sales),2) as total_sales,
round(sum(profit),2) as total_profit
from orders1
group by market
order by total_profit desc;

-- 6.2 region performence
select region,
round(sum(sales),2) as total_sales,
round(sum(profit),2 ) as total_profit
from orders1
group by region
order by total_profit desc











