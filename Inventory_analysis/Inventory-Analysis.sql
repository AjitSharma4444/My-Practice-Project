-- 1. Inventory_Turnover Ratio & COGS:
-- 2. Days Sales of Inventory (DSI):
-- (a.)
USE test_db;
SELECT 
    *,
    (Beginning_Inventory + Purchases_or_COGM - Ending_Inventory) Calculated_COGS
FROM
    cost_of_goods;
SELECT 
    *,
    ROUND(((Beginning_Inventory + Ending_Inventory) / 2),
            2) Avg_inventory,
    ROUND((COGS / ((Beginning_Inventory + Ending_Inventory) / 2)),
            2) Turnover_Ratio,
    ROUND((365 / (COGS / ((Beginning_Inventory + Ending_Inventory) / 2))),
            2) Days_to_Sell_DSI
FROM
    inventory_turnover;

-- (b.)
SELECT 
    Product_Name, 
    DSI,
    CASE 
        WHEN DSI > 100 THEN 'OVERSTOCKED'
        ELSE 'OPTIMIZED'
    END AS Status
FROM inventory_performance;
    
-- 3. Inventory Accuracy
-- (Accurate Count Items / Total Items) × 100

SELECT 
    *,
    (physical_count - system_qty) AS Variance,
    IF(system_qty = physical_count, 'ACCURATE', 'MISMATCH') AS Status,
    -- This calculates the 60% and shows it on every row without Error 1140
    (SUM(IF(system_qty = physical_count, 1, 0)) OVER() / COUNT(*) OVER()) * 100 AS Total_Accuracy_pct
FROM inventory_accuracy;

-- 4 Stockout Rate
-- (Stockout Events / Total Orders) × 100
use test_db;
-- (a.) Stockout Rate - overall
SELECT 
    (SUM(Stockout_Event) / COUNT(*)) * 100 AS Overall_Stockout_Rate
FROM stockout_rate;

-- (b.) Stockout Rate  - for each product
SELECT
    Item_Ordered, 
    AVG(Stockout_Event) * 100 AS Stockout_Rate_Percentage
FROM stockout_rate
GROUP BY Item_Ordered;

-- 5. Fill Rate	
-- (Orders Fulfilled Complete / Total Orders) × 100
USE test_db;
SELECT 
    (SUM(CASE WHEN Order_Status = 'Shipped' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS Fill_Rate
FROM stockout_rate;

-- 6. Cycle Count Accuracy
-- Periodic physical counts vs. recorded inventory
USE test_db;
SELECT *,  round((Physical_Count_B/System_Record_A)*100,2) as Accuracy_percent
FROM cycle_count_accuracy;

-- 7. Order Cycle Time
-- Days from order placement to delivery
USE test_db;
SELECT *, (Delivery_Date-Order_Date) Cycle_time 
FROM order_cycle_time;

-- 7 Safety Stock Level
-- Buffer inventory for demand/supply variability
