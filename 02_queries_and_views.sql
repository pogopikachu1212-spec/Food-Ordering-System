-- Food Ordering System: CRUD operations, reports and views
-- Run after 01_schema.sql and after loading sample data.

-- CREATE: register a customer
INSERT INTO customers (full_name,email,phone,address)
VALUES ('Priya Sharma','priya.sharma@example.com','9876500044','101, Sector 15');

-- READ: list available menu items
SELECT item_id, item_name, price FROM menu_items WHERE is_available = 1;

-- UPDATE: change an order status
UPDATE orders SET status = 'Preparing' WHERE order_id = 4;

-- UPDATE: mark an item unavailable
UPDATE menu_items SET is_available = 0 WHERE item_id = 2;

-- DELETE: remove an order (its lines and payment are deleted by CASCADE)
DELETE FROM orders WHERE order_id = 5;

9.3 Queries and Results
Query 1: Menu by category (JOIN). Lists all available items with their category.
SELECT c.category_name, m.item_name, m.price
FROM menu_items m JOIN categories c ON c.category_id = m.category_id
WHERE m.is_available = 1
ORDER BY c.category_name, m.item_name;


Query 2: Bill of an order (multi-table JOIN). Shows each line of order 1 with its line total.
SELECT o.order_id, m.item_name, oi.quantity, oi.unit_price,
(oi.quantity * oi.unit_price) AS line_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN menu_items  m  ON m.item_id   = oi.item_id
WHERE o.order_id = 1;


Query 3: Customer spending (GROUP BY and HAVING). Finds customers whose non-cancelled orders total more than 400.
SELECT c.full_name, COUNT(o.order_id) AS orders_placed,
SUM(o.total_amount) AS total_spent
FROM customers c JOIN orders o ON o.customer_id = c.customer_id
WHERE o.status <> 'Cancelled'
GROUP BY c.customer_id, c.full_name
HAVING SUM(o.total_amount) > 400
ORDER BY total_spent DESC;


Query 4: Search (LIKE). Finds menu items whose name or description contains a keyword.
SELECT item_id, item_name, price FROM menu_items
WHERE item_name LIKE '%paneer%' OR description LIKE '%paneer%';


Query 5: Pending payments (JOIN with filter). Lists orders whose payment is still pending.
SELECT o.order_id, c.full_name, p.method, p.amount
FROM payments p
JOIN orders o    ON o.order_id    = p.order_id
JOIN customers c ON c.customer_id = o.customer_id
WHERE p.payment_status = 'Pending';


9.4 View for Order Summary
A view hides the join logic and gives the application a simple, read-only summary of every order. A LEFT JOIN is used so that an order without a payment row would still appear.
CREATE OR REPLACE VIEW v_order_summary AS
SELECT o.order_id, c.full_name, o.order_date, o.status, o.total_amount,
p.method, p.payment_status
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
LEFT JOIN payments p ON p.order_id = o.order_id;

SELECT * FROM v_order_summary ORDER BY order_id;
