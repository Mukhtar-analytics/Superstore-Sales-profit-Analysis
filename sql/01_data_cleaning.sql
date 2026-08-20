------------------------------------------------------------------------------------------------------
-- Project: Superstore Global Data cleaning and transformation 
-- Script: Data Cleaning Pipeline
-- description: preparing raw superstore data for EDA and visualizatoion 

--------------------------------------------------------------------------------------------------------
-- step 1: Data staging and Raw Data Preservation 
-- creating a staging table (orders1) to preserve the raw dataset (orders) 
select * 
from orders;


create table orders1
like orders;

insert orders1
select * 
from orders
;

------------------------------------------------------------------------------------------------------------------------------------
-- step 2: checking for duplicate rows 
-- description: Using row_number() to identify duplicate records
-- Results : 0 duplicate found. Data is unique

with duplicate_row as (
select *, 
row_number() over(partition by `Order ID`,`Order Date`,`profit`, `Product ID`, `Ship Date`, `Ship Mode`, `Customer ID`, `Customer Name`, `Segment`, `Postal Code`, City, State, Country,
Region, Market, Category,`Product Name`, Sales, Quantity, Discount, `Shipping Cost`, `Order Priority` ) as row_num
from orders1 )

select *
from duplicate_row
where row_num > 1;

-----------------------------------------------------------------------------------------------------------
-- step 3 : standardizing date formats 
-- description : converting string-formatted dates (%d/%m/%Y) into standard date data type
-- affected column : order_date , ship_date 
-- output : proper date data type ready for time-series analysis
select `order date`, `ship date`, 
str_to_date(`order date`, '%d/%m/%Y') as order_date_fixed,
str_to_date(`ship date`, '%d/%m/%Y')as ship_date_fixed
from orders1;

-- apply updates
update orders1
set `order date` = str_to_date(`order date`, '%d/%m/%Y'),
 `ship date` = str_to_date(`ship date`, '%d/%m/%Y');


alter table orders1
modify column `Order Date` date,
modify column `Ship Date` date
;

----------------------------------------------------------------------------------------
-- step 4:null values
-- desqription : checking for null values across key table attributes using conditional sums.
-- results : verified - 0 null values found in this table

select
  sum(case when `Order ID` is null then 1 else 0 end) as OrderID_nulls,
  sum(case when `Order Date` is null then 1 else 0 end) as OrderDate_nulls,
  sum(case when `Ship Date` is null then 1 else 0 end) as ShipDate_nulls,
  sum(case when `Ship Mode` is null then 1 else 0 end) as ShipMode_nulls,
  sum(case when `Customer ID` is null then 1 else 0 end) as CustomerID_nulls,
  sum(case when `Customer Name` is null then 1 else 0 end) as CustomerName_nulls,
  sum(case when Segment is null then 1 else 0 end) as Segment_nulls,
  sum(case when `Postal Code` is null then 1 else 0 end) as PostalCode_nulls,
  sum(case when City is null then 1 else 0 end) as City_nulls,
  sum(case when State is null then 1 else 0 end) as State_nulls,
  sum(case when Country is null then 1 else 0 end) as Country_nulls,
  sum(case when Region is null then 1 else 0 end) as Region_nulls,
  sum(case when Market is null then 1 else 0 end) as Market_nulls,
  sum(case when `Product ID` is null then 1 else 0 end) as ProductID_nulls,
  sum(case when `Category` is null then 1 else 0 end) as Category_nulls,
  sum(case when `Sub-Category` is null then 1 else 0 end) as SubCategory_nulls,
  sum(case when `Product Name` is null then 1 else 0 end) as ProductName_nulls,
  sum(case when Sales is null then 1 else 0 end) as Sales_nulls,
  sum(case when Quantity is null then 1 else 0 end) as Quantity_nulls,
  sum(case when Discount is null then 1 else 0 end) as Discount_nulls,
  sum(case when Profit is null then 1 else 0 end) as Profit_nulls,
  sum(case when `Shipping Cost` is null then 1 else 0 end) as ShippingCost_nulls,
  sum(case when `Order Priority` is null then 1 else 0 end) as OrderPriority_nulls
from orders1;

------------------------------------------------------------------------------------------------------------
-- step 5: standardize data
-- description: identifying and Removing leading/trailing spaces across text fields.
-- Affected columns: product_name (16 rows flagged)


select 
sum(case when length(`Ship Mode`) <> length(trim(`Ship Mode`)) then 1 else 0 end ) as Ship_spaces, 
sum(case when length(`Customer Name`) <> length(trim(`Customer Name`)) then 1 else 0 end) as cus_spaces,
sum(case when length(segment) <> length(trim(segment)) then 1 else 0 end) as seg_spaces, 
sum(case when length(city) <> length(trim(city)) then 1 else 0 end ) as city_spaces,
sum(case  when length(state) <> length(trim(state)) then 1 else 0 end ) as st_spaces,
sum(case when length(country) <> length(trim(country)) then 1 else 0 end ) as coun_space,
sum( case when length(region) <> length(trim(region)) then 1 else 0 end ) as re_spaces,
sum(case when length(market) <>  length(trim(market)) then 1 else 0 end ) as ma_spaces,
sum( case when length(`Product ID`) <> length(trim(`Product ID`)) then 1 else 0 end ) as pro_spaces,
sum(case when length(category) <> length(trim(category)) then 1 else 0 end ) as cat_spaces, 
sum(case when length(`Sub-Category`) <> length(trim(`Sub-Category`)) then 1 else 0 end ) as sub_spaces,
sum(case when length(`Product Name`) <> length(trim(`Product Name`)) then 1 else 0 end ) as produ_spaces,
sum(case when length(`Order Priority`) <> length(trim(`Order Priority`)) then 1 else 0 end ) as order_perority_spaces,
sum(case when length(`order id`) <> length(trim(`order id`)) then 1 else 0 end ) as orde_spaces,
sum(case when length(`Customer id`) <> length(trim(`Customer id`)) then 1 else 0 end) as customer_id_spaces
from orders1
;


select concat('[', `product name`, ']') as checking_spa
from orders1
where length(`Product Name`) <> length(trim(`product name`))

;
update orders1
set `product name` = trim(`product name`);






