
-- =============================================================================
-- Author:      Caleb Slater
-- Description: Assignment 1
-- =============================================================================

-- =============================================================================
--                      PART 1
-- =============================================================================

CREATE DATABASE IF NOT EXISTS `cs4430_a1_1`;

-- The Product relation gives the manufacturer, model number and type (PC, laptop, or printer) of various products.
DROP TABLE IF EXISTS `Product`;
CREATE TABLE `Product`(
    `maker` VARCHAR(50) NOT NULL,
    `model` VARCHAR(50) NOT NULL,
    `type` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`model`, `maker`)
);

-- The PC relation gives for each model number the CPU speed (in GHz), memory size (in MB), hard disk size (in GB), and the price.
DROP TABLE IF EXISTS `PC`;
CREATE TABLE `PC`(
    `model` VARCHAR(50) NOT NULL,
    `speed` REAL UNSIGNED NOT NULL,
    `ram` INT UNSIGNED NOT NULL,
    `hdisk` INT UNSIGNED NOT NULL,
    `price` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY(`model`)
);

-- The Laptop relation is similar, except that the screen size (in inches) is also included.
DROP TABLE IF EXISTS `Laptop`;
CREATE TABLE `Laptop` (
    `model` VARCHAR(50) NOT NULL,
    `speed` REAL UNSIGNED NOT NULL,
    `ram` INT UNSIGNED NOT NULL,
    `hdisk` INT UNSIGNED NOT NULL,
    `screen` INT UNSIGNED NOT NULL,
    `price` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY(MODEL)
);

-- The Printer relation records for each printer model whether the printer outputs color or not, the printer type (laser or inkjet, etc.), and the price.
DROP TABLE IF EXISTS `Printer`;
CREATE TABLE `Printer` (
    `model` VARCHAR(50) NOT NULL,
    `color` BOOLEAN NOT NULL,
    `type` VARCHAR(50) NOT NULL,
    `price` REAL NOT NULL,
    PRIMARY KEY(`model`)
);

-- =============================================================================
--                      DATABASE 2
-- =============================================================================

CREATE DATABASE IF NOT EXISTS `cs4430_a1_2`;

-- Ships are built in “classes” from the same design, and the class is usually named for the first ship of that class. The relation Classes records the name of the class, the type (’bb ’ for battleship or ’bc’ for battlecruiser), the country that built the ship, the number of main guns, the bore (diameter of the gun barrel, in inches) of the main guns, and the displacement (weight, in tons).
DROP TABLE IF EXISTS `Classes`;
CREATE TABLE `Classes` (
    `class` VARCHAR(50) NOT NULL,
    `type` CHAR(2) NOT NULL,
    `country` CHAR(3) NOT NULL,
    `guns` INT UNSIGNED NOT NULL,
    `bore` REAL NOT NULL,
    `displacement` REAL,
    PRIMARY KEY(`class`)
);

-- Relation Ships records the name of the ship, the name of its class, and the year in which the ship was launched.
DROP TABLE IF EXISTS `Ships`;
CREATE TABLE `Ships` (
    `name` VARCHAR(50) NOT NULL,
    `class` VARCHAR(50) NOT NULL,
    `launched` INT UNSIGNED, -- ALLOW SHIPS which weren't launched
    PRIMARY KEY(`name`)
);

-- Relation Battlesgives the name and date of battles involving these ships
DROP TABLE IF EXISTS `Battles`;
CREATE TABLE `Battles` (
    `name` VARCHAR(50) NOT NULL,
    `bdate` DATE NOT NULL,
    PRIMARY KEY(`name`)
);

-- relation Outcomes gives the result (sunk,damaged, or ok) for each ship in each battle
DROP TABLE IF EXISTS `Outcomes`;
CREATE TABLE `Outcomes` (
    `ship` VARCHAR(50) NOT NULL,
    `battle` VARCHAR(50) NOT NULL,
    `result` VARCHAR(7), -- longest char length of list
    PRIMARY KEY(`ship`, `battle`)
);

