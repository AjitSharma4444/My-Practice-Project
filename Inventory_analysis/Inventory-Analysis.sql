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

-- 8 Safety Stock Level
-- Buffer inventory for demand/supply variability
USE test_db;
SELECT *,
--    Scenario, Service_level_percent, Avg_Daily_Demand_Davg​, Demand_Std_Dev_σD​, Avg_Lead_Time_LTavg​_days, LT_Std_Dev_σLT​_days,
    -- Step 1: Map the Service_Level_% to its corresponding Z-score
    CASE 
        WHEN Service_Level_percent = 0.80 THEN 0.841
        WHEN Service_Level_percent = 0.90 THEN 1.282
        WHEN Service_Level_percent = 0.95 THEN 1.645
        WHEN Service_Level_percent = 0.98 THEN 2.054
        WHEN Service_Level_percent = 0.99 THEN 2.326
        WHEN Service_Level_percent = 0.999 THEN 3.090
        ELSE 1.645 -- Default to 95% if not specified
    END AS Z_Score,

    -- Step 2: Implement the full statistical formula
    CEIL(
        CASE 
            WHEN Service_Level_percent = 0.80 THEN 0.841
            WHEN Service_Level_percent = 0.90 THEN 1.282
            WHEN Service_Level_percent = 0.95 THEN 1.645
            WHEN Service_Level_percent = 0.98 THEN 2.054
            WHEN Service_Level_percent = 0.99 THEN 2.326
            WHEN Service_Level_percent = 0.999 THEN 3.090
            ELSE 1.645 
        END * SQRT(
            (Avg_Lead_Time_LTavg​_days * POWER(Demand_Std_Dev_σD​, 2)) + 
            (POWER(Avg_Daily_Demand_Davg​, 2) * POWER(LT_Std_Dev_σLT​_days, 2))
        )
    ) AS Safety_Stock_Result
FROM safety_stock_level;

-- 9. Carrying Cost
-- Storage + Insurance + Depreciation + Opportunity Cost
USE test_db;
SELECT *,
(Storage_$ + Insurance_$ + Depreciation_$ + Opportunity_Cost_$) Total_carrying_cost,
(round((Storage_$ + Insurance_$ + Depreciation_$ + Opportunity_Cost_$ )/ 
Avg_Inventory_Value_$ * 100,2)) Carrying_cost_Percent
FROM carrying_cost_evaluation;

-- 10. Demand Forecast Accuracy
-- |(Actual Demand - Forecasted) / Actual| × 100
USE test_db;
SELECT *, ABS(Forecasted_demand - actual_demand) Absolute_error,
round((1 - ABS(actual_demand - forecasted_demand) / actual_demand) * 100,2) AS accuracy_pct
FROM demand_forecast;

-- 11. Shrinkage Rate
-- (Unaccounted Inventory / Total Inventory) × 100
USE test_db;
SELECT *, (Total_Recorded_Value_$ - Actual_Physical_Value_$) Unaccounted_inventory,
round(((Total_Recorded_Value_$ - Actual_Physical_Value_$)/ Total_Recorded_Value_$ * 100 ),2) Shrinkage_Percent
FROM shrinkage_rate;

-- 12. Stock-to-Sales Ratio
-- Total Inventory / Total Sales
USE test_db;
SELECT *,
round((Beginning_Of_Month_Inventory_$ / Total_Sales_$),2) Stock_to_Sales_Ratio,
CASE 
	WHEN (Beginning_Of_Month_Inventory_$ / Total_Sales_$) > 3.5 THEN 'Overstocked: High carrying costs'
    WHEN (Beginning_Of_Month_Inventory_$ / Total_Sales_$) BETWEEN 3.0 AND 3.5 THEN 'Heavy: Monitor slow-moving items'
    WHEN (Beginning_Of_Month_Inventory_$ / Total_Sales_$) BETWEEN 2.5 AND 3.0 THEN 'Optimal: Healthy stock rotation'
    WHEN (Beginning_Of_Month_Inventory_$ / Total_Sales_$) < 2.5 THEN 'High Efficiency: Risk of stockouts'
    ELSE 'Review Required'
END AS Performance_Comment
FROM stocks_to_sales;

-- 13. ABC Analysis
-- Categorize by value: A (High), B (Medium), C (Low)
USE test_db;
WITH SKU_Totals AS (
    -- Step 1: Calculate Total Value per SKU
    SELECT 
        SKU_ID,
        (Annual_Demand_units * Unit_Cost_$) AS Item_Value
    FROM abc_analysis
),
Running_Totals AS (
    -- Step 2: Calculate Cumulative Value and Total Inventory Value
    SELECT 
        SKU_ID,
        Item_Value,
        SUM(Item_Value) OVER (ORDER BY Item_Value DESC) AS Cumulative_Value,
        SUM(Item_Value) OVER () AS Grand_Total
    FROM SKU_Totals
),
Percentages AS (
    -- Step 3: Calculate the Cumulative Percentage
    SELECT 
        *,
        (Cumulative_Value / Grand_Total) * 100 AS Cumul_Pct
    FROM Running_Totals
)
-- Step 4: Final Categorization
SELECT 
    SKU_ID,
    Item_Value,
    ROUND(Cumul_Pct, 2) AS Cumulative_Percentage,
    CASE 
        WHEN Cumul_Pct <= 80 THEN 'A (High Value/Tight Control)'
        WHEN Cumul_Pct <= 95 THEN 'B (Medium Value/Normal Control)'
        ELSE 'C (Low Value/Simple Control)'
    END AS ABC_Category
FROM Percentages
ORDER BY Item_Value DESC;

-- 14. Just-In-Time (JIT) Compliance
-- % of materials received exactly when needed
USE test_db;

