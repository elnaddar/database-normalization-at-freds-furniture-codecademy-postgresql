-- inspecting
SELECT COUNT(DISTINCT(order_id)) "Number of Unique Orders",
       COUNT(DISTINCT(customer_id)) "Number of Unique Customers"
FROM store;