select * from cleaned_dataset

--Revenue analysis

--1. Total Revenue
select Round(sum(sales),2) as Total_Revenue from cleaned_dataset
-- Total Sales = 3,67,84,735.03

--2.Total Profit
select Round(sum(order_profit_per_order),2) as Total_profit from cleaned_dataset
--Total profit = 39,66,902.98

--3.Revenue Lost to Cancellations
select round(sum(sales),2) as Revenue_Lost_to_Cancellations from cleaned_dataset
where order_status = 'CANCELED'
--Total Revenue lost to cancellation = 7,44,370.40

--4.Average Profit per Order / Average Benefit per Order
SELECT ROUND(AVG(Order_Profit_Per_Order), 2) AS Avg_Profit_per_Order FROM cleaned_dataset
-- The AVG profit per order = 21.97

--5. Profit Margin % per order
select profit_margin_pct from cleaned_dataset

--Delivery performance


--1. Shipping Stats
SELECT
    ROUND(COUNT(CASE WHEN delivery_status = 'Late delivery' THEN 1 END) * 100.0 / COUNT(*),2) AS late_delivery_rate,

    ROUND(COUNT(CASE WHEN delivery_status = 'Shipping on time' THEN 1 END) * 100.0 / COUNT(*),2) AS on_time_delivery_rate,

    ROUND(COUNT(CASE WHEN delivery_status = 'Advance shipping' THEN 1 END) * 100.0 / COUNT(*),2) AS advance_delivery_rate,

	ROUND(COUNT(CASE WHEN delivery_status = 'Shipping canceled' THEN 1 END) * 100.0 / COUNT(*),2) AS cancelled_shipment 
	
	FROM cleaned_dataset
-- Late delivery = 54.83% , On time delivery = 17.84 , Advance shipping = 23.04 , Cancelled shipment = 4.30

--2.Average Shipping Delay 
select round(AVG(shipping_delay_days),2) from cleaned_dataset
-- They get delayed by 0.57 (half a day)

--3.Cancellation rate
SELECT ROUND(COUNT(CASE WHEN delivery_status = 'Shipping canceled' THEN 1 END) * 100.0 / COUNT(*),2) AS cancellation_rate 
from cleaned_dataset
-- The cancellation rate is 4.30%

--4.Late Delivery Rate by Shipping Mode
SELECT shipping_mode,ROUND(COUNT(CASE WHEN delivery_status = 'Late delivery' THEN 1 END) * 100.0 / COUNT(*),2) as late_delivery_by_shipping_mode from cleaned_dataset
group by shipping_mode
order by 2 desc
--First class shiping gets delayed 95.32% of the time.

--5.Late Delivery Rate by market
SELECT market,ROUND(COUNT(CASE WHEN delivery_status = 'Late delivery' THEN 1 END) * 100.0 / COUNT(*),2) as late_delivery_by_market from cleaned_dataset
group by market
order by 2 desc
--Every market gets delayed by almost same percentage

--Customer Behaviour

--1.customer that has high cancellation rate
select customer_id,count(customer_id) as no_of_cancellation, delivery_status from cleaned_dataset
where "delivery_status" = 'Shipping canceled'
group by customer_id , delivery_status 
order by 2 desc

--2.Revenue per Customer Segment
select customer_segment,round(sum(sales),2) as Revenue_per_customer_segment from cleaned_dataset
group by customer_segment
-- Comsumer segment has the highest revenue