SELECT *,
    CASE 
        WHEN variance_minutes BETWEEN -30 AND 15 THEN '100%'
        ELSE '0%'
    END AS jit_compliance_pct,
    CASE 
        WHEN variance_minutes < -30 THEN 'Early'
        WHEN variance_minutes > 15 THEN 'Late'
        ELSE 'Compliant'
    END AS Status
FROM (
    SELECT *,
        TIMESTAMPDIFF(MINUTE, 
            STR_TO_DATE(Scheduled_Arrival, '%H:%i:%s'), 
            STR_TO_DATE(Actual_Arrival, '%H:%i:%s')
        ) AS variance_minutes
    FROM jit_compliance
) AS t;

-- additional for 24 hours format:
-- 1. Convert Scheduled_Arrival strings to standard TIME format
-- SET sql_safe_updates = 0;
-- UPDATE jit_compliance 
-- SET Scheduled_Arrival = TIME(STR_TO_DATE(Scheduled_Arrival, '%h:%i %p'));

-- -- 2. Convert Actual_Arrival strings to standard TIME format
-- UPDATE jit_compliance 
-- SET Actual_Arrival = TIME(STR_TO_DATE(Actual_Arrival, '%h:%i %p'));

-- 15. Return Rate
-- (Returned Items / Total Sold) × 100
USE test_db;
SELECT 
    *,
    ((Returned_Items / Total_Sold) * 100) Return_Rate_Per,
    CASE
        WHEN ((Returned_Items / Total_Sold) * 100) <= 2 THEN 'Excellent'
        WHEN ((Returned_Items / Total_Sold) * 100) <= 8 THEN 'Normal'
        WHEN ((Returned_Items / Total_Sold) * 100) <= 15 THEN 'High'
        ELSE 'Critical'
    END AS Status
FROM
    return_rate;
    
-- 15. GMROI (Gross Margin ROI)
-- Gross Margin $ / Average Inventory 

USE test_db;
SELECT 
    *,
    (net_sales - cogs) Gross_margin_$,
    ROUND(((net_sales - cogs) / Avg_Inventory_Cost),
            2) GMROI
FROM
    gross_margin_roi;
    
-- 16. Lead Time Variability
-- Standard deviation of supplier delivery times

USE test_db;
SELECT Supplier_Name, ROUND(SUM(Squared_deviation),2), COUNT(*) - 1,
ROUND(SUM(Squared_deviation) / (COUNT(*) - 1),2),
ROUND(sqrt(SUM(Squared_deviation) / (COUNT(*) - 1)),2) Standard_Deviation,
case when sqrt(SUM(Squared_deviation) / (COUNT(*) - 1)) <= 2 then 'Highly Reliable / "Lean" Approved'
	 else 'Volatile / High-Risk' end as Remarks
FROM
(SELECT * FROM
(with Avg_data as (Select Supplier_Name, round(avg(actual_lead_time_days),2) Avg_lead_time,
count(*) n_Number_of_shipments 
from lead_time_variability group by Supplier_Name)

SELECT Shipment_ID,lead_time_variability.Supplier_Name,Promised_Lead_Time_Days,
Actual_Lead_Time_Days, 
(Actual_Lead_Time_Days-Promised_Lead_Time_Days) Variance_Days,
CASE
	WHEN (Actual_Lead_Time_Days-Promised_Lead_Time_Days) = 0 Then "On Time"
    WHEN (Actual_Lead_Time_Days-Promised_Lead_Time_Days) < 0 Then "Early"
    Else "Late" End as Status, Avg_lead_time, n_Number_of_shipments,
    ROUND(POWER((lead_time_variability.Actual_Lead_Time_Days-Avg_data.Avg_lead_time),2),2) Squared_deviation
    FROM lead_time_variability
join Avg_data on lead_time_variability.Supplier_Name=Avg_data.Supplier_Name) AS Filtered_table
order by Shipment_ID) Aggregated_table
GROUP BY Supplier_Name;

-- 17. Perfect Order Rate
-- % of orders delivered on-time, in-full, error-free
USE test_db;
WITH orders AS (
SELECT *, 
CASE
	WHEN Delivered_On_Time = "Yes" AND Delivered_In_Full = "Yes" AND Error_Free = "Yes" THEN "Yes"
    ELSE "No" END AS Perfect_order
FROM perfect_order_rate)
SELECT 
    ROUND(COUNT(CASE WHEN Perfect_Order = 'Yes' THEN 1 END) * 100.0 / COUNT(*),2) AS Perfect_Order_Rate,
    ROUND(COUNT(CASE WHEN Perfect_Order = 'No' THEN 1 END) * 100.0 / COUNT(*),2) AS Failure_Rate
FROM orders;

-- 18 Inventory Holding Cost Ratio
-- Total Holding Cost / Total Inventory Value
USE test_db;
SELECT *, CONCAT(ROUND((Total_Holding_Cost/Total_Inventory_Value)*100,2),"%") Holding_Cost_Ratio,
CASE
	WHEN (Total_Holding_Cost/Total_Inventory_Value) < 0.2 THEN "Efficient"
    WHEN (Total_Holding_Cost/Total_Inventory_Value) < 0.25 THEN "Good"
    WHEN (Total_Holding_Cost/Total_Inventory_Value) < 0.28 THEN "Average"
    WHEN (Total_Holding_Cost/Total_Inventory_Value) < 0.30 THEN "Above Average"
    WHEN (Total_Holding_Cost/Total_Inventory_Value) < 0.35 THEN "High(Style Risk)"
    WHEN (Total_Holding_Cost/Total_Inventory_Value) < 0.4 THEN "High(Risk)"
	ELSE "Very High" END AS Status
FROM inventory_holding_cost_ratio;