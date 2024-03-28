--
-- Creates the tables for the eshop database. (Database scheme).
--
USE eshop;

DROP TABLE IF EXISTS logg;
DROP TABLE IF EXISTS picklist;
DROP TABLE IF EXISTS invoice;
DROP TABLE IF EXISTS orderdetails;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS stock;
DROP TABLE IF EXISTS stockshelf;
DROP TABLE IF EXISTS productcategory;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS customer;


CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    address VARCHAR(255),
    phone_number VARCHAR(20),
    email VARCHAR(100),
    KEY customer_name_index (name)
);




CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    description TEXT,
    price DECIMAL(10, 2),
    KEY product_name_index (name)
);

CREATE TABLE category(
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    KEY category_name_index (name)
);

CREATE TABLE productcategory (
    product_category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT,
    product_id INT,
    FOREIGN KEY (category_id) REFERENCES category(category_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);



CREATE TABLE stockshelf (
    shelf_ID INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    shelf_row VARCHAR(50),
    stock_category VARCHAR(100),
    amount INT,
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE stock (
    stock_id INT PRIMARY KEY AUTO_INCREMENT,
    shelf_ID INT,
    name VARCHAR(100),
    FOREIGN KEY (shelf_ID) REFERENCES stockshelf(shelf_ID)  -- Corrected the case
);




CREATE TABLE orders (
    order_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    ordered_quantity INT DEFAULT 0 NOT NULL,
    date_of_order TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,  -- date of creation
    date_of_last_update TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP , -- date of update
    date_of_delete TIMESTAMP NULL, -- date of deletion
    date_of_activated TIMESTAMP NULL, -- date of activation / beställed
    date_of_sent TIMESTAMP NULL, -- date of sent / skickad,
    
    -- status ENUM('Created', 'Sent', 'Updated', 'Deleted', 'Ordered') DEFAULT 'Created' NOT NULL,
    is_deleted INT DEFAULT 0,  -- 0 for not deleted and 1 for deleted


    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    KEY is_deleted_status_key (is_deleted) -- made it into key for better preformance i think...  
);


CREATE TABLE orderdetails (
    order_details_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    ordered_quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE invoice (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE picklist (
    pick_list_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    shelf_ID INT,
    ordered_quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (shelf_ID) REFERENCES stockshelf(shelf_ID)
);

CREATE TABLE logg (
    logg_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT,
    product_id INT,
    event VARCHAR(255),
    time TIMESTAMP,
    FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

SHOW WARNINGS;