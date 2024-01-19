-- inspecting
SELECT COUNT(DISTINCT(order_id)) "Number of Unique Orders",
       COUNT(DISTINCT(customer_id)) "Number of Unique Customers"
FROM store;

-- normalizing
CREATE TABLE customers AS
SELECT DISTINCT customer_id, customer_phone, customer_email
FROM store;

ALTER TABLE customers
ADD PRIMARY KEY(customer_id);

ALTER TABLE customers
RENAME COLUMN customer_id TO id;
ALTER TABLE customers
RENAME COLUMN customer_phone TO phone;
ALTER TABLE customers
RENAME COLUMN customer_email TO email;


CREATE TEMP TABLE temp_store AS
SELECT *
FROM
(
    SELECT order_id, order_date, customer_id, customer_email, customer_phone, item_1_id "item_id", item_1_name "item_name", item_1_price "item_price"
    FROM store
    UNION ALL
    SELECT order_id, order_date, customer_id, customer_email, customer_phone, item_2_id "item_id", item_2_name "item_name", item_2_price "item_price"
    FROM store
    UNION ALL
    SELECT order_id, order_date, customer_id, customer_email, customer_phone, item_3_id "item_id", item_3_name "item_name", item_3_price "item_price"
    FROM store
) AS temp_store
WHERE item_id IS NOT NULL;


CREATE TABLE items AS
SELECT DISTINCT item_id id, item_name name, item_price price
FROM temp_store
WHERE item_id IS NOT NULL;

ALTER TABLE items
ADD PRIMARY KEY(id);


CREATE TABLE orders_items AS
SELECT order_id, item_id
FROM temp_store;

CREATE TABLE orders AS
SELECT DISTINCT order_id id, order_date date, customer_id
FROM temp_store;

ALTER TABLE orders
ADD PRIMARY KEY(id);

ALTER TABLE orders
ADD FOREIGN KEY (customer_id) REFERENCES customers(id);


ALTER TABLE orders_items
ADD FOREIGN KEY (order_id) REFERENCES orders(id);
ALTER TABLE orders_items
ADD FOREIGN KEY (item_id) REFERENCES items(id);

-- playing around
SELECT order_date, customer_email
FROM store
WHERE order_date > '2019-07-25';

SELECT date, email
FROM orders o, customers c
WHERE customer_id = c.id AND date > '2019-07-25';

SELECT item_id, MIN(item_name) name, COUNT(*)
FROM temp_store
GROUP BY item_id
ORDER BY COUNT(*) DESC;

SELECT i.id, MIN(name) name, COUNT(order_id)
FROM items i, orders_items
WHERE i.id = item_id
GROUP BY i.id
ORDER BY COUNT(order_id) DESC;