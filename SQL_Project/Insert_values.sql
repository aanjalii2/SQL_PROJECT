









-- Authors
INSERT INTO Authors (first_name, last_name, bio) VALUES
('George', 'Orwell', 'English novelist and essayist'),
('J.K.', 'Rowling', 'British author, best known for Harry Potter'),
('Harper', 'Lee', 'American novelist, To Kill a Mockingbird'),
('F. Scott', 'Fitzgerald', 'American novelist and short story writer'),
('Jane', 'Austen', 'English novelist known for romantic fiction');

-- Books
INSERT INTO Books (title, author_id, genre, price, published_date) VALUES
('1984', 1, 'Dystopian', 15.99, '1949-06-08'),
('Animal Farm', 1, 'Political Satire', 9.99, '1945-08-17'),
('Harry Potter and the Sorcerer''s Stone', 2, 'Fantasy', 12.99, '1997-06-26'),
('Harry Potter and the Chamber of Secrets', 2, 'Fantasy', 13.99, '1998-07-02'),
('To Kill a Mockingbird', 3, 'Fiction', 10.99, '1960-07-11'),
('The Great Gatsby', 4, 'Tragedy', 14.99, '1925-04-10'),
('Pride and Prejudice', 5, 'Romance', 11.99, '1813-01-28'),
('Emma', 5, 'Romance', 10.49, '1815-12-23'),
('Sense and Sensibility', 5, 'Romance', 9.99, '1811-10-30'),
('Harry Potter and the Prisoner of Azkaban', 2, 'Fantasy', 14.99, '1999-07-08'),
('Harry Potter and the Goblet of Fire', 2, 'Fantasy', 15.99, '2000-07-08'),
('Harry Potter and the Order of the Phoenix', 2, 'Fantasy', 16.99, '2003-06-21'),
('Harry Potter and the Half-Blood Prince', 2, 'Fantasy', 17.99, '2005-07-16'),
('Harry Potter and the Deathly Hallows', 2, 'Fantasy', 18.99, '2007-07-21'),
('Go Set a Watchman', 3, 'Fiction', 12.99, '2015-07-14'),
('This Side of Paradise', 4, 'Fiction', 13.49, '1920-03-26'),
('Tender Is the Night', 4, 'Fiction', 14.49, '1934-04-12'),
('Northanger Abbey', 5, 'Romance', 9.49, '1817-12-01'),
('Mansfield Park', 5, 'Romance', 9.99, '1814-05-09'),
('Harry Potter and the Cursed Child', 2, 'Fantasy', 19.99, '2016-07-31');

-- Customers
INSERT INTO Customers (first_name, last_name, email, phone, address) VALUES
('Alice', 'Smith', 'alice.smith@example.com', '123-456-7890', '123 Main St'),
('Bob', 'Johnson', 'bob.johnson@example.com', '234-567-8901', '456 Oak Ave'),
('Charlie', 'Brown', 'charlie.brown@example.com', '345-678-9012', '789 Pine Rd'),
('Diana', 'Prince', 'diana.prince@example.com', '456-789-0123', '321 Elm St'),
('Evan', 'Williams', 'evan.williams@example.com', '567-890-1234', '654 Maple Ln'),
('Fiona', 'Garcia', 'fiona.garcia@example.com', '678-901-2345', '987 Birch Blvd'),
('George', 'Miller', 'george.miller@example.com', '789-012-3456', '147 Cedar Ct'),
('Hannah', 'Davis', 'hannah.davis@example.com', '890-123-4567', '258 Spruce Dr'),
('Ian', 'Martinez', 'ian.martinez@example.com', '901-234-5678', '369 Aspen Way'),
('Jane', 'Wilson', 'jane.wilson@example.com', '012-345-6789', '741 Walnut St');

-- Orders
INSERT INTO Orders (customer_id, order_date, total_amount) VALUES
(1, '2025-07-01', 45.97),
(2, '2025-07-02', 27.98),
(3, '2025-07-03', 60.97),
(1, '2025-07-04', 29.98),
(4, '2025-07-05', 15.99),
(5, '2025-07-06', 40.97),
(6, '2025-07-07', 30.98),
(7, '2025-07-08', 19.99),
(8, '2025-07-09', 25.99),
(9, '2025-07-10', 14.99),
(10, '2025-07-11', 35.98),
(1, '2025-07-12', 50.97),
(2, '2025-07-13', 22.98),
(3, '2025-07-14', 17.99),
(4, '2025-07-15', 44.97);

-- Order Details
INSERT INTO Order_Details (order_id, book_id, quantity, price) VALUES
(1, 1, 1, 15.99),
(1, 3, 2, 12.99),
(2, 5, 2, 10.99),
(3, 10, 1, 14.99),
(3, 6, 3, 14.99),
(4, 7, 2, 11.99),
(5, 1, 1, 15.99),
(6, 3, 1, 12.99),
(6, 4, 2, 13.99),
(7, 8, 1, 10.49),
(8, 14, 1, 18.99),
(9, 9, 2, 9.99),
(10, 2, 1, 9.99),
(11, 13, 2, 17.99),
(12, 12, 3, 16.99),
(13, 15, 1, 12.99),
(14, 20, 1, 19.99),
(15, 16, 3, 13.49);

-- Reviews
INSERT INTO Reviews (book_id, customer_id, rating, comment, review_date) VALUES
(1, 1, 5, 'A chilling dystopian classic.', '2025-07-02'),
(3, 2, 4, 'Magical and captivating.', '2025-07-03'),
(5, 3, 5, 'A timeless story.', '2025-07-04'),
(6, 4, 3, 'Good but a bit dated.', '2025-07-05'),
(7, 5, 4, 'Romantic and witty.', '2025-07-06'),
(10, 6, 5, 'My favorite Potter book!', '2025-07-07'),
(12, 7, 2, 'Not my favorite.', '2025-07-08'),
(14, 8, 5, 'Epic finale.', '2025-07-09'),
(15, 9, 4, 'Interesting read.', '2025-07-10'),
(1, 10, 3, 'Good but heavy.', '2025-07-11'),
(4, 1, 4, 'Exciting story.', '2025-07-12'),
(3, 2, 5, 'Loved it.', '2025-07-13'),
(5, 3, 5, 'Classic.', '2025-07-14'),
(8, 4, 4, 'Well written.', '2025-07-15'),
(9, 5, 3, 'Enjoyed it.', '2025-07-16'),
(11, 6, 4, 'Great continuation.', '2025-07-17'),
(13, 7, 3, 'Average.', '2025-07-18'),
(16, 8, 5, 'Fantastic.', '2025-07-19'),
(17, 9, 4, 'Engaging.', '2025-07-20'),
(18, 10, 2, 'Slow at times.', '2025-07-21'),
(19, 1, 5, 'Loved the characters.', '2025-07-22'),
(20, 2, 4, 'Very good.', '2025-07-23');


SELECT * FROM Authors;
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Order_Details;
SELECT * FROM Reviews;
