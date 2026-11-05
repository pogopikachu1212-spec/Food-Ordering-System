-- Example order transaction from the project report.
-- Requires customer_id 2 and menu item IDs 5 and 8 to exist.

START TRANSACTION;

INSERT INTO orders (customer_id, delivery_address)
VALUES (2, '45, Phase 7, Mohali');
SET @oid = LAST_INSERT_ID();

INSERT INTO order_items (order_id, item_id, quantity, unit_price)
SELECT @oid, item_id, 2, price FROM menu_items WHERE item_id = 5;
INSERT INTO order_items (order_id, item_id, quantity, unit_price)
SELECT @oid, item_id, 1, price FROM menu_items WHERE item_id = 8;

UPDATE orders
SET total_amount = (SELECT SUM(quantity * unit_price)
FROM order_items WHERE order_id = @oid)
WHERE order_id = @oid;

INSERT INTO payments (order_id, method, amount)
SELECT order_id, 'UPI', total_amount FROM orders WHERE order_id = @oid;

COMMIT;
