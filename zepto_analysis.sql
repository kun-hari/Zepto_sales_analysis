/*
select * from zepto_data

update zepto_data
set Item_Fat_Content = 
case 
when Item_Fat_Content in ('LF','low fat') then 'Low Fat'
when Item_Fat_Content = 'reg' then 'Regular'
else Item_Fat_Content
end
*/

-- select distinct item_fat_content from zepto_data
select * from zepto_data

-- KPIs

-- 1. Total sales

select round(sum(total_sales)/1000000,2) as Total_sales_in_millions
from zepto_data;

-- 2. Average Sales

select round(avg(total_sales),1) as Average_sales 
from zepto_data

-- 3. Number of items

select count(*) as Number_of_items
from zepto_data

-- 4. Average Rating

select round(avg(rating),2) as Average_rating
from zepto_data

-- GRANULAR REQUIREMENTS

-- Total sales by fat content

select item_fat_content, 
round(sum(total_sales),2) as Total_sales,
round(avg(total_sales),1) as Average_sales,
count(*) as Number_of_items,
round(avg(rating),2) as Average_rating
from zepto_data
group by Item_Fat_Content
order by Total_sales desc

-- Total sales by item type

select item_type, 
concat(round(sum(total_sales)/1000,2), 'k') as Total_sales,
round(avg(total_sales),1) as Average_sales,
count(*) as Number_of_items,
round(avg(rating),2) as Average_rating
from zepto_data
group by Item_Type
order by Total_sales desc

-- Fat content by outlet for total sales

SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM zepto_data
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;

-- Total Sales by outlet establishment

SELECT Outlet_Establishment_Year, concat(Round(SUM(Total_Sales)/1000,2),'k') AS Total_Sales_in_thousand,
round(avg(total_sales),1) as Average_sales,
count(*) as Number_of_items,
round(avg(rating),2) as Average_rating
FROM zepto_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year

-- Percentage of sales by outlet size

SELECT 
    Outlet_Size, 
    ROUND(SUM(Total_Sales),2) AS Total_Sales,
    ROUND((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER ()),2) AS Sales_Percentage
FROM zepto_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

-- Sales by outlet location

SELECT Outlet_Location_Type, round(SUM(Total_Sales) ,2) AS Total_Sales,
 ROUND((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER ()),2) AS Sales_Percentage
FROM zepto_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC

-- All metrics by oulet type

SELECT Outlet_Type, 
round(SUM(Total_Sales) ,2) AS Total_Sales,
 concat(ROUND((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER ()),2),'%') AS Sales_Percentage,
		round(AVG(Total_Sales), 2) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		round(AVG(Rating),2) AS Avg_Rating,
		round(AVG(Item_Visibility) ,2) AS Item_Visibility
FROM zepto_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC

