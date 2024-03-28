

--procedures

DROP PROCEDURE IF EXISTS get_products;
DELIMITER ;;
CREATE PROCEDURE get_products()
BEGIN
    SELECT * FROM product;
END;;
DELIMITER ;

CALL get_products();



DROP PROCEDURE IF EXISTS get_category;
DELIMITER ;;
CREATE PROCEDURE get_category()
BEGIN
    SELECT * FROM category;
END;;
DELIMITER ;






DROP PROCEDURE IF EXISTS get_product_and_its_category;
DELIMITER ;;
CREATE PROCEDURE get_product_and_its_category()
BEGIN
    SELECT 
        p.product_id,
        p.name,
        p.price,
        COALESCE(s1.amount, 0) AS amount, 
        GROUP_CONCAT(COALESCE(cat.name, 'Uncategorized')) AS category
    FROM
        product AS p
    LEFT JOIN
        productcategory AS pCat ON pCat.product_id = p.product_id
    LEFT JOIN
        category AS cat ON cat.category_id = pCat.category_id
    LEFT JOIN
        stockshelf AS s1 ON p.product_id = s1.product_id
    GROUP BY 
        p.product_id;
END;;
DELIMITER ;







DROP PROCEDURE IF EXISTS insert_product;
DELIMITER ;;
CREATE PROCEDURE insert_product(
    p_id INT,
    p_name VARCHAR(100), 
    p_price INT
    )
BEGIN
    INSERT INTO product (product_id, name, price ) VALUES (p_id, p_name, p_price );
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS get_product_by_id;
DELIMITER ;;
CREATE PROCEDURE get_product_by_id(
    p_id INT
    )
BEGIN
    SELECT * FROM product WHERE product_id = p_id;
END;;
DELIMITER ;


DROP PROCEDURE IF EXISTS update_product;
DELIMITER ;;
CREATE PROCEDURE update_product(
    p_id INT,
    p_name VARCHAR(100), 
    p_price INT
    )
BEGIN
    UPDATE product SET name = p_name, price = p_price WHERE product_id = p_id;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS delete_product;
DELIMITER ;;
CREATE PROCEDURE delete_product(
    p_id INT
    )
BEGIN
    SET FOREIGN_KEY_CHECKS=0;
    DELETE FROM product WHERE product_id = p_id;
    SET FOREIGN_KEY_CHECKS=1;
END;;
DELIMITER ;



-- Down below is used in cli.js
DROP PROCEDURE IF EXISTS get_log;
DELIMITER ;;
CREATE PROCEDURE get_log(
    limits INT
    )
BEGIN
    SELECT * FROM logg ORDER BY time DESC LIMIT limits;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS print_log;
DELIMITER ;;
CREATE PROCEDURE print_log()
BEGIN
    SELECT * FROM logg;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS get_shelf;
DELIMITER ;;
CREATE PROCEDURE get_shelf()
BEGIN
    SELECT * FROM stockshelf;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS get_inventory;
DELIMITER ;;
CREATE PROCEDURE get_inventory(
    str_filter VARCHAR(100)
)
BEGIN
    SELECT p.product_id, p.name , s.shelf_row
    FROM product as p
    JOIN stockshelf as s ON p.product_id = s.product_id
    WHERE p.product_id LIKE str_filter
    OR p.name LIKE str_filter 
    OR s.shelf_row LIKE str_filter;
END;;
DELIMITER ;





DROP PROCEDURE IF EXISTS insert_inventory;
DELIMITER ;;

CREATE PROCEDURE insert_inventory(
    p_id INT,
    s_shelf_row INT, 
    s_amount INT
)
BEGIN
    SET FOREIGN_KEY_CHECKS=0;
    IF EXISTS(SELECT * FROM stockshelf WHERE product_id = p_id) THEN
        UPDATE stockshelf SET amount = amount + s_amount WHERE product_id = p_id;
    ELSE
        INSERT INTO stockshelf (product_id, shelf_row, amount) VALUES (p_id, s_shelf_row, s_amount);
    END IF;
END;;
DELIMITER ;





DROP PROCEDURE IF EXISTS delete_inventory;
DELIMITER ;;
CREATE PROCEDURE delete_inventory(
    p_id INT,
    s_shelf_row VARCHAR(10),
    s_amount INT
)
BEGIN
    DECLARE current_amount INT;
    
    SELECT amount INTO current_amount FROM stockshelf WHERE product_id = p_id;
    
    IF current_amount IS NOT NULL THEN
        -- Calculate the new amount after deletion
        SET current_amount = current_amount - s_amount;
        
        -- Ensure the new amount is not negative
        IF current_amount < 0 THEN
            SET current_amount = 0;
        END IF;
        
        UPDATE stockshelf SET amount = current_amount WHERE product_id = p_id;
    END IF;
END;;
DELIMITER ;



--kmom06 -------------------------

DROP PROCEDURE IF EXISTS get_next_product_id;
DELIMITER ;;
CREATE PROCEDURE get_next_product_id()
BEGIN
    SELECT COUNT(*)+1 AS row_count FROM product;
END;;
DELIMITER ;



DROP PROCEDURE IF EXISTS get_customer;
DELIMITER ;;
CREATE PROCEDURE get_customer()
BEGIN
    SELECT * FROM customer;
END;;
DELIMITER ;


-- DROP PROCEDURE IF EXISTS get_order;
-- DELIMITER ;;
-- CREATE PROCEDURE get_order()
-- BEGIN
--     SELECT order_id, customer_id, date_of_order, ordered_quantity, status FROM orders;
-- END;;









DROP PROCEDURE IF EXISTS get_order;
DELIMITER ;;
CREATE PROCEDURE get_order()
BEGIN
    SELECT o.order_id, o.customer_id, o.date_of_order, o.ordered_quantity, order_status(
        o.date_of_order,
        o.date_of_last_update,
        o.date_of_delete,
        o.date_of_activated,
        o.date_of_sent
        
    ) AS status,
    c.name
    FROM orders o
    JOIN customer c ON o.customer_id = c.customer_id;
END;;
DELIMITER ;










DROP PROCEDURE IF EXISTS create_order;
DELIMITER ;;
CREATE PROCEDURE create_order(
    c_id INT,
    i_id INT,
    d_o_o DATE,
    o_q INT
)
BEGIN
    INSERT INTO orders (customer_id, invoice_id, date_of_order, ordered_quantity) VALUES (c_id, i_id, d_o_o, o_q);
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS confirm_order;
DELIMITER ;;
CREATE PROCEDURE confirm_order(
    c_id INT
)
BEGIN
    SELECT * FROM customer WHERE customer_id = c_id;
END;;
    -- UPDATE orders SET status = 'activated' WHERE order_id = c_id;
DELIMITER ;












DROP PROCEDURE IF EXISTS get_product_order;
DELIMITER ;;
CREATE PROCEDURE get_product_order(
    o_id INT
)
BEGIN
    SELECT pl.order_id, pl.product_id, p.name, pl.ordered_quantity, CONCAT(p.price, ' $ per item') as price
    FROM picklist pl
    JOIN product p ON pl.product_id = p.product_id
    WHERE pl.order_id = o_id;
END;;
DELIMITER ;




-- DROP PROCEDURE IF EXISTS get_product_order;
-- DELIMITER ;;
-- CREATE PROCEDURE get_product_order(
--     o_id INT
-- )
-- BEGIN
--     SELECT pl.order_id, pl.product_id, p.name, pl.ordered_quantity, CONCAT(p.price, ' $ per item') as price
--     FROM picklist pl
--     JOIN product p ON pl.product_id = p.product_id
--     WHERE pl.order_id = o_id;

--     UPDATE orders o
--     JOIN picklist pl ON o.order_id = pl.order_id
--     SET o.ordered_quantity = o.ordered_quantity + pl.ordered_quantity
--     WHERE pl.order_id = o_id;

-- END;;
-- DELIMITER ;









DROP PROCEDURE IF EXISTS get_available_product;
DELIMITER ;;
CREATE PROCEDURE get_available_product()
BEGIN
    SELECT p.name, s.amount, p.product_id, p.price, pl.order_id
    FROM product p
    JOIN stockshelf s ON p.product_id = s.product_id
    LEFT JOIN picklist pl ON pl.product_id = p.product_id
    GROUP BY p.name, s.amount, p.product_id, p.price, pl.order_id
    ORDER BY p.name ASC;
END;;
DELIMITER ;





-- DROP PROCEDURE IF EXISTS get_available_product;
-- DELIMITER ;;
-- CREATE PROCEDURE get_available_product()
-- BEGIN
--     SELECT p.name, s.amount, p.product_id, p.price, o.order_id
--     FROM product p
--     LEFT JOIN stockshelf s ON p.product_id = s.product_id
--     LEFT JOIN orderdetails o ON o.product_id = p.product_id;
-- END;;
-- DELIMITER ;

-- DROP PROCEDURE IF EXISTS insert_order_row;
-- DELIMITER ;;
-- CREATE PROCEDURE insert_order_row(
--     o_id INT,
--     p_id INT,
--     o_q INT
-- )
-- BEGIN
--     DECLARE existing_quantity INT;

