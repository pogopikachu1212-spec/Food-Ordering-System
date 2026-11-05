-- Food Ordering System database schema
-- Source: Chapter 9 of the accompanying project report

CREATE DATABASE IF NOT EXISTS food_ordering;
USE food_ordering;
CREATE TABLE customers (
customer_id  INT AUTO_INCREMENT PRIMARY KEY,
full_name    VARCHAR(100) NOT NULL,
email        VARCHAR(120) NOT NULL UNIQUE,
phone        VARCHAR(15)  NOT NULL,
address      VARCHAR(255) NOT NULL,
created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE categories (
category_id    INT AUTO_INCREMENT PRIMARY KEY,
category_name  VARCHAR(60) NOT NULL UNIQUE
);
CREATE TABLE menu_items (
item_id       INT AUTO_INCREMENT PRIMARY KEY,
category_id   INT NOT NULL,
item_name     VARCHAR(100) NOT NULL,
description   VARCHAR(255),
price         DECIMAL(8,2) NOT NULL CHECK (price > 0),
is_available  TINYINT(1) NOT NULL DEFAULT 1,
CONSTRAINT fk_item_category FOREIGN KEY (category_id)
REFERENCES categories(category_id)
);
CREATE TABLE orders (
order_id         INT AUTO_INCREMENT PRIMARY KEY,
customer_id      INT NOT NULL,
order_date       DATETIME DEFAULT CURRENT_TIMESTAMP,
status           ENUM('Placed','Preparing','Out for Delivery',
'Delivered','Cancelled') NOT NULL DEFAULT 'Placed',
delivery_address VARCHAR(255) NOT NULL,
total_amount     DECIMAL(10,2) NOT NULL DEFAULT 0.00,
CONSTRAINT fk_order_customer FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
);
CREATE TABLE order_items (
order_item_id  INT AUTO_INCREMENT PRIMARY KEY,
order_id       INT NOT NULL,
item_id        INT NOT NULL,
quantity       INT NOT NULL CHECK (quantity > 0),
unit_price     DECIMAL(8,2) NOT NULL,
CONSTRAINT uq_order_item UNIQUE (order_id, item_id),
CONSTRAINT fk_oi_order FOREIGN KEY (order_id)
REFERENCES orders(order_id) ON DELETE CASCADE,
CONSTRAINT fk_oi_item FOREIGN KEY (item_id)
REFERENCES menu_items(item_id)
);
CREATE TABLE payments (
payment_id      INT AUTO_INCREMENT PRIMARY KEY,
order_id        INT NOT NULL UNIQUE,
method          ENUM('Cash','UPI','Card') NOT NULL,
amount          DECIMAL(10,2) NOT NULL,
payment_status  ENUM('Pending','Paid','Failed') NOT NULL DEFAULT 'Pending',
paid_at         DATETIME NULL,
CONSTRAINT fk_pay_order FOREIGN KEY (order_id)
REFERENCES orders(order_id) ON DELETE CASCADE
);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_items_category  ON menu_items(category_id);
