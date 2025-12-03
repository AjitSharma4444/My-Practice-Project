
-- Basic Query: -
-- Q 1. What SQL query would you write to select the 2nd highest salary in the manufacturing department?
USE Employment_Details;
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
            emotion = 'Bored'). How would you write a SQL query to get the average order value by gender using customer and transaction tables?
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

use payments_data;

SELECT 
Product_id, Product_name, sum(order_quantity) Total_orders, avg(order_quantity) Average_orders,
case
	when years is null then 2024 else years end as whole_year, order_status  
FROM 
(select a.order_id, a.product_id, a.product_name, a.order_quantity, a.years, b.customer_id, b.customer_name, b.order_status
from
(select order_items.order_id, order_items.product_id, products.product_name, order_items.quantity as order_quantity, year(orders.order_date) as years
FROM payments_data.order_items
join orders on order_items.order_id = orders.order_id
join products on order_items.product_id = products.product_id) as a

join
(
SELECT orders.order_id, orders.customer_id, customers.name as customer_name, orders.order_status
FROM orders
join customers on customers.customer_id = orders.customer_id) as b
ON a.order_id = b.order_id) as c
group by product_id, years, product_name, order_status
order by average_orders desc
;
-- Q 6. How do you calculate the average revenue per client using a payments table with multiple product types?

use export_performance_analysis;
select products.product_category, format(sum(transactions.total_price),'c2', 'e-IN') Total_transaction, format(avg(transactions.total_price),'c2', 'e-IN') Avg_Transactions
from transactions
join products
on products.product_id = transactions.product_id
group by customer_id, product_category
order by customer_id, total_transaction desc;

select concat(transactions.customer_id,'_', customers.customer_name) Customer, format(sum(transactions.total_price),'c2', 'e-IN') Total_transaction, format(avg(transactions.total_price),'c2', 'e-IN') Avg_Transactions
from transactions
join products
on products.product_id = transactions.product_id
join customers
on customers.customer_id = transactions.customer_id
group by Customer
order by total_transaction desc;

-- Q 7. How would you find the average duration of all Uber rides per user, in minutes?
use uber_dataset;
select customer_id, round(avg(timestampdiff(second, start_date, end_date))) Avg_sec,
sec_to_time(round(avg(timestampdiff(second, start_date, end_date)))) Avg_duration 
from uber_dataset
group by customer_id
;
-- Additional reference
-- select Booking_id, Customer_id, date_format(start_date, '%H:%i:%s') Pickup_time, date_format(end_date, '%H:%i:%s') Dropoff_time, 		date_format(timediff(end_date, start_date),'%H:%i:%s') Duration
-- from uber_dataset
-- where customer_id = 'CID8137475'

-- Q 8. What SQL query would you write to answer multiple transaction-related questions from an annual_payments table?

use payments_data;

select year(payment_date) Years, concat('₹', format(sum(amount_paid), 'C2'))Amount_Paid
from payments
group by year(payment_date)
order by Years;