--3.Cancellation Rate by Customer Segment
SELECT customer_segment,COUNT(*) AS total_orders,SUM(CASE WHEN "order_status" = 'CANCELED' THEN 1 ELSE 0 END) AS cancelled_orders,
ROUND(SUM(CASE WHEN "order_status" = 'CANCELED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS cancellation_rate
FROM cleaned_dataset
GROUP BY "customer_segment"
ORDER BY cancellation_rate DESC
--All Customer segment cancel equally

--Product analysis

--1.Most Cancelled Product Category
SELECT category_name,COUNT(*) AS total_orders,SUM(CASE WHEN "order_status" = 'CANCELED' THEN 1 ELSE 0 END) AS cancelled_orders
FROM cleaned_dataset
GROUP BY category_name
ORDER BY cancelled_orders DESC
--Cleats are the most cancelled order and followed by Men's Footwear and Women's Appreal

--2.High Discount Impact
SELECT 
    CASE 
        WHEN "order_profit_per_order" < 0 THEN 'Loss Making'
        ELSE 'Profitable'
    END AS profit_category,
    COUNT(*) AS total_orders,
    ROUND(AVG("order_item_discount_rate") * 100, 2) AS avg_discount_rate
FROM cleaned_dataset
GROUP BY profit_category
ORDER BY avg_discount_rate DESC
-- The discounts are not the problem for the loss making dataco

--3.Are loss making orders using more expensive shipping modes?
SELECT 
    CASE WHEN "order_profit_per_order" < 0 THEN 'Loss Making' ELSE 'Profitable' END AS profit_category,
    "shipping_mode",
    COUNT(*) AS total_orders,
    ROUND(AVG("order_profit_per_order"), 2) AS avg_profit
FROM cleaned_dataset
GROUP BY profit_category, "shipping_mode"
ORDER BY profit_category, avg_profit
--Doesnt give a clear picture of loss

-- 4. Are loss making orders from specific markets?
SELECT 
    CASE WHEN "order_profit_per_order" < 0 THEN 'Loss Making' ELSE 'Profitable' END AS profit_category,
    "market",
    COUNT(*) AS total_orders,
    ROUND(AVG("order_profit_per_order"), 2) AS avg_profit
FROM cleaned_dataset
GROUP BY profit_category, "market"
ORDER BY profit_category, avg_profit
--Doesnt give a clear picture of loss

-- 5. Which product categories drive the most losses?
SELECT 
    category_name,
    COUNT(*) AS total_orders,
    ROUND(AVG("order_profit_per_order"), 2) AS avg_profit,
    ROUND(AVG("order_item_discount_rate") * 100, 2) AS avg_discount_rate
FROM cleaned_dataset
WHERE "order_profit_per_order" < 0
GROUP BY category_Name
ORDER BY avg_profit ASC
LIMIT 10;
-- Computers are the loss making product

-- 6. Computers profit breakdown by shipping mode
SELECT 
    shipping_mode,
    COUNT(*) AS total_orders,
    ROUND(AVG("order_profit_per_order"), 2) AS avg_profit,
    ROUND(AVG("order_item_discount_rate") * 100, 2) AS avg_discount_rate,
    ROUND(AVG("product_price"), 2) AS avg_product_price
FROM cleaned_dataset
WHERE "category_name" = 'Computers'
GROUP BY "shipping_mode"
ORDER BY avg_profit ASC
--Standard class shipping is the one with least profit

-- 7. Computers loss vs profit by market
SELECT 
    market,
    COUNT(*) AS total_orders,
    ROUND(SUM("order_profit_per_order"), 2) AS total_profit,
    ROUND(AVG("order_item_discount_rate") * 100, 2) AS avg_discount_rate
FROM cleaned_dataset
WHERE "category_name" = 'Computers'
GROUP BY market
ORDER BY total_profit DESC
--Pacific asia has the lowest profit

--8.Are computers being heavily discounted compared to other categories?
SELECT 
    category_name,
    ROUND(AVG("order_item_discount_rate") * 100, 2) AS avg_discount_rate,
    ROUND(AVG("order_profit_per_order"), 2) AS avg_profit,
    ROUND(AVG("product_price"), 2) AS avg_product_price
FROM cleaned_dataset
GROUP BY category_name
ORDER BY avg_profit ASC

-- 9. Computer orders profit distribution
SELECT
    CASE
        WHEN "order_profit_per_order" < -100 THEN 'Heavy Loss (< -100)'
        WHEN "order_profit_per_order" BETWEEN -100 AND 0 THEN 'Mild Loss (-100 to 0)'
        WHEN "order_profit_per_order" BETWEEN 0 AND 100 THEN 'Low Profit (0 to 100)'
        ELSE 'High Profit (> 100)'
    END AS profit_band,
    COUNT(*) AS total_orders,
    ROUND(AVG("order_item_discount_rate") * 100, 2) AS avg_discount_rate
FROM cleaned_dataset
WHERE "category_name" = 'Computers'
GROUP BY profit_band
ORDER BY total_orders DESC

--10.Compare computer pricing vs selling price to find margin squeeze
SELECT 
    category_name,
    ROUND(AVG("product_price"), 2) AS listed_price,
    ROUND(AVG("order_item_product_price"), 2) AS selling_price,
    ROUND(AVG("order_item_discount_rate") * 100, 2) AS avg_discount_rate,
    ROUND(AVG("order_profit_per_order"), 2) AS avg_profit
FROM cleaned_dataset
WHERE category_name = 'Computers'
GROUP BY category_name
--Computer actually makes 157.59 average profit

-- why computers products are making losses
-- 1. Prove losses happen even with zero discount
SELECT 
    order_item_discount_rate,
    COUNT(*) AS total_orders,
    ROUND(AVG("order_profit_per_order"), 2) AS avg_profit,
    ROUND(MIN("order_profit_per_order"), 2) AS worst_loss,
    ROUND(AVG("sales"), 2) AS avg_sales
FROM cleaned_dataset
WHERE "category_name" = 'Computers'
AND "order_item_discount_rate" = 0
GROUP BY "order_item_discount_rate"

-- 2. Compare computers vs all other categories 
-- to see if computers have uniquely bad profit ratios
SELECT 
    category_name,
    COUNT(*) AS total_orders,
    ROUND(AVG("product_price"), 2) AS avg_product_price,
    ROUND(AVG("order_profit_per_order"), 2) AS avg_profit,
    ROUND(AVG("order_item_profit_ratio") * 100, 2) AS avg_profit_ratio,
    ROUND(SUM(CASE WHEN "order_profit_per_order" < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS loss_order_rate
FROM cleaned_dataset
GROUP BY "category_name"
ORDER BY avg_profit DESC

-- 3. Show the scale of loss — total revenue lost from computers
SELECT
    ROUND(SUM("sales"), 2) AS total_revenue,
    ROUND(SUM("order_profit_per_order"), 2) AS total_profit,
    ROUND(SUM(CASE WHEN "order_profit_per_order" < 0 THEN "order_profit_per_order" ELSE 0 END), 2) AS total_loss_amount,
    COUNT(CASE WHEN "order_profit_per_order" < 0 THEN 1 END) AS loss_orders,
    COUNT(*) AS total_orders
FROM cleaned_dataset
WHERE "category_name" = 'Computers'

--Computer orders generate losses not because of discounting even orders with 0% discount record losses as high as $2,550. 
--The root cause is structural: the product's cost of goods significantly exceeds the $1,500 selling price. 
--DataCo is essentially selling computers below procurement cost, making this a pricing strategy failure rather than a discount control problem.

-- Scheduled vs Actual Shipping Days by Shipping Mode
SELECT 
    shipping_mode,
    ROUND(AVG(days_for_shipping_real), 2) AS avg_actual_days,
    ROUND(AVG(days_for_shipment_scheduled), 2) AS avg_scheduled_days,
    ROUND(AVG(days_for_shipping_real) - AVG(days_for_shipment_scheduled), 2) AS avg_delay_gap
FROM cleaned_dataset
GROUP BY shipping_mode
ORDER BY avg_delay_gap DESC
-- Generally on an average the second class shipment gets delayed by 2 days 

-- Revenue and Profit by Department
SELECT 
    department_name,
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit,
    ROUND(SUM(order_profit_per_order) * 100.0 / SUM(sales), 2) AS profit_margin_pct
FROM cleaned_dataset
GROUP BY department_name
ORDER BY total_revenue DESC
--Fan shop has the highest revenue but fitness has the highest profit margin percentage

-- Late Delivery Rate by Department
SELECT 
    department_name,
    COUNT(*) AS total_orders,
    ROUND(COUNT(CASE WHEN delivery_status = 'Late delivery' THEN 1 END) * 100.0 / COUNT(*), 2) AS late_delivery_rate
FROM cleaned_dataset
GROUP BY department_name
ORDER BY late_delivery_rate DESC
--Late delivery is not a department problem

--Late deliveries are not caused by market, department or order size,they are caused by a systematic mismatch between promised and actual shipping times. 
--First Class shipping promises 1-day delivery but consistently takes 2 days, causing a 95% late delivery rate. 
--The problem is unrealistic scheduling, not operational failure.

-- Cancellation Rate by Market + Customer Segment combined
SELECT 
    market,
    customer_segment,
    COUNT(*) AS total_orders,
    ROUND(SUM(CASE WHEN order_status = 'CANCELED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS cancellation_rate
FROM cleaned_dataset
GROUP BY market, customer_segment
ORDER BY cancellation_rate DESC

-- Full Order Status Breakdown with Revenue
SELECT 
    order_status,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS order_pct,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(AVG(order_profit_per_order), 2) AS avg_profit
FROM cleaned_dataset
GROUP BY order_status
ORDER BY total_orders DESC

-- Rank customers by total spend using window function
WITH customer_revenue AS (
    SELECT 
        customer_id,
        customer_segment,
        ROUND(SUM(sales), 2) AS total_spent
    FROM cleaned_dataset
    GROUP BY customer_id, customer_segment
)
SELECT *,
    RANK() OVER (ORDER BY total_spent DESC) AS revenue_rank,
    RANK() OVER (PARTITION BY customer_segment ORDER BY total_spent DESC) AS segment_rank
FROM customer_revenue
LIMIT 20
--Doesnt tell a significant story for revenue but corporate segment has a slight edge in revenue over others


