-- Find column data type for all tables in a active schema
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    SUM(CASE WHEN IS_NULLABLE = 'NO' THEN 1 ELSE 0 END) OVER(PARTITION BY TABLE_NAME) AS non_null_columns_count
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'northwind'
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- Basic Query: -
-- Q 1. What SQL query would you write to select the 2nd highest salary in the manufacturing department?
use Employment_Details;
SELECT Emp_Name, Department, Annual_Salary,Rank_number
FROM(
	select concat(First_Name, '_' , Last_Name) as Emp_Name, First_Name, Last_Name, Gender, 
Start_Date, Years_Experience, Department, Country, Center, Monthly_Salary, Annual_Salary, Job_Rate, Sick_Leaves, Unpaid_Leaves, Overtime_Hours,
dense_rank() over(partition by department order by annual_salary desc) as Rank_number 
from employment_details) as Emp_details
where department = 'Manufacturing' and Rank_number = 2;

-- Q 2. How would you calculate the overall acceptance rate of friend requests using SQL?
SELECT 
    COUNT(CASE
        WHEN status = 'accepted' THEN 1
    END) * 1.0 / COUNT(*) AS acceptance_rate
FROM
    friend_requests;

-- Q 3. Which SQL query would return users who were at some point “Excited” and have never been “Bored”?

SELECT DISTINCT
    user_id
FROM
    emotions
WHERE
    emotion = 'Excited'
        AND user_id NOT IN (SELECT 
            user_id
        FROM
            emotions
        WHERE
            emotion = 'Bored');
-- Q 4. How would you write a SQL query to get the average order value by gender using customer and transaction tables?
use payments_data;
-- additional task performed
-- SET SQL_SAFE_UPDATES = 0;
-- UPDATE customers
-- SET gender = "Female"
-- WHERE TRIM(gender) = "female";
-- SET SQL_SAFE_UPDATES = 1
SELECT 
    c.gender, AVG(p.amount_paid) AS average_order_value
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
        JOIN
    payments p ON o.order_id = p.order_id
GROUP BY c.gender;

-- Q 5. What query would you use to find the average quantity of each product purchased per transaction each year?

USE payments_data;
SELECT 
    Product_id,
    Product_name,
    SUM(order_quantity) Total_orders,
    AVG(order_quantity) Average_orders,
    CASE
        WHEN years IS NULL THEN 2024
        ELSE years
    END AS whole_year,
    order_status
FROM
    (SELECT 
        a.order_id,
            a.product_id,
            a.product_name,
            a.order_quantity,
            a.years,
            b.customer_id,
            b.customer_name,
            b.order_status
    FROM
        (SELECT 
        order_items.order_id,
            order_items.product_id,
            products.product_name,
            order_items.quantity AS order_quantity,
            YEAR(orders.order_date) AS years
    FROM
        payments_data.order_items
    JOIN orders ON order_items.order_id = orders.order_id
    JOIN products ON order_items.product_id = products.product_id) AS a
    JOIN (SELECT 
        orders.order_id,
            orders.customer_id,
            customers.name AS customer_name,
            orders.order_status
    FROM
        orders
    JOIN customers ON customers.customer_id = orders.customer_id) AS b ON a.order_id = b.order_id) AS c
GROUP BY product_id , years , product_name , order_status
ORDER BY average_orders DESC
;
-- Q 6. How do you calculate the average revenue per client using a payments table with multiple product types?

use export_performance_analysis;
SELECT 
    products.product_category,
    FORMAT(SUM(transactions.total_price),
        'c2',
        'e-IN') Total_transaction,
    FORMAT(AVG(transactions.total_price),
        'c2',
        'e-IN') Avg_Transactions
FROM
    transactions
        JOIN
    products ON products.product_id = transactions.product_id
GROUP BY customer_id , product_category
ORDER BY customer_id , total_transaction DESC;

SELECT 
    CONCAT(transactions.customer_id,
            '_',
            customers.customer_name) Customer,
    FORMAT(SUM(transactions.total_price),
        'c2',
        'e-IN') Total_transaction,
    FORMAT(AVG(transactions.total_price),
        'c2',
        'e-IN') Avg_Transactions
