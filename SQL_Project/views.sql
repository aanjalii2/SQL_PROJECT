
-- Views for Bookstore Management

-- 1. Book Details View
CREATE OR REPLACE VIEW vw_book_details AS
SELECT 
    Books.book_id,
    Books.title,
    CONCAT(Authors.first_name, ' ', Authors.last_name) AS author_name,
    Genres.genre_name,
    Books.price,
    Books.stock,
    COALESCE(AVG(Reviews.rating), 0) AS average_rating,
    COUNT(DISTINCT Reviews.review_id) AS review_count
FROM Books
JOIN Authors ON Books.author_id = Authors.author_id
JOIN Genres ON Books.genre_id = Genres.genre_id
LEFT JOIN Reviews ON Books.book_id = Reviews.book_id
GROUP BY Books.book_id, Authors.author_id, Genres.genre_id;

-- 2. Sales Dashboard View
CREATE OR REPLACE VIEW vw_sales_dashboard AS
SELECT 
    DATE_TRUNC('month', Orders.order_date) AS month,
    COUNT(DISTINCT Orders.order_id) AS total_orders,
    COUNT(DISTINCT Orders.customer_id) AS unique_customers,
    SUM(Orders.total_amount) AS total_revenue,
    ROUND(AVG(Orders.total_amount), 2) AS avg_order_value,
    SUM(Order_Details.quantity) AS total_books_sold
FROM Orders
JOIN Order_Details ON Orders.order_id = Order_Details.order_id
GROUP BY DATE_TRUNC('month', Orders.order_date);

-- 3. Customer Activity View
CREATE OR REPLACE VIEW vw_customer_activity AS
SELECT 
    Customers.customer_id,
    CONCAT(Customers.first_name, ' ', Customers.last_name) AS customer_name,
    COUNT(DISTINCT Orders.order_id) AS total_orders,
    SUM(Orders.total_amount) AS total_spent,
    MAX(Orders.order_date) AS last_order_date,
    ROUND(AVG(Reviews.rating), 2) AS avg_rating_given
FROM Customers
LEFT JOIN Orders ON Customers.customer_id = Orders.customer_id
LEFT JOIN Order_Details ON Orders.order_id = Order_Details.order_id
LEFT JOIN Reviews ON Customers.customer_id = Reviews.customer_id
GROUP BY Customers.customer_id;

-- 4. Low Stock Alert View
CREATE OR REPLACE VIEW vw_low_stock_alert AS
SELECT 
    Books.book_id,
    Books.title,
    CONCAT(Authors.first_name, ' ', Authors.last_name) AS author_name,
    Books.stock,
    COALESCE(SUM(Order_Details.quantity), 0) AS total_sold_last_30_days
FROM Books
JOIN Authors ON Books.author_id = Authors.author_id
LEFT JOIN Order_Details ON Books.book_id = Order_Details.book_id
LEFT JOIN Orders ON Order_Details.order_id = Orders.order_id
    AND Orders.order_date >= CURRENT_DATE - INTERVAL '30 days'
WHERE Books.stock < 10
GROUP BY Books.book_id, Authors.author_id;