-- =============================================================================
--                      DATABASE 3
-- =============================================================================


CREATE DATABASE IF NOT EXISTS`cs4430_a1_3`;

DROP TABLE IF EXISTS `Employees`;
CREATE TABLE  `Employees`(
    `Eno` INT UNSIGNED NOT NULL,
    `Ename` VARCHAR(100) NOT NULL,
    `Hire_Date` DATETIME NOT NULL,
    PRIMARY KEY (`Eno`)
);

DROP TABLE IF EXISTS `Books`;
CREATE TABLE `Books`(
    `Isbn` VARCHAR(13) NOT NULL, -- allow 10 digit and 13 digit w/leading zeros
    `Bname` VARCHAR(100) NOT NULL,
    `Quantity` INT UNSIGNED NOT NULL,
    `Price` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY(`Isbn`)
);

DROP TABLE IF EXISTS `Customers`;
CREATE TABLE `Customers` (
    `Cno` INT UNSIGNED NOT NULL,
    `Cname` VARCHAR(100) NOT NULL,
    `Street` VARCHAR(100) NOT NULL,
    `Zip` VARCHAR(9), -- allow zips like 12345-6789
    `Phone` VARCHAR(11), -- 1 234 567 8910
    PRIMARY KEY (`Cno`)
);

