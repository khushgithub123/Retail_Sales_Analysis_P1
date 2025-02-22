-- SQL Retail Sales Analysis --
-- Create Table-- 
CREATE TABLE retail_sales
			(
				transactions_id INT PRIMARY KEY, 	
				sale_date DATE, 
				sale_time TIME,	
				customer_id	INT, 
				gender VARCHAR(15),
				age	INT,
				category VARCHAR(15),	
				quantiy	INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			)

SELECT COUNT(*) FROM retail_sales; 

--- DATA_CLEANING---

SELECT *  FROM retail_sales 
where transactions_id IS NULL;

SELECT *  FROM retail_sales 
where sale_date IS NULL;  

SELECT *  FROM retail_sales 
where sale_time IS NULL;  

SELECT * FROM retail_sales 
WHERE 
	transactions_id IS NULL
	OR 
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR 
    gender IS NULL
    OR
    category IS NULL
    OR 
    quantiy IS NULL
    OR 
    cogs IS NULL
    OR 
    total_sale IS NULL;
    
-- Data_Exploration--
-- How many records we have ?--
SELECT COUNT(*) as total_sales from retail_sales; 
-- Answer is 1987-- 

-- How many unique customers we have?--
SELECT COUNT(DISTINCT customer_id) as unique_customer from retail_sales; 
-- Answer is 155 unique customer are there. 

-- How many distinct catgeories we have ?
SELECT COUNT(DISTINCT category) as distinct_category from retail_sales;
-- Answer is 3

-- Which distinct category ?
SELECT DISTINCT category as distinct_category from retail_sales;
-- Answer is Beauty, clothing, electronic-- 

-- Data Analysis and Business Key Problems--
-- Write a SQL query to retrieve all columns for sales made on '2022-11-05?--
SELECT * FROM retail_sales where sale_date= '2022-11-05'; 
-- Showed all teh cloumns which has the mentioned sale date- 
-- 180	2022-11-05	10:47:00	117	Male	41	Clothing	3	300	129	900
-- 214	2022-11-05	16:31:00	53	Male	20	Beauty	2	30	8.1	60
-- 240	2022-11-05	11:49:00	95	Female	23	Beauty	1	300	123	300
-- 856	2022-11-05	17:43:00	102	Male	54	Electronics	4	30	9.3	120
-- 943	2022-11-05	19:29:00	90	Female	57	Clothing	4	300	318	1200
-- 1137	2022-11-05	22:34:00	104	Male	46	Beauty	2	500	145	1000
-- 1256	2022-11-05	09:58:00	29	Male	23	Clothing	2	500	190	1000
-- 1265	2022-11-05	14:35:00	86	Male	55	Clothing	3	300	111	900
-- 1587	2022-11-05	20:06:00	140	Female	40	Beauty	4	300	105	1200
-- 1819	2022-11-05	20:44:00	83	Female	35	Beauty	2	50	13.5	100
-- 1896	2022-11-05	20:19:00	87	Female	30	Electronics	2	25	30.75	50

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4; 
    
    
-- Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1; 

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT round(avg(age),2) as Average_age
FROM retail_sales
where category='Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * 
FROM retail_sales
where 
total_sale>1000.0; 

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
		year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank 
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1; 

-- **Write a SQL query to find the top 5 customers based on the highest total sales **:
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;


-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift


 






 
 
            