FROM
    transactions
        JOIN
    products ON products.product_id = transactions.product_id
        JOIN
    customers ON customers.customer_id = transactions.customer_id
GROUP BY Customer
ORDER BY total_transaction DESC;

-- Q 7. How would you find the average duration of all Uber rides per user, in minutes?
USE uber_dataset;
SELECT 
    customer_id,
    ROUND(AVG(TIMESTAMPDIFF(SECOND,
                start_date,
                end_date))) Avg_sec,
    SEC_TO_TIME(ROUND(AVG(TIMESTAMPDIFF(SECOND,
                        start_date,
                        end_date)))) Avg_duration
FROM
    uber_dataset
GROUP BY customer_id
;
-- Additional reference
-- select Booking_id, Customer_id, date_format(start_date, '%H:%i:%s') Pickup_time, date_format(end_date, '%H:%i:%s') Dropoff_time, 		date_format(timediff(end_date, start_date),'%H:%i:%s') Duration
-- from uber_dataset
-- where customer_id = 'CID8137475'

-- Q 8. What SQL query would you write to answer multiple transaction-related questions from an annual_payments table?

use payments_data;

SELECT 
    YEAR(payment_date) Years,
    CONCAT('₹', FORMAT(SUM(amount_paid), 'C2')) Amount_Paid
FROM
    payments
GROUP BY YEAR(payment_date)
ORDER BY Years;

-- Q 9. How would you count the number of daily active users by platform for the year 2020?
USE social_media_users;
SELECT
    device_os AS Platform,
    COUNT(DISTINCT user_id) AS Daily_active_users,
    DATE((DATE_FORMAT(timestamp, '%d-%m-%y'))) AS Dates
FROM user_app_interaction_data
WHERE YEAR((DATE_FORMAT(timestamp, '%d-%m-%y'))) = 2020
GROUP BY
    device_os,
    DATE((DATE_FORMAT(timestamp, '%d-%m-%y')))
ORDER BY
    DATE((DATE_FORMAT(timestamp, '%d-%m-%y')));


-- Q 11. What SQL query would return the total distance traveled by each user, in descending order?
USE uber_dataset;
SELECT 
    customer_id, SUM(ride_distance) Total_distance_travelled
FROM
    uber_dataset
GROUP BY customer_id
ORDER BY SUM(ride_distance) DESC;

-- 16. What query would you write to find users who placed less than 3 orders or spent less than $500?

USE sales_data;
SELECT 
    Customer_Name,
    COUNT(Order_ID) AS Number_of_orders,
    SUM(Sales) Total_spent_by_customers
FROM
    sales_data
GROUP BY Customer_Name
HAVING COUNT(Order_ID) < 5
    OR SUM(Sales) < 500;

-- Q 17. How would you find the largest salary by department from an employees table?

USE employment_details;
SELECT 
    Department, MAX(annual_salary) largest_indivisual_salary
FROM
    employment_details
GROUP BY department;

-- Q 21. How would you write a query to find the manager with the largest team size?
USE employment_details;
WITH Manager_details AS(
SELECT manager_id, COUNT(employee_id) Team_size
FROM employees
GROUP BY manager_id
ORDER BY COUNT(employee_id) DESC
LIMIT 1),

Designation_id AS (select employee_id, concat(first_name, ' ', last_name) Emp_Name
FROM employees WHERE employee_id = 100)

SELECT Manager_id, Emp_name Manager_Name, Team_size
FROM Manager_details
JOIN Designation_id on 
Manager_details.manager_id = Designation_id.employee_id;

-- Q 22. What query gets the max quantity purchased for each product per year?
USE sales_data; -- once need to consider blinkit database data
SELECT 
    Category Products_category, -- considered category for in place of product_id to bring costomized output
    YEAR(Order_Date) Years,
    MAX(Quantity) Maximum_Quantity
FROM
    sales_data
GROUP BY Category , YEAR(Order_Date);

-- Q 27. How would you identify whether each product purchase is a user’s first or repeated purchase in that category?
USE sales_data;

