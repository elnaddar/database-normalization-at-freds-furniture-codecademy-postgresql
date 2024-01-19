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