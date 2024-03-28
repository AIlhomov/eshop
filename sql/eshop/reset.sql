-- Date: 2024-02-13
-- Resets the database to a known state.
--
source setup.sql;

use eshop;

source functions.sql

source ddl.sql
source insert.sql

source procedures.sql
source triggers.sql

SHOW WARNINGS;
CALL get_product_and_its_category();
