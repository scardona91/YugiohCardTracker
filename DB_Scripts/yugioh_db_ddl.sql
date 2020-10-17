-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema yugioh_db
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `yugioh_db` ;

-- -----------------------------------------------------
-- Schema yugioh_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `yugioh_db` DEFAULT CHARACTER SET utf8 ;
USE `yugioh_db` ;

-- -----------------------------------------------------
-- Table `yugioh_db`.`card`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `yugioh_db`.`card` ;

CREATE TABLE IF NOT EXISTS `yugioh_db`.`card` (
  `card_id` INT NOT NULL,
  `name` VARCHAR(1000) NULL DEFAULT NULL,
  `type` VARCHAR(45) NULL DEFAULT NULL,
  `level_rank` INT NULL DEFAULT NULL,
  `attribute` VARCHAR(45) NULL DEFAULT NULL,
  `race` VARCHAR(45) NULL DEFAULT NULL,
  `attack` INT NULL DEFAULT NULL,
  `defense` INT NULL DEFAULT NULL,
  `pendulum_effect` VARCHAR(4000) NULL DEFAULT NULL,
  `des_effect` VARCHAR(4000) NULL DEFAULT NULL,
  PRIMARY KEY (`card_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = '	';


-- -----------------------------------------------------
-- Table `yugioh_db`.`card_img`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `yugioh_db`.`card_img` ;

CREATE TABLE IF NOT EXISTS `yugioh_db`.`card_img` (
  `card_id` INT NOT NULL,
  `lrg_image` LONGBLOB NOT NULL,
  `sml_image` LONGBLOB NOT NULL,
  PRIMARY KEY (`card_id`),
  CONSTRAINT `card_id`
    FOREIGN KEY (`card_id`)
    REFERENCES `yugioh_db`.`card` (`card_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `yugioh_db`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `yugioh_db`.`user` ;

CREATE TABLE IF NOT EXISTS `yugioh_db`.`user` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NULL DEFAULT NULL,
  `last_name` VARCHAR(45) NULL DEFAULT NULL,
  `password_hash` VARCHAR(100) NULL DEFAULT NULL,
  `active` TINYINT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `yugioh_db`.`user_inventory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `yugioh_db`.`user_inventory` ;

CREATE TABLE IF NOT EXISTS `yugioh_db`.`user_inventory` (
  `user_id` INT NOT NULL,
  `card_id` INT NULL DEFAULT NULL,
  `total_quantity` INT NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  INDEX `user_inventory_card_id_idx` (`card_id` ASC) VISIBLE,
  CONSTRAINT `user_inventory_card_id`
    FOREIGN KEY (`card_id`)
    REFERENCES `yugioh_db`.`card` (`card_id`),
  CONSTRAINT `user_inventory_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `yugioh_db`.`user` (`user_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `yugioh_db`.`deck`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `yugioh_db`.`deck` ;

CREATE TABLE IF NOT EXISTS `yugioh_db`.`deck` (
  `deck_id` INT NOT NULL AUTO_INCREMENT,
  `deck_name` VARCHAR(45) NULL DEFAULT NULL,
  `card_id` INT NULL DEFAULT NULL,
  `card_quantity` INT NULL DEFAULT NULL,
  PRIMARY KEY (`deck_id`),
  INDEX `deck_card_id_idx` (`card_id` ASC) VISIBLE,
  CONSTRAINT `deck_card_id`
    FOREIGN KEY (`card_id`)
    REFERENCES `yugioh_db`.`user_inventory` (`card_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = '		';

USE `yugioh_db` ;

-- -----------------------------------------------------
-- procedure sp_insert_card
-- -----------------------------------------------------

USE `yugioh_db`;
DROP procedure IF EXISTS `yugioh_db`.`sp_insert_card`;

DELIMITER $$
USE `yugioh_db`$$
CREATE PROCEDURE `sp_insert_card`(
  in p_card_id INT,
  in p_name VARCHAR(1000),
  in p_type VARCHAR(45),
  in p_level_rank INT,
  in p_attribute VARCHAR(45),
  in p_race VARCHAR(45),
  in p_attack INT,
  in p_defense INT,
  in p_pendulum_effect VARCHAR(4000),
  in p_des_effect VARCHAR(4000)
)
begin
  insert into card (
  card_id,
  name,
  type,
  level_rank,
  attribute,
  race,
  attack,
  defense,
  pendulum_effect,
  des_effect
  )
  values(
  p_card_id,
  p_name,
  p_type,
  p_level_rank,
  p_attribute,
  p_race,
  p_attack,
  p_defense,
  p_pendulum_effect,
  p_des_effect
  );
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_insert_card_img
-- -----------------------------------------------------

USE `yugioh_db`;
DROP procedure IF EXISTS `yugioh_db`.`sp_insert_card_img`;

DELIMITER $$
USE `yugioh_db`$$
CREATE PROCEDURE `sp_insert_card_img`(
  in p_card_id INT,
  in p_lrg_image longblob,
  in p_sml_image longblob
)
begin
  insert into card_img (
  card_id,
  lrg_image,
  sml_image
  )
  values(
  p_card_id,
  p_lrg_image,
  p_sml_image
  );
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_select_all_card_ids
-- -----------------------------------------------------

USE `yugioh_db`;
DROP procedure IF EXISTS `yugioh_db`.`sp_select_all_card_ids`;

DELIMITER $$
USE `yugioh_db`$$
CREATE PROCEDURE `sp_select_all_card_ids`()
begin
	select 
		card_id
	from
		card
	;
end$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
