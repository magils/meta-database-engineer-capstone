-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema little_lemon
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `little_lemon` ;

-- -----------------------------------------------------
-- Schema little_lemon
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `little_lemon` ;
USE `little_lemon` ;

-- -----------------------------------------------------
-- Table `little_lemon`.`customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `little_lemon`.`customer` ;

CREATE TABLE IF NOT EXISTS `little_lemon`.`customer` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `last_name` VARCHAR(255) NOT NULL,
  `address` VARCHAR(255) NULL,
  `email` VARCHAR(300) NOT NULL,
  `phone_number` VARCHAR(45) NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `little_lemon`.`staff`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `little_lemon`.`staff` ;

CREATE TABLE IF NOT EXISTS `little_lemon`.`staff` (
  `staff_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `joined_date` DATETIME NOT NULL DEFAULT NOW(),
  `status` VARCHAR(45) NOT NULL,
  `salary` DECIMAL(12,2) NOT NULL,
  `birthdate` DATETIME NOT NULL,
  `occupation` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `phone_number` VARCHAR(45) NULL,
  PRIMARY KEY (`staff_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `little_lemon`.`orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `little_lemon`.`orders` ;

CREATE TABLE IF NOT EXISTS `little_lemon`.`orders` (
  `order_id` INT NOT NULL AUTO_INCREMENT,
  `order_date` DATETIME NOT NULL DEFAULT NOW(),
  `order_type` VARCHAR(100) NOT NULL,
  `customer_id` INT NOT NULL,
  `staff_id` INT NOT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `fk_order_customer_idx` (`customer_id` ASC) VISIBLE,
  INDEX `fk_orders_staff1_idx` (`staff_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_customer`
    FOREIGN KEY (`customer_id`)
    REFERENCES `little_lemon`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_staff1`
    FOREIGN KEY (`staff_id`)
    REFERENCES `little_lemon`.`staff` (`staff_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `little_lemon`.`menu`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `little_lemon`.`menu` ;

CREATE TABLE IF NOT EXISTS `little_lemon`.`menu` (
  `menu_id` INT NOT NULL AUTO_INCREMENT,
  `menu_name` VARCHAR(255) NULL,
  `cousine` VARCHAR(255) NULL,
  PRIMARY KEY (`menu_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `little_lemon`.`menu_item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `little_lemon`.`menu_item` ;

CREATE TABLE IF NOT EXISTS `little_lemon`.`menu_item` (
  `menu_item_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `type` VARCHAR(255) NOT NULL,
  `price` DECIMAL(12,2) NOT NULL,
  `active` TINYINT NOT NULL DEFAULT 1,
  `menu_id` INT NOT NULL,
  PRIMARY KEY (`menu_item_id`),
  INDEX `fk_menu_item__menu1_idx` (`menu_id` ASC) VISIBLE,
  CONSTRAINT `fk_menu_item__menu1`
    FOREIGN KEY (`menu_id`)
    REFERENCES `little_lemon`.`menu` (`menu_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `little_lemon`.`booking`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `little_lemon`.`booking` ;

CREATE TABLE IF NOT EXISTS `little_lemon`.`booking` (
  `booking_id` INT NOT NULL AUTO_INCREMENT,
  `table_number` VARCHAR(255) NOT NULL,
  `resevertation_date` DATETIME NOT NULL DEFAULT NOW(),
  `people_quantity` TINYINT UNSIGNED NOT NULL,
  `created_date` DATETIME NOT NULL DEFAULT NOW(),
  `customer_id` INT NOT NULL,
  `active` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`booking_id`),
  INDEX `fk_booking_customer1_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_booking_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `little_lemon`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `little_lemon`.`order_detail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `little_lemon`.`order_detail` ;

CREATE TABLE IF NOT EXISTS `little_lemon`.`order_detail` (
  `order_detail_id` INT NOT NULL AUTO_INCREMENT,
  `quantity` SMALLINT UNSIGNED NOT NULL,
  `price` DECIMAL(12,2) NOT NULL,
  `cost` DECIMAL(12,2) NOT NULL,
  `order_id` INT NOT NULL,
  `menu_item_id` INT NOT NULL,
  PRIMARY KEY (`order_detail_id`),
  INDEX `fk_order_detail_order1_idx` (`order_id` ASC) VISIBLE,
  INDEX `fk_order_detail_menu1_idx` (`menu_item_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_detail_order1`
    FOREIGN KEY (`order_id`)
    REFERENCES `little_lemon`.`orders` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_detail_menu1`
    FOREIGN KEY (`menu_item_id`)
    REFERENCES `little_lemon`.`menu_item` (`menu_item_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `little_lemon`.`order_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `little_lemon`.`order_status` ;

CREATE TABLE IF NOT EXISTS `little_lemon`.`order_status` (
  `order_status_id` INT NOT NULL AUTO_INCREMENT,
  `status` VARCHAR(45) NULL,
  `last_update_date` DATETIME NULL,
  `order_id` INT NOT NULL,
  PRIMARY KEY (`order_status_id`),
  INDEX `fk_order_status_order1_idx` (`order_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_status_order1`
    FOREIGN KEY (`order_id`)
    REFERENCES `little_lemon`.`orders` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