WITH RankedPurchases AS (
	SELECT Customer_id, Category, Item_Purchased, Purchase_date,
		CASE
			WHEN ROW_NUMBER() OVER(PARTITION BY customer_id, category
				ORDER BY purchase_date) = 1 THEN 'First Purchase'
			ELSE 'Repeat Purchase'
		END AS Purchase_Type
	FROM purchases)
SELECT 
    Category,
    Customer_ID,
    YEAR(Purchase_date),
    Purchase_Type,
    COUNT(*) AS Total_Transactions
FROM
    RankedPurchases
GROUP BY Customer_ID , Purchase_Type , Category, YEAR(purchase_date)
ORDER BY Customer_ID ASC , Purchase_Type , Category , YEAR(purchase_date) ASC, Total_Transactions asc;

-- Q 28. What query would select all entries from the flights table?
USE airline_dataset;
SELECT 
    *
FROM
    flights;

-- Q 32. What query would return all rides longer than two hours, sorted by duration?
USE uber_dataset;
SELECT 
    Booking_id,
    Customer_id,
    DATE_FORMAT(TIMEDIFF(end_date, start_date),
            '%H:%i:%s') Duration
FROM
    uber_dataset
WHERE
    DATE_FORMAT(TIMEDIFF(end_date, start_date),
            '%H:%i:%s') >= '02:00:00'
ORDER BY DATE_FORMAT(TIMEDIFF(end_date, start_date),
        '%H:%i:%s');
        
-- Q 33. How would you calculate the total salary of all employees in the company?

USE employment_details;
SELECT 
    SUM(annual_salary) Total_Salary_of_all_Employees
FROM
    employment_details;
    
-- Q 35. How would you calculate total transaction costs by user, ordered by highest spender?
USE sales_data;

SELECT 
    Customer_ID, SUM(Purchase_Amount_USD) Total_Costs
FROM
    purchases
GROUP BY customer_id
ORDER BY SUM(Purchase_Amount_USD) DESC;

-- Q 39. Which products have a product price strictly greater than their own average transaction total?

USE sales_data;
SELECT 
    Item_Purchased,
    MAX(Purchase_amount_usd),
    AVG(purchase_amount_usd)
FROM
    purchases
GROUP BY item_purchased
HAVING MAX(purchase_amount_usd) > AVG(purchase_amount_usd)
ORDER BY MAX(Purchase_amount_usd) desc, AVG(purchase_amount_usd) desc;

-- Q 44. Which user has the highest average number of unique item categories per order?
-- This question emphasizes hierarchical aggregation. 
-- Count unique item categories per order, then average per user, then find the max. 
USE sql_python_ecommerce_project;
WITH OrderCategoryCount AS (  
	SELECT orders.customer_id, order_items.order_id, COUNT(DISTINCT categories.product_category_name_english) AS unique_categories_in_order
    FROM order_items 
    JOIN orders ON order_items.order_id = orders.order_id
    JOIN products ON order_items.product_id = products.product_id
    JOIN categories ON products.product_category_name = categories.product_category_name
    GROUP BY orders.customer_id, order_items.order_id
)
SELECT 
	customer_id, AVG(unique_categories_in_order) AS avg_unique_categories_per_order
FROM OrderCategoryCount
GROUP BY customer_id
ORDER BY avg_unique_categories_per_order DESC
LIMIT 1;

-- Q 46. How can we create a pivot table showing total sales per branch by year?
USE time_series_data;
-- solve: 1. 
SELECT 
    year, branch, ROUND(SUM(sales), 2) Total_Sales
FROM
    store_sales_data
GROUP BY branch , year;

-- solve: 2.
-- SELECT
-- branch,
-- SUM(CASE WHEN YEAR(date) = 2022 THEN amount ELSE 0 END) AS sales_2022,
-- SUM(CASE WHEN YEAR(date) = 2023 THEN amount ELSE 0 END) AS sales_2023
-- FROM store_sales_data
-- GROUP BY
-- branch;

-- Q 55. What is the cumulative sales per product over time, sorted by product_id and date?
USE sales_data;
SELECT order_date, Product_name, Sales, 
SUM(Sales) OVER (PARTITION BY Product_Name ORDER BY Order_Date) AS Cummulative_Sales
FROM sales_data
ORDER BY Product_Name, Order_Date;

