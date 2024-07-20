/*1. Which cities and states generate the highest revenue and number of orders?*/
WITH orders_with_value AS(      --create cte with order id and the total price
    SELECT order_id, SUM(payment_value) AS orderprice
    FROM order_payments
    GROUP BY order_id
)
SELECT customer_city,customer_state,SUM(orders_with_value.orderprice) AS totalrev
FROM orders
JOIN customers ON customers.customer_id=orders.customer_id
JOIN orders_with_value ON orders_with_value.order_id=orders.order_id
GROUP BY customer_city,customer_state
ORDER BY totalrev DESC;     --sort by revenue

SELECT customer_city,customer_state,COUNT(order_id) AS totalorders
FROM orders
JOIN customers ON customers.customer_id=orders.customer_id
GROUP BY customer_city,customer_state
ORDER BY totalorders DESC;     --sort by the number of orders


/*2. Which product categories are the most popular, and which are not selling well?*/
WITH product_sold AS(        --count the number of times each product is sold
    SELECT product_id,count(1) AS numsold
    FROM order_items
    GROUP BY product_id
), producttranslation AS(        --add english translations to products
    SELECT product_id,product_category_name_english
    FROM products
    LEFT JOIN product_category_name_translation AS pct ON pct.product_category_name=products.product_category_name
)
SELECT product_category_name_english, SUM(numsold)
FROM product_sold
LEFT JOIN producttranslation ON producttranslation.product_id=product_sold.product_id
GROUP BY product_category_name_english
ORDER BY SUM(numsold) DESC
;


/*3. What is the relationship between time and revenue?*/
WITH orders_with_value AS(
    SELECT order_payments.order_id, SUM(payment_value) AS orderprice
    FROM order_payments
    GROUP BY order_payments.order_id
)
SELECT 
    EXTRACT(MONTH FROM order_purchase_timestamp) AS month ,
    EXTRACT(YEAR FROM order_purchase_timestamp) AS year ,
    COUNT(orders.order_id) AS totalorders,SUM(orderprice) AS totalrev
FROM orders
JOIN orders_with_value ON orders_with_value.order_id=orders.order_id
GROUP BY year,month
ORDER BY year,month;


/*4. When are customers most likely to place orders?*/
WITH orders_with_value AS(
    SELECT order_payments.order_id, SUM(payment_value) AS orderprice
    FROM order_payments
    GROUP BY order_payments.order_id
)
SELECT 
    COUNT(orders.order_id) AS totalorders,SUM(orderprice) AS totalrev,
    CASE
        WHEN TO_CHAR(order_purchase_timestamp, 'HH24:MI:SS') BETWEEN '05:00:00' AND '12:00:00' THEN 'Morning'
        WHEN TO_CHAR(order_purchase_timestamp, 'HH24:MI:SS') BETWEEN '12:00:00' AND '18:00:00' THEN 'Afternoon'
        WHEN TO_CHAR(order_purchase_timestamp, 'HH24:MI:SS') BETWEEN '18:00:00' AND '24:00:00' THEN 'Night'
        ELSE 'MidNight'
    END AS timeofday
FROM orders
JOIN orders_with_value ON orders_with_value.order_id=orders.order_id
GROUP BY timeofday;



/*5. What's the average delivery time,
and are there delayed packages?*/
WITH deliverytable AS (
    SELECT 
        customer_city, customer_state,
        EXTRACT (DAY FROM(order_delivered_customer-order_purchase_timestamp) )AS deliverytime,
        order_purchase_timestamp,
        order_delivered_customer,
        order_estimated_delivery,
        EXTRACT (DAY FROM(order_estimated_delivery-order_purchase_timestamp)) AS estimateddelivery
    FROM orders
    JOIN customers ON customers.customer_id=orders.customer_id
    WHERE order_delivered_customer IS NOT NULL
)
SELECT 
    AVG(deliverytime) AS avg_delivery,
    MAX(deliverytime) AS max_delivery,
    MIN(deliverytime) AS min_delivery
FROM deliverytable;
