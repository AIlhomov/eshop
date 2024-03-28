--triggers
DELIMITER ;;
DROP TRIGGER IF EXISTS logg_trigger;
CREATE TRIGGER logg_trigger AFTER INSERT ON product FOR EACH ROW
BEGIN
    INSERT INTO logg (product_id, event, time) VALUES (NEW.product_ID, CONCAT('New product added with product_id ', NEW.product_ID), NOW());
END;;
DELIMITER ;

DROP TRIGGER IF EXISTS logg_trigger_update;
DELIMITER ;;
CREATE TRIGGER logg_trigger_update AFTER UPDATE ON product FOR EACH ROW
BEGIN
    INSERT INTO logg (product_id, event, time) VALUES (NEW.product_ID, CONCAT('Product with product_id ', NEW.product_ID, ' was updated'), NOW());
END;;
DELIMITER ; 