--     SELECT ordered_quantity INTO existing_quantity
--     FROM orderdetails
--     WHERE order_id = o_id AND product_id = p_id;

--     IF existing_quantity IS NOT NULL THEN
--         UPDATE orderdetails
--         SET ordered_quantity = ordered_quantity + o_q
--         WHERE order_id = o_id AND product_id = p_id;
--     ELSE
--         INSERT INTO orderdetails (order_id, product_id, ordered_quantity)
--         VALUES (o_id, p_id, o_q);
--     END IF;

--     -- Decrease the amount in stockshelf table
--     UPDATE stockshelf
--     SET amount = amount - o_q
--     WHERE product_id = p_id;
-- END;;
-- DELIMITER ;

DROP PROCEDURE IF EXISTS insert_order_row;
DELIMITER ;;
CREATE PROCEDURE insert_order_row(
    o_id INT,
    p_id INT,
    o_q INT
)
BEGIN
    DECLARE existing_quantity INT;

    SELECT ordered_quantity INTO existing_quantity
    FROM picklist
    WHERE order_id = o_id AND product_id = p_id;

    IF existing_quantity IS NOT NULL THEN
        UPDATE picklist
        SET ordered_quantity = ordered_quantity + o_q
        WHERE order_id = o_id AND product_id = p_id;
    ELSE
        INSERT INTO picklist (order_id, product_id, ordered_quantity)
        VALUES (o_id, p_id, o_q);
    END IF;

    UPDATE stockshelf
    SET amount = amount - o_q
    WHERE product_id = p_id;

    UPDATE orders
    SET date_of_last_update = CURRENT_TIMESTAMP, ordered_quantity = o_q + ordered_quantity
    WHERE order_id = o_id;
END;;
DELIMITER ; 




DROP PROCEDURE IF EXISTS insert_order_details;
DELIMITER ;;
CREATE PROCEDURE insert_order_details(
    o_id INT,
    o_q INT
)
BEGIN
    INSERT INTO orderdetails (order_id, ordered_quantity) VALUES (o_id, o_q);
END;;
DELIMITER ;

-- <!-- <button class="button" onclick="window.location.href='/eshop/order_row/create/<%= res[0].o_id %>'">Add product</button> -->



DROP PROCEDURE IF EXISTS update_order;
DELIMITER ;;
CREATE PROCEDURE update_order(
    o_id INT
)
BEGIN
    UPDATE orders
    SET date_of_activated = CURRENT_TIMESTAMP
    WHERE order_id = o_id;
END;;
DELIMITER ;



--CLI.JS--------------------------
DROP PROCEDURE IF EXISTS get_order_by_str;
DELIMITER ;;
CREATE PROCEDURE get_order_by_str(
    str_filter VARCHAR(100)
)
BEGIN

    SELECT o.order_id, o.customer_id, o.date_of_order, o.ordered_quantity, order_status(
        o.date_of_order,
        o.date_of_last_update,
        o.date_of_delete,
        o.date_of_activated,
        o.date_of_sent
        
    ) AS status,
    c.name
    FROM orders o
    JOIN customer c ON o.customer_id = c.customer_id
    WHERE o.order_id LIKE str_filter OR c.customer_id LIKE str_filter;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS get_picklist;
DELIMITER ;;
CREATE PROCEDURE get_picklist(
    o_id INT
)
BEGIN
    SELECT p.*, s.amount, s.shelf_row
    FROM picklist p
    JOIN stockshelf s ON p.product_id = s.product_id
    WHERE p.order_id = o_id;
END;;
DELIMITER ;


DROP PROCEDURE IF EXISTS ship_order;
DELIMITER ;;
CREATE PROCEDURE ship_order(
    o_id INT
)
BEGIN
    UPDATE orders
    SET date_of_sent = CURRENT_TIMESTAMP
    WHERE order_id = o_id;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS get_inv;
DELIMITER ;;
CREATE PROCEDURE get_inv()
BEGIN
    SELECT 
        p.product_id,
        p.name,
        p.price,
        COALESCE(s1.amount, 0) AS amount, 
        GROUP_CONCAT(COALESCE(cat.name, 'Uncategorized')) AS category,
        s1.shelf_row AS shelf
    FROM
        product AS p
    LEFT JOIN
        productcategory AS pCat ON pCat.product_id = p.product_id
    LEFT JOIN
        category AS cat ON cat.category_id = pCat.category_id
    LEFT JOIN
        stockshelf AS s1 ON p.product_id = s1.product_id
    GROUP BY 
        p.product_id;
END;;
DELIMITER ;