DROP TABLE IF EXISTS `Orders`;
CREATE TABLE `Orders` (
    `Ono` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Cno` INT UNSIGNED NOT NULL,
    `Eno` INT UNSIGNED NOT NULL,
    `Received` DATETIME,
    `Shipped` DATETIME,
    PRIMARY KEY(`Ono`)
);

DROP TABLE IF EXISTS `Orderline`;
CREATE TABLE `Orderline` (
    `Ono` INT UNSIGNED NOT NULL,
    `Isbn` VARCHAR(13),
    `Qty` INT UNSIGNED NOT NULL,
    PRIMARY KEY(`Ono`)
);

DROP TABLE IF EXISTS `Zipcodes`;
CREATE TABLE `Zipcodes` (
    `Zip` VARCHAR(9),
    `City` VARCHAR(100),
    `State` CHAR(2) NOT NULL,
    PRIMARY KEY(`Zip`)
);


-- =============================================================================
--                      PART 2
-- =============================================================================

-- For the computer database, write expressions of relational algebra to answer the following queries:
USE DATABASE `cs4430_a1_1`;
-- 1.What PC models have a speed of at least 3.00?
SELECT `models` FROM `PC` WHERE `speed` > 3.00;
-- 2.Which manufacturers make laptops with a hard disk of at least 100GB?
SELECT `Product`.`maker` FROM `Product`
INNER JOIN `Laptop` ON (`Product`.`model` = `Laptop`.`model`)
WHERE `Laptop`.`hdisk` > 100;
-- 3.Find the model number and price of all products (of any type) made by manufacturer B.
SELECT `model`, `price` FROM `Product`
INNER JOIN `PC` ON (`Product`.`model` = `PC`.`model`)
INNER JOIN `Laptop` ON (`Product`.`model` = `Laptop`.`model`)
INNER JOIN `Printer` ON (`Product`.`model` = `Printer`.`model`)
WHERE `maker` = 'B';
-- 4.Find the model numbers of all color laser printers
SELECT `model` FROM `Printer`
WHERE `color` = 1;
-- 5.Find those manufacturers that sell Laptops, but not PC ’s.
SELECT `maker` FROM `Product`
WHERE
    `type` = 'laptop'
    AND
    `maker` NOT IN (
        SELECT `maker` FROM `Product` WHERE `type` = 'PC'
    );
-- 6.Find those hard-disk sizes that occur in two or more PC’s.
SELECT DISTINCT `hdisk` FROM `PC`
GROUP BY `hdisk`
HAVING COUNT(`hdisk`) > 1;
-- 7.Find those pairs of PC models that have both the same speed and RAM. A pair should be listed only once; e.g., list (i, j) but not (j, i).
SELECT `PC`.`model`, `PC2`.`model` FROM `PC`
INNER JOIN `PC` as `PC2` ON (`PC`.`speed` = `PC2`.`ram`);
-- 8. Find those manufacturers of at least two different computers (PC’s or laptops) with speeds of at least 2.80.
SELECT `Product`.`maker` FROM `Product`
LEFT JOIN `PC` ON (`Product`.`model` = `PC`.`model`)
LEFT JOIN `Laptop` ON (`Product`.`model` = `Laptop`.`model`)
WHERE `PC`.`speed` > 2.80 OR `Laptop`.`speed` > 2.80
GROUP BY `Product`.`maker`
HAVING COUNT(`Product`.`maker`) > 1;
-- 9. Find the manufacturers of PC ’s with at least three different speeds.
SELECT `Product`.`maker` FROM `Product`
INNER JOIN `PC` ON (`Product`.`model` = `PC`.`model`)
GROUP BY `Product`.`maker`
HAVING COUNT(DISTINCT `PC`.`speed`) >= 3;
-- 10. Find the manufacturers who sell at least three different models of PC.
SELECT `maker` FROM `Product`
WHERE `type` = 'PC'
GROUP BY `maker`
HAVING COUNT(`model`) > 2;

-- For the bookstore database, write expressions of relational algebra to answer the following queries:
USE DATABASE `cs4430_a1_3`;
-- 21.list customers (cnd, name) the zip of whose address is 49008.
SELECT `cnd`, `name` FROM `Customers`
WHERE `Zip` LIKE '49008';
-- 22.list customers (cno’s and names) who live in Michigan.
SELECT `Customers`.`cno`, `Customers`.`name` FROM `Customers`
LEFT JOIN `Zipcodes` ON (`Customers`.`Zip` = `Zipcodes`.`Zip`)
WHERE `Zipcodes`.`State` LIKE 'MI';
-- 23.list employees (names) who have customers in Michigan.
SELECT `Customers`.`cno`, `Customers`.`name` FROM `Customers`
LEFT JOIN `Zipcodes` ON (`Customers`.`Zip` = `Zipcodes`.`Zip`)
WHERE `Zipcodes`.`State` LIKE 'MI';
-- 24.list employees (names) who have both 49008-zipcode customers and 49009-zipcode customers.
SELECT `Employees`.`Ename` FROM `Orders`
INNER JOIN `Employees` ON (`Employees`.`Eno` = `Orders`.`Eno`)
INNER JOIN `Customers` ON (`Customers`.`Cno` = `Customers`.`Cno`)
WHERE `Customers`.`Zipcodes` IN ('49008', '49009');
-- 25.list customers (names) who've ordered books through an employee named 'Jones'.
SELECT `Customers`.`Cname` FROM `Orders`
INNER JOIN `Employees` ON (`Employees`.`Eno` = `Orders`.`Eno`)
INNER JOIN `Customers` ON (`Customers`.`Cno` = `Customers`.`Cno`)
WHERE `Employees`.`Ename` LIKE 'Jones';
-- 26.list customers (names) who've NOT ordered the book "Database".
SELECT `Cname` FROM `Customers`
WHERE `Cno` IN (
    SELECT `Orders`.`Cno` FROM `Orderline`
    INNER JOIN `Books` ON (`Orderline`.`Isbn` = `Books`.`Isbn`)
    INNER JOIN `Orders` ON (`Orderline`.`Ono` = `Orders`.`Ono`)
    WHERE `Books`.`Bname` NOT LIKE 'Database'
);
-- 27.all possible pairs of books (Bname’s). (A pair should be listed only once).
-- Assume order doesn't matter
SELECT `Books`.`Bname` AS `b1`, `Books2`.`Bname` AS `b2` FROM `Books`
CROSS JOIN `Books` AS `Books2`;
-- 28.all possible pairs of books (Bname’s) where the first has a price of 24.99 and the second has a price of 19.99.
SELECT `Books`.`Bname` AS `b1`, `Books2`.`Bname` AS `b2` FROM `Books`
CROSS JOIN `Books` AS `Books2`
WHERE
    `Books`.`Price` = 24.99
    AND `Books2`.`Price` = 19.99;
-- 29. customers (names) who ordered at least one book that customer #1111 ordered.
SELECT DISTINCT `Customers`.`Cname` FROM `Orderline`
INNER JOIN `Books` ON (`Orderline`.`Isbn` = `Books`.`Isbn`)
INNER JOIN `Orders` ON (`Orderline`.`Ono` = `Orders`.`Ono`)
RIGHT JOIN `Customers` ON(`Orders`.`Cno` = `Customers`.`Cno`)
WHERE
    `Books`.`Isbn` IN (
        SELECT `Isbn` FROM `Orderline`
        INNER JOIN `Orders` ON (`Orderline`.`Ono` = `Orders`.`Ono`)
        WHERE `Orders`.`Cno` = '1111'
    );
-- 30. customers (names) who ordered all the books as customer #11111 ordered (although, they may have ordered additional books).
SELECT DISTINCT `Cname` FROM `Customers`
RIGHT JOIN `Orders` ON (`Customers`.`Cno` = `Orders`.`Cno`)
RIGHT JOIN `Orderline` ON (`Orders`.`Ono` = `Orderline`.`Ono`)
WHERE
    `Orderline`.`Isbn` IN (
        SELECT `Isbn` FROM `Orderline`
        INNER JOIN `Orders` ON (`Orders`.`Ono` = `Orderline`.`Ono`)
        WHERE `Orders`.`Cno` = 11111
    );

-- =============================================================================
--                      Example Dataset
-- =============================================================================
-- INSERT INTO `Product` VALUES('maker-a', 'pc-a', 'pc');
-- INSERT INTO `Product` VALUES('maker-b', 'pc-b', 'pc');
-- INSERT INTO `Product` VALUES('maker-c', 'pc-c', 'pc');
-- INSERT INTO `Product` VALUES('maker-c', 'pc-d', 'pc');
-- INSERT INTO `Product` VALUES('maker-a', 'laptop-a', 'laptop');
-- INSERT INTO `Product` VALUES('maker-b', 'laptop-b', 'laptop');
-- INSERT INTO `Product` VALUES('maker-c', 'laptop-c', 'laptop');
-- INSERT INTO `Product` VALUES('maker-c', 'laptop-d', 'laptop');
-- INSERT INTO `PC` VALUES('pc-a', 2.9, 2, 3, 4);
-- INSERT INTO `PC` VALUES('pc-b', 2.7, 3, 4, 5);
-- INSERT INTO `PC` VALUES('pc-c', 2.95, 2, 3, 4);
-- INSERT INTO `PC` VALUES('pc-d', 3, 2, 3, 4);
-- INSERT INTO `Laptop` VALUES('laptop-a', 2.9, 2, 3, 4, 10.11);
-- INSERT INTO `Laptop` VALUES('laptop-b', 2.7, 2, 3, 4, 10.11);
-- INSERT INTO `Laptop` VALUES('laptop-c', 2.95, 2, 3, 4, 10.11);
-- INSERT INTO `Laptop` VALUES('laptop-d', 3, 2, 3, 4, 10.11);

-- INSERT INTO `Books` VALUES('1234', 'a', 2, 20.25);
-- INSERT INTO `Books` VALUES('1235', 'b', 3, 10);
-- INSERT INTO `Books` VALUES('1236', 'c', 2, 20.25);
-- INSERT INTO `Books` VALUES('1237', 'Database', 2, 30);
-- INSERT INTO `Orders` VALUES(1, 1, 1, NOW(), NOW());
-- INSERT INTO `Orders` VALUES(2, 2, 2, NOW(), NOW());
-- INSERT INTO `Orderline` VALUES(1, '1234', 1);
-- INSERT INTO `Customers` VALUES(1, 'cust-a', '1234 main', '49006', '1234');
-- INSERT INTO `Customers` VALUES(2, 'cust-b', '1235 main', '49007', '1235');
-- INSERT INTO `Orderline` VALUES(1, '1237', 1);
