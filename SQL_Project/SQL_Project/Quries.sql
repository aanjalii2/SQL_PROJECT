--a) List all books with their author’s full name

SELECT b.title, a.first_name || ' ' || a.last_name AS author_name
FROM Books b
JOIN Authors a ON b.author_id = a.author_id
ORDER BY author_name, b.title;



--b) Find the top 5 best-selling books by quantity sold

SELECT b.title, SUM(od.quantity) AS total_quantity_sold
FROM Books b
JOIN Order_Details od ON b.book_id = od.book_id
GROUP BY b.title
ORDER BY total_quantity_sold DESC
LIMIT 5;

--c) Get total revenue from all orders

SELECT SUM(o.total_amount) AS total_revenue
FROM Orders o;

--d) Show customers who have ordered more than 3 times
SELECT c.first_name || ' ' || c.last_name AS customer_name, COUNT(o.order_id) AS order_count
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING COUNT(o.order_id) > 3;

--e) Find the average rating for each book

SELECT b.title, ROUND(AVG(r.rating), 2) AS average_rating
FROM Books b
JOIN Reviews r ON b.book_id = r.book_id
GROUP BY b.book_id;


--f) List books that have no reviews yet

SELECT b.title
FROM Books b
LEFT JOIN Reviews r ON b.book_id = r.book_id
WHERE r.review_id IS NULL;


--g) Find customers who gave a 5-star rating

SELECT DISTINCT c.first_name || ' ' || c.last_name AS customer_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Books b ON od.book_id = b.book_id
JOIN Reviews r ON b.book_id = r.book_id
WHERE r.rating = 5;


--h) Show the most recent order for each customer

SELECT c.first_name || ' ' || c.last_name AS customer_name, MAX(o.order_date) AS most_recent_order_date
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;
 
 -- i) List authors who have published more than 3 books

SELECT a.first_name || ' ' || a.last_name AS author_name, COUNT(b.book_id) AS book_count
FROM Authors a
JOIN Books b ON a.author_id = b.author_id
GROUP BY a.author_id
HAVING COUNT(b.book_id) > 3;

--j) Display the total quantity sold per genre

SELECT g.genre_name, SUM(od.quantity) AS total_quantity_sold
FROM Genres g
JOIN Books b ON g.genre_id = b.genre_id
JOIN Order_Details od ON b.book_id = od.book_id
GROUP BY g.genre_id
ORDER BY total_quantity_sold DESC;

-- Advanced Queries

--k) Customer Segmentation Analysis using CTE
WITH CustomerSegments AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        COUNT(o.order_id) as total_orders,
        SUM(o.total_amount) as total_spent,
        CASE 
            WHEN SUM(o.total_amount) >= 1000 THEN 'Premium'
            WHEN SUM(o.total_amount) >= 500 THEN 'Gold'
            WHEN SUM(o.total_amount) >= 100 THEN 'Silver'
            ELSE 'Bronze'
        END as customer_segment
    FROM Customers c
    LEFT JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
)
SELECT 
    customer_segment,
    COUNT(*) as segment_count,
    ROUND(AVG(total_spent), 2) as avg_spending
FROM CustomerSegments
GROUP BY customer_segment
ORDER BY avg_spending DESC;

--l) Top 3 Books per Genre using Window Functions
SELECT 
    genre_name,
    title,
    total_sold,
    rank_in_genre
FROM (
    SELECT 
        g.genre_name,
        b.title,
        SUM(od.quantity) as total_sold,
        RANK() OVER (PARTITION BY g.genre_id ORDER BY SUM(od.quantity) DESC) as rank_in_genre
    FROM Books b
    JOIN Genres g ON b.genre_id = g.genre_id
    JOIN Order_Details od ON b.book_id = od.book_id
    GROUP BY g.genre_id, g.genre_name, b.title
) ranked_books
WHERE rank_in_genre <= 3;

--m) Monthly Revenue Trend with Year-over-Year Growth
WITH MonthlyRevenue AS (
    SELECT 
        DATE_TRUNC('month', o.order_date) as month,
        SUM(o.total_amount) as revenue
    FROM Orders o
    GROUP BY DATE_TRUNC('month', o.order_date)
),
YearOverYear AS (
    SELECT 
        month,
        revenue,
        LAG(revenue, 12) OVER (ORDER BY month) as last_year_revenue
    FROM MonthlyRevenue
)
SELECT 
    month,
    revenue,
    last_year_revenue,
    CASE 
        WHEN last_year_revenue IS NOT NULL 
        THEN ROUND(((revenue - last_year_revenue) / last_year_revenue * 100), 2)
        ELSE NULL 
    END as yoy_growth_percentage
FROM YearOverYear
ORDER BY month DESC;

--n) Customer Purchase Pattern Analysis
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(DISTINCT g.genre_id) as different_genres_bought,
    MODE() WITHIN GROUP (ORDER BY g.genre_name) as favorite_genre,
    ROUND(AVG(o.total_amount), 2) as avg_order_value,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY o.total_amount) as median_order_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Books b ON od.book_id = b.book_id
JOIN Genres g ON b.genre_id = g.genre_id
GROUP BY c.customer_id
ORDER BY different_genres_bought DESC;