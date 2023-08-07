USE EPSTS;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

CREATE TABLE `Type` (
    `typeID` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`typeID`),
    INDEX `name_idx` (`name`)
);


INSERT INTO `Type` (`typeID`, `name`) VALUES
    (1, 'Admin'),
    (2, 'Employee'),
    (3, 'Student');


CREATE TABLE `User` (
    `userID` INT NOT NULL AUTO_INCREMENT,
    `firstName` VARCHAR(45) NOT NULL,
    `lastName` VARCHAR(45) NOT NULL,
    `username` VARCHAR(45) NOT NULL UNIQUE,
    `password` VARCHAR(64) NOT NULL DEFAULT '123',
    `type` VARCHAR(255) NOT NULL,
    `workLocation` VARCHAR(255) DEFAULT NULL,
    `address` VARCHAR(255) DEFAULT NULL,
    `email` VARCHAR(110) NOT NULL,
    PRIMARY KEY (`userID`),
    INDEX `type_idx` (`type` ASC) VISIBLE,
    CONSTRAINT `type`
    FOREIGN KEY (`type`)
    REFERENCES `EPSTS`.`Type` (`name`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);


INSERT INTO `User` (`userID`, `firstName`, `lastName`, `username`, `password`, `type`, `email`)
VALUES
    ('1', 'Mohammad', 'Alshikh', 'admin', '123', 'Admin', 'epsts438@gmail.com');


CREATE TABLE Employee(
                         medicareNumb int(10) PRIMARY KEY,
                         medicareExp date,
                         firstName varchar(255),
                         lastName varchar (255),
                         telephoneNumb bigint,
                         dateOfBirth date,
                         address varchar(255),
                         city varchar(255),
                         email varchar(255),
                         postalCode varchar(7),
                         province varchar(255),
                         citizenship varchar(255),
                         isPresident boolean);


DELIMITER //

CREATE TRIGGER AfterInsertEmployee
    AFTER INSERT ON Employee FOR EACH ROW
BEGIN
    DECLARE newUsername VARCHAR(255);
    DECLARE usernameCount INT DEFAULT 1;

    SET newUsername = CONCAT(NEW.firstName, NEW.lastName);

    -- Check if the generated username already exists
    WHILE EXISTS (SELECT 1 FROM User WHERE username = newUsername) DO
            SET newUsername = CONCAT(NEW.firstName, NEW.lastName, usernameCount);
            SET usernameCount = usernameCount + 1;
        END WHILE;

    INSERT INTO User (firstName, lastName, username, type, address, email)
    VALUES (NEW.firstName, NEW.lastName, newUsername, 'Employee', NEW.address, NEW.email);
END;

//

DELIMITER ;


CREATE TABLE Student(
                        medicareNumb int(10) PRIMARY KEY,
                        medicareExp date,
                        firstName varchar(255),
                        lastName varchar (255),
                        telephoneNumb bigint,
                        dateOfBirth date,
                        address varchar(255),
                        city varchar(255),
                        email varchar(255),
                        postalCode varchar(7),
                        province varchar(255),
                        citizenship varchar(255));


DELIMITER //

CREATE TRIGGER AfterInsertStudent
    AFTER INSERT ON Student FOR EACH ROW
BEGIN
    DECLARE newUsername VARCHAR(255);
    DECLARE usernameCount INT DEFAULT 1;

    SET newUsername = CONCAT(NEW.firstName, NEW.lastName);

    -- Check if the generated username already exists
    WHILE EXISTS (SELECT 1 FROM User WHERE username = newUsername) DO
            SET newUsername = CONCAT(NEW.firstName, NEW.lastName, usernameCount);
            SET usernameCount = usernameCount + 1;
        END WHILE;

    INSERT INTO User (firstName, lastName, username, type, address, email)
    VALUES (NEW.firstName, NEW.lastName, newUsername, 'Student', NEW.address, NEW.email);
END;

//

DELIMITER ;



INSERT INTO Employee (medicareNumb, medicareExp, firstName, lastName,
                      telephoneNumb, dateOfBirth, address, city, email, postalCode,
                      province, citizenship, isPresident)
VALUES
    (123456789, '2023-09-01', 'John', 'Smith', 5141234567, '1985-05-15',
     '123 Main Street', 'Montreal', 'john.smith@gmail.com', 'H3Z 1A2',
     'Quebec', 'Canadian', FALSE),
    (987654321, '2024-02-01', 'Emily', 'Johnson', 5149876544,
     '1990-11-28', '456 Elm Avenue', 'Verdun', 'emily.johnson@gmail.com',
     'H2W 2R9', 'Quebec', 'American', FALSE),
    (246813579, '2025-07-01', 'Michael', 'Brown', 5144567893,
     '1982-03-10', '789 Maple Drive', 'Montreal',
     'michael.brown@gmail.com', 'H1X 3T7', 'Quebec', 'British', FALSE),
    (135792468, '2023-12-01', 'Jennifer', 'Lee', 5147891232, '1993-09-22',
     '101 Oak Lane', 'St-Laurent', 'jennifer.lee@gmail.com', 'H4C 2P4',
     'Quebec', 'Australian', FALSE),
    (864209753, '2024-03-01', 'Daniel', 'Anderson', 5146543214,
     '1988-06-05', '555 Pine Street', 'Montreal',
     'daniel.anderson@gmail.com', 'H2Y 1E5', 'Quebec', 'Canadian', FALSE),
    (579312468, '2025-01-01', 'Olivia', 'White', 5142345673, '1991-12-17',
     '222 Cedar Road', 'Montreal', 'olivia.white@gmail.com', 'H3B 3Y1',
     'Quebec', 'French', TRUE),
    (102938475, '2024-06-01', 'Alexander', 'Martinez', 5143456784,
     '1983-08-20', '777 Birch Boulevard', 'Montreal',
     'alexander.martinez@gmail.com', 'H1Y 4N8', 'Quebec', 'Mexican',
     FALSE),
    (726384915, '2023-11-01', 'Sophia', 'Scott', 5145678903, '1987-04-03',
     '321 Rose Crescent', 'Laval', 'sophia.scott@gmail.com', 'H7X 3K4',
     'Quebec', 'Canadian', TRUE),
    (394857621, '2024-08-01', 'William', 'Taylor', 5148765434,
     '1995-01-12', '444 Walnut Place', 'Montreal',
     'william.taylor@gmail.com', 'H4A 1W7', 'Quebec', 'American', FALSE),
    (617283945, '2025-06-01', 'Mia', 'Adams', 5147654325, '1994-07-25',
     '888 Ash Street', 'Dorval', 'mia.adams@gmail.com', 'H3G 1M8',
     'Quebec', 'Canadian', FALSE);


INSERT INTO Student (medicareNumb, medicareExp, firstName, lastName,
                     telephoneNumb, dateOfBirth, address, city, email, postalCode,
                     province, citizenship)
VALUES
    (392740274, '2023-11-01', 'Ludjina', 'Benoit', 5142947294,
     '1999-06-03', '250 Montreal Street', 'Montreal',
     'ludjinabenoit@gmail.com', 'H3A 9D8', 'Quebec', 'Haitian'),
    (103846593, '2024-09-01', 'Amanda', 'Beronilla', 5149275027,
     '2000-10-07', '60 Rue Canada', 'Dorval', 'amandaberonilla@gmail.com',
     'H9S 3A2', 'Quebec', 'Filipino'),
    (134749375, '2025-01-01', 'Abdurrahim', 'Gigani', 4381073929,
     '2001-02-13', '350 Pineapple Street', 'Saint-Laurent',
     'abdurrahimgigani@gamail.com', 'J3G 9A9', 'Quebec', 'Indian'),
    (759301758, '2024-10-01', 'Nauar', 'Rekmani', 5147290733,
     '1998-04-25', '1914 Libya Street', 'Laval', 'nauarrekmani@gmail.com',
     'H0F 2K5', 'Quebec', 'Brazilian'),
    (374037274, '2023-12-01', 'Mohammad', 'Alshikh', 5147284051,
     '1998-03-28', '43 Shark Avenue', 'Verdun',
     'mohammadalshikh@gmail.com', 'H3S 5K1', 'Quebec', 'Syrian'),
    (673904744, '2024-05-01', 'Enam', 'Adib', 5140274926, '1999-12-12',
     '103 Rue Ophelia', 'Montreal', 'enamadib@gmail.com', 'H8S 4U3',
     'Quebec', 'Bengali'),
    (175037407, '2023-07-21', 'Jing-Ling', 'Chen', 5140273932,
     '2003-11-09', '314 Pi Avenue', 'Montreal', 'jinglingchen@gmail.com',
     'H0S 2I4', 'Quebec', 'Canadian'),
    (856217404, '2024-05-01', 'Michael', 'Jackson', 5147293372,
     '1996-08-29', '2908 Hee Hee Street', 'Laval',
     'michaeljackson@gmail.com', 'H8D 3T5', 'Quebec', 'American'),
    (673920438, '2024-07-01', 'Britney', 'Spears', 5140583924,
     '1990-09-30', '1202 Toxic Street', 'Dorval',
     'britneyspears@gmail.com', 'H92 8B7', 'Quebec', 'American'),
    (389173840, '2025-06-01', 'Corey', 'Taylor', 5142930264, '2000-05-12',
     '128 Custer Avenue', 'Dorval', 'coreytaylor@gmail.com', 'H4N 5C1',
     'Quebec', 'American');