-- Q 57. Which customers placed more than 3 transactions in both 2019 and 2020?
USE export_performance_analysis;
WITH cte AS(
SELECT DISTINCT
    transaction_id, transaction_date, customer_id
FROM
    transactions
WHERE year(transaction_date) between 2019 and 2020)
SELECT 
    customer_id, YEAR(transaction_date), COUNT(transaction_id)
FROM
    cte
GROUP BY customer_id, year(transaction_date)
HAVING count(transaction_id) > 3
ORDER BY customer_id ASC;

-- Q 60. Which duplicate rows exist in the users table?

USE sales_data;
SELECT * 
FROM (SELECT User_ID, Cust_name,
		ROW_NUMBER() OVER (PARTITION BY User_ID ORDER BY User_ID) AS Duplicate_row_No
	  FROM cx_details) t
WHERE Duplicate_row_No > 1;

-- Q 64. Which employees joined before their respective managers?
use employment_details;
with cte as
(select employees.employee_id, concat(employees.first_name, ' ', employees.last_name) Employee_Name, 
employees.hire_date, manager_table.Manager_id, manager_table.Manager, manager_table.join_date
from (WITH Designation_id AS (select employee_id, concat(first_name, ' ', last_name) Emp_Name, hire_date 
FROM employees),
Manager_list as (select distinct manager_id from employees where manager_id > 0)
select Manager_id, Emp_Name Manager, hire_date join_date
from Designation_id join Manager_list on 
Designation_id.employee_id = Manager_list.manager_id) as Manager_table
right join employees on
employees.manager_id = Manager_table.manager_id)
select *, GREATEST( join_date, hire_date) as Old_hired_date_employee_or_Manager from cte 
WHERE GREATEST( join_date, hire_date) = hire_date;

-- Q 67. How many unpurchased seats exist per flight, given flights, planes, and flight_purchases tables?
WITH AircraftCapacity AS (
    -- Calculate capacity once per aircraft type
    SELECT aircraft_code, COUNT(*) AS total_seats
    FROM seats
    GROUP BY aircraft_code
)
SELECT 
    f.flight_id,
    f.flight_no,
    ac.total_seats AS total_capacity,
    COUNT(tf.ticket_no) AS seats_purchased,
    (ac.total_seats - COUNT(tf.ticket_no)) AS unpurchased_seats
FROM flights f
JOIN AircraftCapacity ac ON f.aircraft_code = ac.aircraft_code
LEFT JOIN ticket_flights tf ON f.flight_id = tf.flight_id
GROUP BY f.flight_id, f.flight_no, ac.total_seats;

-- Q 69. What are the total regular salaries, overtime pay, and compensations by role?
USE employment_details;
SELECT 
    Job, 
    round(SUM(salaries),2) AS Total_Regular_Salaries, 
    round(SUM(overtime),2) AS Total_Overtime_Pay,
    round(SUM(salaries + retirement + health_and_dental + other_benefits),2) AS Total_Compensation
FROM employee_salary_compensation
GROUP BY job
ORDER BY total_compensation DESC;

-- Q 79. How much of each product was sold per month, with products as columns?
USE sales_data;
SELECT 
    category Product_category,
    YEAR(order_date) Sales_Year,
    MONTH(order_date) Sales_Months,
    SUM(quantity) Sales_Amount
FROM
    sales_data
GROUP BY category , MONTH(order_date) , YEAR(order_date)
ORDER BY MONTH(order_date) , YEAR(order_date);

-- Q 78. How many users, transactions, and total order value occurred per month in 2023?

SELECT 
    DISTINCT COUNT(DISTINCT customer_id) AS Total_users, 
    ROUND(SUM(order_total), 2) AS Sum_Total, 
    COUNT(order_id) AS Count_of_orders, 
    MONTH(order_date) AS Month_index, 
    MONTHNAME(order_date) AS Month_name, 
    YEAR(order_date) AS Year_2023
FROM blinkit.blinkit_orders
WHERE YEAR(order_date) = 2023
GROUP BY 
    YEAR(order_date), 
    MONTH(order_date), 
    MONTHNAME(order_date)
