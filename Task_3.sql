create database pizza;

use pizza;

-- A. SELECT, WHERE, ORDER BY, GROUP BY
-- Example: Get all revenue entries above $100, ordered by amount descending
SELECT * FROM revenue
WHERE amount > 10
ORDER BY amount DESC;

-- B. GROUP BY: Total revenue per payment method
SELECT payment_method, SUM(amount) AS total_revenue
FROM revenue
GROUP BY payment_method;

-- C. INNER JOIN: Combine pizza sales with revenue
SELECT ps.pizza_type, r.amount
FROM pizza_sales ps
INNER JOIN revenue r ON ps.sale_id = r.sale_id;

-- D. LEFT JOIN: Customers with and without pizza sales
SELECT c.name, ps.pizza_type
FROM customers c
LEFT JOIN pizza_sales ps ON c.customer_id = ps.customer_id;

-- E. Subquery: Customers who purchased more than average revenue
SELECT name
FROM customers
WHERE customer_id IN (
    SELECT ps.customer_id
    FROM pizza_sales ps
    JOIN revenue r ON ps.sale_id = r.sale_id
    GROUP BY ps.customer_id
    HAVING SUM(r.amount) > (SELECT AVG(amount) FROM revenue)
);

-- F. Aggregate Functions: Average and sum of revenue
SELECT AVG(amount) AS average_amount, SUM(amount) AS total_amount
FROM revenue;

-- G. Create a view: Monthly revenue
CREATE VIEW monthly_revenue AS
SELECT SUBSTR(date, 1, 7) AS month, SUM(amount) AS total
FROM revenue
GROUP BY month;

-- H. Total revenue by delivery zone (multi-table JOIN)
SELECT a.delivery_zone, SUM(r.amount) AS zone_revenue
FROM revenue r
JOIN pizza_sales ps ON r.sale_id = ps.sale_id
JOIN customers c ON ps.customer_id = c.customer_id
JOIN area a ON c.area_id = a.area_id
GROUP BY a.delivery_zone;

-- I. Indexes for optimization
CREATE INDEX idx_sale_id_revenue ON revenue(sale_id);
CREATE INDEX idx_sale_id_pizza_sales ON pizza_sales(sale_id);
CREATE INDEX idx_customer_id_sales ON pizza_sales(customer_id);
CREATE INDEX idx_customer_id_customers ON customers(customer_id);
CREATE INDEX idx_area_id_customers ON customers(area_id);
