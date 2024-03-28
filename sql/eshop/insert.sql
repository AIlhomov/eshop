--
-- Uses CSV files to insert data into the e_shop database.
--

DELETE FROM orders;
DELETE FROM stockshelf;
DELETE FROM product;
DELETE FROM productcategory;
DELETE FROM customer;
DELETE FROM stock;
DELETE FROM invoice;
DELETE FROM category;
DELETE FROM picklist;
DELETE FROM orderdetails;
--
-- Enable LOAD DATA LOCAL INFILE on the server.
--
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'invoice.csv'
INTO TABLE invoice
CHARSET utf8
FIELDS
    TERMINATED BY ';'
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
;

LOAD DATA LOCAL INFILE 'customer.csv'
INTO TABLE customer
CHARSET utf8
FIELDS
    TERMINATED BY ';'
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
;



LOAD DATA LOCAL INFILE 'category.csv'
INTO TABLE category
CHARSET utf8
FIELDS
    TERMINATED BY ';'
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
;



LOAD DATA LOCAL INFILE 'product.csv'
INTO TABLE product
CHARSET utf8
FIELDS
    TERMINATED BY ';'
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
;

LOAD DATA LOCAL INFILE 'productcategory.csv'
INTO TABLE productcategory
CHARSET utf8
FIELDS
    TERMINATED BY ';'
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
;




LOAD DATA LOCAL INFILE 'stockshelf.csv'
INTO TABLE stockshelf
CHARSET utf8
FIELDS
    TERMINATED BY ';'
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
;

LOAD DATA LOCAL INFILE 'stock.csv'
INTO TABLE stock
CHARSET utf8
FIELDS
    TERMINATED BY ';'
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
;

LOAD DATA LOCAL INFILE 'orders.csv'
INTO TABLE orders
CHARSET utf8
FIELDS
    TERMINATED BY ';'
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
(order_id, customer_id, ordered_quantity)
;

LOAD DATA LOCAL INFILE 'picklist.csv'
INTO TABLE picklist
CHARSET utf8
FIELDS
    TERMINATED BY ';'
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
;

LOAD DATA LOCAL INFILE 'orderdetails.csv'
INTO TABLE orderdetails
CHARSET utf8
FIELDS
    TERMINATED BY ';'
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
;

SELECT * FROM customer;
SELECT * FROM product;
SELECT * FROM productcategory;
SELECT * FROM stockshelf;
SELECT * FROM stock;
SELECT * FROM orders;

