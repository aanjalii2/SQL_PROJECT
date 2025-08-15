
-- a) List all books with their author’s full name
SELECT Books.title, CONCAT(Authors.first_name, ' ', Authors.last_name) AS author_name
FROM Books
JOIN Authors ON Books.author_id = Authors.author_id
ORDER BY author_name, Books.title;

-- b) Find the top 5 best-selling books by quantity sold
SELECT Books.title, SUM(Order_Details.quantity) AS total_quantity_sold
FROM Books
JOIN Order_Details ON Books.book_id = Order_Details.book_id
GROUP BY Books.title
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- c) Get total revenue from all orders
SELECT SUM(Orders.total_amount) AS total_revenue
FROM Orders;

-- d) Show customers who have ordered more than 3 times
SELECT CONCAT(Customers.first_name, ' ', Customers.last_name) AS customer_name,
       COUNT(Orders.order_id) AS order_count
FROM Customers
JOIN Orders ON Customers.customer_id = Orders.customer_id
GROUP BY Customers.customer_id
HAVING COUNT(Orders.order_id) > 3;

-- e) Find the average rating for each book
SELECT Books.title, ROUND(AVG(Reviews.rating), 2) AS average_rating
FROM Books
JOIN Reviews ON Books.book_id = Reviews.book_id
GROUP BY Books.book_id;

-- f) List books that have no reviews yet
SELECT Books.title
FROM Books
LEFT JOIN Reviews ON Books.book_id = Reviews.book_id
WHERE Reviews.review_id IS NULL;

-- g) Find customers who gave a 5-star rating
SELECT DISTINCT CONCAT(Customers.first_name, ' ', Customers.last_name) AS customer_name
FROM Customers
JOIN Orders ON Customers.customer_id = Orders.customer_id
JOIN Order_Details ON Orders.order_id = Order_Details.order_id
JOIN Books ON Order_Details.book_id = Books.book_id
JOIN Reviews ON Books.book_id = Reviews.book_id
WHERE Reviews.rating = 5;

-- h) Show the most recent order for each customer
SELECT CONCAT(Customers.first_name, ' ', Customers.last_name) AS customer_name,
       MAX(Orders.order_date) AS most_recent_order_date
FROM Customers
JOIN Orders ON Customers.customer_id = Orders.customer_id
GROUP BY Customers.customer_id;

-- i) List authors who have published more than 3 books
SELECT CONCAT(Authors.first_name, ' ', Authors.last_name) AS author_name,
       COUNT(Books.book_id) AS book_count
FROM Authors
JOIN Books ON Authors.author_id = Books.author_id
GROUP BY Authors.author_id
HAVING COUNT(Books.book_id) > 3;

-- j) Display the total quantity sold per genre
SELECT Genres.genre_name, SUM(Order_Details.quantity) AS total_quantity_sold
FROM Genres
JOIN Books ON Genres.genre_id = Books.genre_id
JOIN Order_Details ON Books.book_id = Order_Details.book_id
GROUP BY Genres.genre_id
ORDER BY total_quantity_sold DESC;

-- k) Customer Segmentation Analysis using CTE
WITH CustomerSegments AS (
    SELECT 
        Customers.customer_id,
        CONCAT(Customers.first_name, ' ', Customers.last_name) AS customer_name,
        COUNT(Orders.order_id) AS total_orders,
        SUM(Orders.total_amount) AS total_spent,
        CASE 
            WHEN SUM(Orders.total_amount) >= 1000 THEN 'Premium'
            WHEN SUM(Orders.total_amount) >= 500 THEN 'Gold'
            WHEN SUM(Orders.total_amount) >= 100 THEN 'Silver'
            ELSE 'Bronze'
        END AS customer_segment
    FROM Customers
    LEFT JOIN Orders ON Customers.customer_id = Orders.customer_id
    GROUP BY Customers.customer_id
)
SELECT 
    customer_segment,
    COUNT(*) AS segment_count,
    ROUND(AVG(total_spent), 2) AS avg_spending
FROM CustomerSegments
GROUP BY customer_segment
ORDER BY avg_spending DESC;

-- l) Top 3 Books per Genre using Window Functions
SELECT 
    genre_name,
    title,
    total_sold,
    rank_in_genre
FROM (
    SELECT 
        Genres.genre_name,
        Books.title,
        SUM(Order_Details.quantity) AS total_sold,
        RANK() OVER (PARTITION BY Genres.genre_id ORDER BY SUM(Order_Details.quantity) DESC) AS rank_in_genre
    FROM Books
    JOIN Genres ON Books.genre_id = Genres.genre_id
    JOIN Order_Details ON Books.book_id = Order_Details.book_id
    GROUP BY Genres.genre_id, Genres.genre_name, Books.title
) ranked_books
WHERE rank_in_genre <= 3;

-- m) Monthly Revenue Trend with Year-over-Year Growth
WITH MonthlyRevenue AS (
    SELECT 
        DATE_TRUNC('month', Orders.order_date) AS month,
        SUM(Orders.total_amount) AS revenue
    FROM Orders
    GROUP BY DATE_TRUNC('month', Orders.order_date)
),
YearOverYear AS (
    SELECT 
        month,
        revenue,
        LAG(revenue, 12) OVER (ORDER BY month) AS last_year_revenue
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
    END AS yoy_growth_percentage
FROM YearOverYear
ORDER BY month DESC;

-- n) Customer Purchase Pattern Analysis
SELECT 
    Customers.customer_id,
    CONCAT(Customers.first_name, ' ', Customers.last_name) AS customer_name,
    COUNT(DISTINCT Genres.genre_id) AS different_genres_bought,
    MODE() WITHIN GROUP (ORDER BY Genres.genre_name) AS favorite_genre,
    ROUND(AVG(Orders.total_amount), 2) AS avg_order_value,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Orders.total_amount) AS median_order_value
FROM Customers
JOIN Orders ON Customers.customer_id = Orders.customer_id
JOIN Order_Details ON Orders.order_id = Order_Details.order_id
JOIN Books ON Order_Details.book_id = Books.book_id
JOIN Genres ON Books.genre_id = Genres.genre_id
GROUP BY Customers.customer_id
ORDER BY different_genres_bought DESC;