ORDER BY 
    YEAR(order_date), 
    MONTH(order_date);
    
-- Q 87. How can you randomly sample a row from a table with over 100 million rows?
USE pizzahut;
-- Step 1: Query for 10 random rows (first add random_weight column)
	-- ALTER TABLE orders 
	-- ADD COLUMN random_weight FLOAT AFTER order_id,
	-- ADD INDEX (random_weight);
	-- SET SQL_SAFE_UPDATES = 0;
	-- UPDATE orders SET random_weight = RAND();
SELECT * FROM orders
WHERE random_weight >= RAND()
ORDER BY random_weight ASC
LIMIT 10;
-- Step 2: Query for 10 random rows
SELECT t.*
FROM orders AS t
JOIN (SELECT ROUND(RAND() * (SELECT MAX(order_id) FROM orders)) AS order_id) AS temp
WHERE t.order_id >= temp.order_id
ORDER BY t.order_id ASC
LIMIT 10;

-- Q 92. How can you sample every 4th row from a transactions table ordered by date?
USE northwind;
WITH ordered AS (
    SELECT
        id,
        customer_id,
        DATE_FORMAT(order_date, '%d-%m-%y') AS orders_date,
        ROW_NUMBER() OVER (ORDER BY order_date) AS rn
    FROM orders
)
SELECT id, customer_id, orders_date, rn
FROM ordered
WHERE rn % 4 = 0;   -- every 4th row

-- Q 93. What percent of search queries had only low-rated results (ratings < 3)?
USE blinkit;
WITH per_query AS (
    SELECT
        order_id,
        MAX(rating) AS max_rating
    FROM blinkit_customer_feedback
    GROUP BY order_id
),
flagged AS (
    SELECT
        COUNT(*) AS all_below_3_queries
    FROM per_query
    WHERE max_rating < 3
)
SELECT
    all_below_3_queries,
    (SELECT COUNT(DISTINCT order_id) FROM blinkit_customer_feedback) AS total_queries,
    all_below_3_queries * 100.0
        / (SELECT COUNT(DISTINCT order_id) FROM blinkit_customer_feedback) AS proportion_below_3
FROM flagged;

-- Q 97. What was each user’s third purchase based on transaction history?
USE blinkit;
WITH Purchase_count AS (
    SELECT 
        customer_id, 
        blinkit_order_items.product_id, 
        blinkit_products.product_name, 
        ROW_NUMBER() OVER(
            PARTITION BY customer_id 
            ORDER BY order_date
        ) AS Transaction_history_no
    FROM blinkit_orders 
    JOIN blinkit_order_items 
        ON blinkit_orders.order_id = blinkit_order_items.order_id
    JOIN blinkit_products 
        ON blinkit_order_items.product_id = blinkit_products.product_id
)
SELECT 
    customer_id, 
    product_id, 
    product_name, 
    CASE 
        WHEN Transaction_history_no = 1 THEN 'First_transaction'
        WHEN Transaction_history_no = 2 THEN 'Second_transaction'
        WHEN Transaction_history_no = 3 THEN 'Third_transaction'
        ELSE 'Regular_Purchases'
    END AS Purchase_category
FROM Purchase_count 
WHERE Transaction_history_no = 3;

-- Q 100. What are the top 3 highest employee salaries by department?
WITH aggregate_data AS (
    SELECT 
        department, 
        employee_id, 
        CONCAT(first_name, "_", last_name) AS Emp_name, 
        salary, 
        DENSE_RANK() OVER(
            PARTITION BY department 
            ORDER BY salary DESC
        ) AS Salary_rank 
    FROM employees
)
SELECT * FROM aggregate_data 
WHERE Salary_rank <= 3;

-- Q 107. What is the 3-day weighted moving average of product sales?
USE time_series_data;
SELECT date, sales,(
        (sales * 0.5) + 
        (COALESCE(LAG(sales, 1) OVER (ORDER BY date), 0) * 0.3) + 
        (COALESCE(LAG(sales, 2) OVER (ORDER BY date), 0) * 0.2)
    ) AS wma_3_day
FROM store_sales_data;

