Drop Table if exists Zepto;

Create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountedPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
WeightInGms INTEGER,
outofstock BOOLEAN,
quantity INTEGER
);


--Data Exploration

--Count of Rows
SELECT COUNT(*) FROM zepto;

--Sample data
SELECT * FROM zepto
LIMIT 10;

--Null Values
SELECT * FROM zepto
WHERE name is NULL
OR
Category is NULL
OR
mrp is NULL
OR
discountedpercent is NULL
OR
discountedsellingprice is NULL
OR
weightinGms is NULL
OR
outofstock is NULL
OR
quantity is NULL;

--Different Product Categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--Product in stock vs out of stock
SELECT outofstock,COUNT(sku_id)
FROM zepto
GROUP BY outofstock;

--Product names present multiple times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id)>1
ORDER BY COUNT(sku_id)DESC;

--Data Cleaning

--Products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0

DELETE FROM zepto
WHERE mrp = 0;

--Convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingprice = discountedSellingprice/100.0;

SELECT mrp, discountedSellingprice FROM zepto


--BUSINESS REQUIREMENT 

--Q1. Find the top 10 best-value products based on the discounted percentage.
SELECT DISTINCT name, mrp, discountedPercent
FROM zepto
ORDER BY discountedPercent DESC
LIMIT 10;

--Q2. What are the producst with High MRP but out of stock.
SELECT DISTINCT name, mrp
FROM zepto
WHERE outofstock = TRUE and mrp > 300
ORDER BY mrp DESC;

--Q3. Calculate Estimated Revenue for each category.
SELECT category, 
SUM(discountedsellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Q4. Find all products where MRP is greater than 500 rupees and discount is less than 10%.
SELECT DISTINCT name, mrp, discountedPercent 
FROm zepto
WHERE mrp > 500 AND discountedPercent < 10
ORDER BY mrp DESC, discountedPercent DESC;

--Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category, 
ROUND(AVG(discountedPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--Q6. Find the price per gram for products above 100g and sort by value.
SELECT DISTINCT name, weightinGms, discountedsellingprice,
ROUND(discountedsellingprice/weightinGms,2) AS price_per_gram
FROM ZEPTO
WHERE weightinGms >= 100 
ORDER BY price_per_gram;

--Q7. Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightinGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
WHEN weightINGms < 5000 THEN 'Medium'
ELSE 'Bulk'
END AS weight_category
FROM Zepto;

--Q8. What is the Total Inventory Weight Per Category
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

