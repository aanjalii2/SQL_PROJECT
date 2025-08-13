-- Stored Procedures for Bookstore Management

-- 1. Add New Book with Error Handling
CREATE OR REPLACE PROCEDURE add_new_book(
    p_title VARCHAR(255),
    p_author_id INTEGER,
    p_genre_id INTEGER,
    p_price DECIMAL(10,2),
    p_stock INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Input validation
    IF p_price <= 0 THEN
        RAISE EXCEPTION 'Price must be greater than zero';
    END IF;
    
    IF p_stock < 0 THEN
        RAISE EXCEPTION 'Stock cannot be negative';
    END IF;
    
    -- Insert new book
    INSERT INTO Books (title, author_id, genre_id, price, stock)
    VALUES (p_title, p_author_id, p_genre_id, p_price, p_stock);
    
    -- Update author's book count
    UPDATE Authors 
    SET book_count = book_count + 1
    WHERE author_id = p_author_id;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE NOTICE 'Error adding new book: %', SQLERRM;
END;
$$;

-- 2. Process Order with Stock Update
CREATE OR REPLACE PROCEDURE process_order(
    p_customer_id INTEGER,
    p_book_id INTEGER,
    p_quantity INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_current_stock INTEGER;
    v_book_price DECIMAL(10,2);
    v_order_id INTEGER;
BEGIN
    -- Check stock availability
    SELECT stock, price INTO v_current_stock, v_book_price
    FROM Books
    WHERE book_id = p_book_id;
    
    IF v_current_stock < p_quantity THEN
        RAISE EXCEPTION 'Insufficient stock. Available: %', v_current_stock;
    END IF;
    
    -- Create order
    INSERT INTO Orders (customer_id, order_date, total_amount)
    VALUES (p_customer_id, CURRENT_TIMESTAMP, v_book_price * p_quantity)
    RETURNING order_id INTO v_order_id;
    
    -- Create order detail
    INSERT INTO Order_Details (order_id, book_id, quantity, unit_price)
    VALUES (v_order_id, p_book_id, p_quantity, v_book_price);
    
    -- Update stock
    UPDATE Books
    SET stock = stock - p_quantity
    WHERE book_id = p_book_id;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE NOTICE 'Error processing order: %', SQLERRM;
END;
$$;

-- 3. Update Book Ratings
CREATE OR REPLACE PROCEDURE update_book_rating(
    p_book_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_avg_rating DECIMAL(3,2);
BEGIN
    SELECT ROUND(AVG(rating), 2) INTO v_avg_rating
    FROM Reviews
    WHERE book_id = p_book_id;
    
    UPDATE Books
    SET average_rating = v_avg_rating
    WHERE book_id = p_book_id;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE NOTICE 'Error updating book rating: %', SQLERRM;
END;
$$;
