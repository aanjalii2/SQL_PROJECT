-- Views for Bookstore Management

-- 1. Book Details View
CREATE OR REPLACE VIEW vw_book_details AS
SELECT 
    b.book_id,
    b.title,
    a.first_name || ' ' || a.last_name AS author_name,
    g.genre_name,
    b.price,
    b.stock,
    COALESCE(AVG(r.rating), 0) as average_rating,
    COUNT(DISTINCT r.review_id) as review_count
FROM Books b
JOIN Authors a ON b.author_id = a.author_id
JOIN Genres g ON b.genre_id = g.genre_id
LEFT JOIN Reviews r ON b.book_id = r.book_id
GROUP BY b.book_id, a.author_id, g.genre_id;

-- 2. Sales Dashboard View
CREATE OR REPLACE VIEW vw_sales_dashboard AS
SELECT 
    DATE_TRUNC('month', o.order_date) as month,
    COUNT(DISTINCT o.order_id) as total_orders,
    COUNT(DISTINCT o.customer_id) as unique_customers,
    SUM(o.total_amount) as total_revenue,
    ROUND(AVG(o.total_amount), 2) as avg_order_value,
    SUM(od.quantity) as total_books_sold
FROM Orders o
JOIN Order_Details od ON o.order_id = od.order_id
GROUP BY DATE_TRUNC('month', o.order_date);

-- 3. Customer Activity View
CREATE OR REPLACE VIEW vw_customer_activity AS
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(o.total_amount) as total_spent,
    MAX(o.order_date) as last_order_date,
    ROUND(AVG(r.rating), 2) as avg_rating_given
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN Order_Details od ON o.order_id = od.order_id
LEFT JOIN Reviews r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

-- 4. Low Stock Alert View
CREATE OR REPLACE VIEW vw_low_stock_alert AS
SELECT 
    b.book_id,
    b.title,
    a.first_name || ' ' || a.last_name AS author_name,
    b.stock,
    COALESCE(SUM(od.quantity), 0) as total_sold_last_30_days
FROM Books b
JOIN Authors a ON b.author_id = a.author_id
LEFT JOIN Order_Details od ON b.book_id = od.book_id
LEFT JOIN Orders o ON od.order_id = o.order_id
    AND o.order_date >= CURRENT_DATE - INTERVAL '30 days'
WHERE b.stock < 10
GROUP BY b.book_id, a.author_id;
