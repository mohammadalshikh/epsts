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
    `email` VARCHAR(110) UNIQUE NOT NULL,
    `medicareNumb` int(10) UNIQUE NOT NULL,
    PRIMARY KEY (`userID`),
    INDEX `type_idx` (`type` ASC) VISIBLE,
    CONSTRAINT `type`
    FOREIGN KEY (`type`)
    REFERENCES `EPSTS`.`Type` (`name`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);


INSERT INTO `User` (`userID`, `firstName`, `lastName`, `username`, `password`, `type`, `email`, `medicareNumb`)
VALUES
    ('1', 'Mohammad', 'Alshikh', 'admin', '123', 'Admin', 'epsts438@gmail.com', 000000001);


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

    INSERT INTO User (firstName, lastName, username, type, address, email, medicareNumb)
    VALUES (NEW.firstName, NEW.lastName, newUsername, 'Employee', NEW.address, NEW.email, NEW.medicareNumb);
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

    INSERT INTO User (firstName, lastName, username, type, address, email, medicareNumb)
    VALUES (NEW.firstName, NEW.lastName, newUsername, 'Student', NEW.address, NEW.email, NEW.medicareNumb);
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

CREATE TABLE Facility(
                         facilityId bigint PRIMARY KEY,
                         name varchar(255),
                         province varchar(255),
                         address varchar(255),
                         city varchar(255),
                         capacity bigint,
                         phoneNumb bigint,
                         postalCode varchar(15),
                         webAddress varchar(255));

CREATE TABLE Ministry (
                          name varchar(255) PRIMARY KEY,
                          facilityId bigint REFERENCES HeadOffice(facilityId) ON UPDATE
                              CASCADE, UNIQUE(facilityId));

CREATE TABLE HeadOffice (
                            facilityId bigint PRIMARY KEY,
                            ministryName varchar(255) NOT NULL,
                            FOREIGN KEY (facilityId) REFERENCES Facility(facilityId) ON UPDATE
                                CASCADE,
                            FOREIGN KEY (ministryName) REFERENCES Ministry(name) ON UPDATE
                                CASCADE );

CREATE UNIQUE INDEX idx_HeadOffice_ministryName ON HeadOffice
    (ministryName);


CREATE TABLE GMF (
                     facilityId bigint PRIMARY KEY,
                     FOREIGN KEY (facilityId) REFERENCES Facility(facilityId) ON
                         UPDATE CASCADE);

CREATE TABLE EF (
                    facilityId bigint PRIMARY KEY,
                    primary_school boolean,
                    middle boolean,
                    high boolean,
                    FOREIGN KEY (facilityId) REFERENCES Facility(facilityId) ON
                        UPDATE CASCADE);

CREATE TABLE ManagementFacility(
                                   facilityId bigint PRIMARY KEY,
                                   FOREIGN KEY (facilityId) REFERENCES Facility(facilityId) ON
                                       UPDATE CASCADE);


CREATE TABLE President(
                          medicareNumb int(10),
                          facilityId bigint,
                          startDate date,
                          endDate date,
                          PRIMARY KEY (medicareNumb, facilityId, startDate),
                          FOREIGN KEY (medicareNumb) REFERENCES Employee(medicareNumb) ON
                              UPDATE CASCADE,
                          FOREIGN KEY (facilityId) REFERENCES HeadOffice(facilityId) ON
                              UPDATE CASCADE);

CREATE TABLE StudiesAt (
                           medicareNumb int(10) REFERENCES Student(medicareNumb) ON UPDATE
                               CASCADE,
                           facilityId bigint REFERENCES Facility(facilityId) ON UPDATE
                               CASCADE,
                           startDate date,
                           endDate date,
                           currentLevel varchar(255),
                           PRIMARY KEY (medicareNumb, facilityId, startDate));

CREATE TABLE WorksAt (
                         medicareNumb int(10) REFERENCES Employee(medicareNumb) ON UPDATE
                             CASCADE,
                         facilityId bigint REFERENCES Facility(facilityId) ON UPDATE
                             CASCADE,
                         startDate date,
                         endDate date,
                         role varchar(255),
                         specialisation varchar(255),
                         schoolCounselor varchar(1),
                         programDirector varchar(1),
                         schoolAdministrator varchar(1),
                         PRIMARY KEY (medicareNumb, facilityId, startDate),
                         CHECK (
                                 (role != 'Secondary Teacher' AND specialisation IS NULL AND
                                  schoolCounselor IS NULL AND programDirector IS NULL AND
                                  schoolAdministrator IS NULL)
                                 OR
                                 (role = 'Secondary Teacher' AND (specialisation IS NOT NULL OR
                                                                  schoolCounselor = '1' OR programDirector = '1' OR
                                                                  schoolAdministrator = '1'))
                             ));

CREATE TABLE HasFacilities (
                               ministryName varchar(255) REFERENCES Ministry(name) ON UPDATE
                                   CASCADE,
                               facilityId bigint REFERENCES Facility(facilityId) ON UPDATE
                                   CASCADE,
                               isGMF boolean,
                               isEF boolean,
                               PRIMARY KEY (ministryName, facilityId));


CREATE TABLE Infection (
                           infectionId int(10) PRIMARY KEY,
                           medicareNumbStudent int(10),
                           medicareNumbEmployee int(10),
                           date date,
                           type varchar(255),
                           FOREIGN KEY (medicareNumbStudent) REFERENCES
                               Student(medicareNumb) ON UPDATE CASCADE,
                           FOREIGN KEY (medicareNumbEmployee) REFERENCES
                               Employee(medicareNumb) ON UPDATE CASCADE);


ALTER TABLE `EPSTS`.`Infection`
    AUTO_INCREMENT = 1 ,
    CHANGE COLUMN `infectionId` `infectionId` INT NOT NULL AUTO_INCREMENT ;


CREATE TABLE Vaccine (
                         vaccineId int(10) PRIMARY KEY,
                         medicareNumbStudent int(10),
                         medicareNumbEmployee int(10),
                         date date,
                         type varchar(255),
                         doseNumb int(3),
                         FOREIGN KEY (medicareNumbStudent) REFERENCES
                             Student(medicareNumb) ON UPDATE CASCADE,
                         FOREIGN KEY (medicareNumbEmployee) REFERENCES
                             Employee(medicareNumb) ON UPDATE CASCADE);


ALTER TABLE `EPSTS`.`Vaccine`
    AUTO_INCREMENT = 1 ,
    CHANGE COLUMN `vaccineId` `vaccineId` INT NOT NULL AUTO_INCREMENT ;


CREATE TABLE Log (
                     logID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                     date DATETIME NOT NULL,
                     sender VARCHAR(255) NOT NULL,
                     receiver VARCHAR(255) NOT NULL,
                     body TEXT NOT NULL,
                     subject VARCHAR(255) NOT NULL
);


DELIMITER //
CREATE TRIGGER tr_check_head_office
    BEFORE INSERT ON Ministry
    FOR EACH ROW
BEGIN
    IF NEW.facilityId IS NOT NULL THEN
        IF EXISTS (SELECT 1 FROM HeadOffice WHERE ministryName =
                                                  NEW.name) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'The ministry already has a HeadOffice
facility associated with it.';
        END IF;
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER tr_check_ministry_facilityId
    BEFORE INSERT ON Ministry
    FOR EACH ROW
BEGIN
    IF NEW.facilityId IS NOT NULL THEN
        -- Check if the facilityId exists in the HeadOffice table
        IF NOT EXISTS (SELECT 1 FROM HeadOffice WHERE facilityId =
                                                      NEW.facilityId) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'The facilityId must belong to a
HeadOffice facility.';
        END IF;
    END IF;
END;
//
DELIMITER ;


DELIMITER //
CREATE TRIGGER tr_check_president
    BEFORE INSERT ON President
    FOR EACH ROW
BEGIN
    DECLARE president_count INT;
    DECLARE works_as_president_count INT;
    -- Check if a president already exists for the ministry (ministryName)
    SET president_count = (
        SELECT COUNT(*) FROM President WHERE facilityId =
                                             NEW.facilityId AND endDate IS NULL
    );
    IF president_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The ministry already has a president. Only
one president allowed.';
    END IF;
    -- Check if the employee going for the presidency is currently working (has endDate = NULL in WorksAt)
    SET works_as_president_count = (
        SELECT COUNT(*) FROM WorksAt WHERE medicareNumb =
                                           NEW.medicareNumb AND endDate IS NULL
    );
    IF works_as_president_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The employee is currently working and
cannot become president.';
    END IF;
    -- Check if the facilityId is a HeadOffice facility
    IF NOT EXISTS (SELECT 1 FROM HeadOffice WHERE facilityId =
                                                  NEW.facilityId) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The president can only work at a
HeadOffice facility.';
    END IF; END;
//
DELIMITER ;


DELIMITER //

CREATE TRIGGER tr_update_workLocation_1
    AFTER INSERT ON WorksAt
    FOR EACH ROW
BEGIN
    DECLARE facilityName VARCHAR(255);

    -- Get the facility name based on the inserted facilityId
    SET facilityName = (
        SELECT F.name
        FROM Facility F
        WHERE F.facilityId = NEW.facilityId
    );

    -- Update the workLocation in User table
    UPDATE User U
    SET U.workLocation = facilityName
    WHERE U.medicareNumb = NEW.medicareNumb;
END;

//

DELIMITER ;


DELIMITER //

CREATE TRIGGER tr_update_workLocation_2
    AFTER INSERT ON StudiesAt
    FOR EACH ROW
BEGIN
    DECLARE facilityName VARCHAR(255);

    -- Get the facility name based on the inserted facilityId
    SET facilityName = (
        SELECT F.name
        FROM Facility F
        WHERE F.facilityId = NEW.facilityId
    );

    -- Update the workLocation in User table
    UPDATE User U
    SET U.workLocation = facilityName
    WHERE U.medicareNumb = NEW.medicareNumb;
END;

//

DELIMITER ;

DELIMITER //

CREATE TRIGGER tr_sync_email_address_update
    AFTER UPDATE ON User
    FOR EACH ROW
BEGIN
    -- Update corresponding row in Employee table
    UPDATE Employee E
    SET E.email = NEW.email, E.address = NEW.address
    WHERE E.medicareNumb = NEW.medicareNumb;

    -- Update corresponding row in Student table
    UPDATE Student S
    SET S.email = NEW.email, S.address = NEW.address
    WHERE S.medicareNumb = NEW.medicareNumb;
END;

//

DELIMITER ;

DELIMITER //

CREATE TRIGGER tr_delete_user_row
    AFTER DELETE ON Employee
    FOR EACH ROW
BEGIN
    DELETE FROM User WHERE medicareNumb = OLD.medicareNumb;
END;

//

CREATE TRIGGER tr_delete_user_row_student
    AFTER DELETE ON Student
    FOR EACH ROW
BEGIN
    DELETE FROM User WHERE medicareNumb = OLD.medicareNumb;
END;

//

DELIMITER ;


CREATE TABLE ScheduledAt (
                             medicareNumb int(10),
                             facilityId bigint,
                             date date,
                             startTime time,
                             endTime time,
                             PRIMARY KEY (medicareNumb, facilityId, date, startTime),
                             FOREIGN KEY (medicareNumb) REFERENCES Employee(medicareNumb) ON UPDATE CASCADE,
                             FOREIGN KEY (facilityId) REFERENCES Facility(facilityId) ON UPDATE CASCADE
);

DELIMITER //

-- Trigger to prevent conflicting schedule times
CREATE TRIGGER tr_prevent_conflicting_schedule
    BEFORE INSERT ON ScheduledAt
    FOR EACH ROW
BEGIN
    DECLARE conflict_count INT;

    -- Check for conflicting schedule times
    SET conflict_count = (
        SELECT COUNT(*)
        FROM ScheduledAt S
        WHERE S.medicareNumb = NEW.medicareNumb
          AND S.date = NEW.date
          AND (
                (NEW.startTime BETWEEN S.startTime AND S.endTime)
                OR (NEW.endTime BETWEEN S.startTime AND S.endTime)
            )
    );

    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Employee is already scheduled at conflicting times.';
    END IF;

    -- Check for minimum 1 hour duration between schedules on the same day
    SET conflict_count = (
        SELECT COUNT(*)
        FROM ScheduledAt S
        WHERE S.medicareNumb = NEW.medicareNumb
          AND S.date = NEW.date
          AND (TIMESTAMPDIFF(HOUR, S.endTime, NEW.startTime) < 1)
    );

    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'There should be at least 1 hour between consecutive schedules.';
    END IF;
END;

//


//

-- Trigger to remove schedules for infected employees
CREATE TRIGGER tr_remove_schedules_infected
    BEFORE INSERT ON Infection
    FOR EACH ROW
BEGIN
    DELETE FROM ScheduledAt
    WHERE medicareNumb = NEW.medicareNumbEmployee
      AND date BETWEEN NEW.date AND DATE_ADD(NEW.date, INTERVAL 14 DAY);
END;

//

DELIMITER ;

DELIMITER //

-- Trigger to auto-generate schedule for the next 4 weeks (including delayed vaccination)
CREATE TRIGGER tr_auto_generate_schedule
    AFTER INSERT ON WorksAt
    FOR EACH ROW
BEGIN
    DECLARE schedule_date DATE;
    SET schedule_date = DATE_ADD(CURDATE(), INTERVAL 1 DAY); -- Start from tomorrow

    WHILE schedule_date <= DATE_ADD(CURDATE(), INTERVAL 28 DAY) DO -- Next 4 weeks
    IF EXISTS (
        SELECT 1
        FROM Vaccine V
        WHERE V.medicareNumbEmployee = NEW.medicareNumb
          AND V.date >= DATE_SUB(schedule_date, INTERVAL 6 MONTH)
    ) THEN
        INSERT INTO ScheduledAt (medicareNumb, facilityId, date, startTime, endTime)
        VALUES (NEW.medicareNumb, NEW.facilityId, schedule_date, '08:00:00', '16:00:00');
    END IF;

    SET schedule_date = DATE_ADD(schedule_date, INTERVAL 1 DAY);
        END WHILE;
END;

//

DELIMITER ;

DELIMITER //

CREATE TRIGGER tr_auto_generate_schedule_vaccinated
    AFTER INSERT ON Vaccine
    FOR EACH ROW
BEGIN
    DECLARE schedule_date DATE;
    SET schedule_date = DATE_ADD(CURDATE(), INTERVAL 1 DAY); -- Start from tomorrow

    IF NOT EXISTS (
        SELECT 1
        FROM ScheduledAt SA
        WHERE SA.medicareNumb = NEW.medicareNumbEmployee
    ) THEN
        WHILE schedule_date <= DATE_ADD(CURDATE(), INTERVAL 28 DAY) DO -- Next 4 weeks
        IF NEW.date >= DATE_SUB(schedule_date, INTERVAL 6 MONTH) THEN
            INSERT INTO ScheduledAt (medicareNumb, facilityId, date, startTime, endTime)
            SELECT NEW.medicareNumbEmployee, WA.facilityId, schedule_date, '08:00:00', '16:00:00'
            FROM WorksAt WA
            WHERE WA.medicareNumb = NEW.medicareNumbEmployee
              AND WA.endDate IS NULL
            LIMIT 1;
        END IF;

        SET schedule_date = DATE_ADD(schedule_date, INTERVAL 1 DAY);
            END WHILE;
    END IF;
END;

//

DELIMITER ;




INSERT INTO Facility (facilityId, name, province, address, city,
                      capacity, phoneNumb, postalCode, webAddress)
VALUES
    (1, 'English SB Head Office', 'Quebec', '6000 Av Fielding',
     'Montreal', 8, 4389874512, 'H3X 1T4',
     'https://www.englishsbheadoffice.com'),
    (2, 'Rosemont Elementary School', 'Quebec', '1275 Bd Rosemont',
     'Montreal', 250, 5147038000, 'H2S 3L9',
     'https://www.rosemontelementaryschool.com'),
    (3, 'French SB Head Office', 'Quebec', '340 Rue Saint-Jean-Bosco',
     'Montreal', 12, 5149836547, 'J1X 1K9',
     'https://www.frenchsbheadoffice.com'),

    (4, 'Ecole Secondaire St. Leonarde', 'Quebec', '5090 Boul
Métropolitain', 'St. Leonarde', 300, 4386579841, 'H1S 2V7',
     'https://www.ecolesecondairestleonarde.com'),
    (5, 'Laval High School', 'Quebec', '2005 Boulevard Saint-Martin O',
     'Laval', 400, 5142536262, 'H7S 1N3',
     'https://www.lavalhighschool.com'),
    (6, 'Goofy Secondary School', 'Quebec', '4300 Bd LaSalle', 'Verdun',
     120, 5142857845, 'H4G 2A8', 'https://www.goofysecondaryschool.com'),
    (7, 'Abdurs Special Hero Academy', 'Quebec', '1565 Chem. de la Côte
Vertu', 'St. Laurent', 75, 5147823159, 'H4L 2A1',
     'https://www.abdursspecialheroacademy.com'),
    (8, 'Jean 24 Ecole Complete', 'Quebec', '1472 Saint-Catherine St W',
     'Montreal', 800, 4387598621, 'H3G 1S8',
     'https://www.jean24ecolecomplete.com'),
    (9, 'Dominique Data Science Management Facility', 'Quebec', '1015
Autoroute', 'Dorval', 20, 5143675858, 'H9S 1A2',
     'https://www.dominiquedatasciencemanagementfacility.com'),
    (10, 'ANAM Management Facility', 'Quebec', '1623 Saint-Catherine St
W', 'Montreal', 10, 5149876254, 'H3H 1L8',
     'https://www.anammanagementfacility.com');


INSERT INTO Ministry (name, facilityId)
VALUES
    ('English School Board', NULL),
    ('French School Board', NULL);


INSERT INTO HeadOffice (facilityId, ministryName)
VALUES
    (1,'English School Board'),
    (3,'French School Board');

INSERT INTO GMF (facilityId)
VALUES
    (9), (10);


INSERT INTO EF (facilityId, primary_school, middle, high)
VALUES
    (2, 1, 0, 0),
    (4, 0, 1, 0),
    (5, 0, 0, 1),
    (6, 0, 1, 0),
    (7, 1, 1, 1),
    (8, 0, 1, 0);

INSERT INTO ManagementFacility (facilityId)
VALUES
    (1),
    (3),
    (9),
    (10);

INSERT INTO President (medicareNumb, facilityId, startDate, endDate)
VALUES
    (726384915, 1, '2015-07-27', NULL),
    (579312468, 3, '2015-08-11', NULL);


INSERT INTO StudiesAt (medicareNumb, facilityId, startDate, endDate,
                       currentLevel)
VALUES
    (392740274, 2, '2019-08-22', NULL, 'primary'),
    (103846593, 5, '2020-08-29', NULL, 'middle'),
    (134749375, 4, '2020-08-20', NULL, 'middle'),
    (759301758, 6, '2019-08-20', NULL, 'middle'),
    (374037274, 7, '2021-08-25', NULL, 'high'),
    (673904744, 5, '2022-08-24', NULL, 'high'),
    (175037407, 2, '2019-08-22', NULL, 'primary'),
    (856217404, 8, '2022-08-20', NULL, 'middle'),
    (673920438, 6, '2018-08-20', NULL, 'middle'),
    (389173840, 8, '2020-08-20', NULL, 'middle');


INSERT INTO WorksAt (medicareNumb, facilityId, startDate, endDate,
                     role, specialisation, schoolCounselor, programDirector,
                     schoolAdministrator)
VALUES
    (123456789, 2, '2020-07-05', null, 'Elementary Teacher', null, null,
     null, null),
    (987654321, 4, '2019-08-27', null, 'Secondary Teacher', null, 1, 0,
     0),
    (246813579, 2, '2016-05-03', null, 'Elementary Teacher', null, null,
     null, null),
    (135792468, 4, '2007-12-22', null, 'Elementary Teacher', null, null,
     null, null),
    (864209753, 5, '2013-05-21', null, 'Secondary Teacher', 'Geometry', 0,
     0, 0),
    (102938475, 7, '2012-12-24', null, 'Secondary Teacher', 'Chemistry',
     0, 1, 1),
    (726384915, 8, '2009-04-25', '2015-07-01', 'Elementary Teacher', null,
     null, null, null),
    (394857621, 9, '2008-08-27', null, 'Security Guard', null, null, null,
     null),
    (617283945, 10, '2010-12-02', null, 'Administrative Personnel', null,
     null, null, null),
    (579312468, 6, '2013-11-08', '2015-08-01', 'Secondary Teacher',
     'Biology', null, 1, null);


INSERT INTO Vaccine (vaccineId, medicareNumbStudent,
                     medicareNumbEmployee, date, type, doseNumb)
VALUES
    (1,103846593,NULL, '2023-06-25', 'Pfizer', 1),
    (2,374037274,NULL, '2023-07-18', 'Moderna', 2),
    (3,673904744,NULL, '2023-07-29', 'AstraZeneca', 1),
    (4,856217404,NULL, '2023-08-12', 'Johnson & Johnson', 1),
    (5,NULL,102938475, '2023-08-29', 'Pfizer', 2),
    (6,389173840,NULL, '2023-09-15', 'Moderna', 1),
    (7,NULL,102938475, '2023-09-28', 'AstraZeneca', 3),
    (8,NULL,394857621, '2023-10-10', 'Pfizer', 1),
    (9,NULL,726384915, '2023-10-24', 'Moderna', 2),
    (10,NULL,579312468, '2023-11-15', 'Johnson & Johnson', 1);


INSERT INTO HasFacilities (ministryName, facilityId, isGMF, isEF)
VALUES
    ('English School Board', 10, true, false),
    ('English School Board', 1, false, false),
    ('English School Board', 4, false, true),
    ('English School Board', 5, false, true),
    ('English School Board', 2, false, true),
    ('French School Board', 3, false, false),
    ('French School Board', 9, true, false),
    ('French School Board', 6, false, true),
    ('French School Board', 8, false, true),
    ('French School Board', 7, false, true);


INSERT INTO Infection (infectionId, medicareNumbStudent,
                       medicareNumbEmployee, date, type)
VALUES
    (1,103846593, NULL, '2023-07-19', 'COVID-19'),
    (2,103846593,NULL, '2023-07-20', 'Influenza'),
    (3,374037274,NULL, '2023-07-05', 'COVID-19'),
    (4,856217404,NULL, '2023-08-02', 'COVID-19'),
    (5,NULL,102938475, '2023-08-17', 'COVID-19'),
    (6,389173840,NULL, '2023-09-08', 'COVID-19'),
    (7,NULL,617283945, '2023-09-22', 'COVID-19'),
    (8,NULL,394857621, '2023-10-01', 'COVID-19'),
    (9,NULL,726384915, '2023-10-12', 'COVID-19'),
    (10,NULL,579312468, '2023-11-03', 'COVID-19'),
    (11,175037407, NULL, '2022-01-12', 'COVID-19'),
    (12 ,103846593, NULL, '2023-07-23', 'SARS-CoV-2 Variant'),
    (13,NULL, 617283945, '2023-07-15', 'COVID-19');

DELIMITER //

CREATE TRIGGER increment_dose
    BEFORE INSERT ON Vaccine
    FOR EACH ROW
BEGIN
    DECLARE latest_dose INT;
    SET latest_dose = IFNULL(
            (SELECT MAX(doseNumb) FROM Vaccine
             WHERE (medicareNumbStudent = NEW.medicareNumbStudent OR medicareNumbEmployee = NEW.medicareNumbEmployee) AND type = NEW.type),
            0
        );
    SET NEW.doseNumb = latest_dose + 1;
END;
//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE insert_vaccine(
    in_medicareNumbStudent INT,
    in_medicareNumbEmployee INT,
    in_date DATE,
    in_type VARCHAR(255)
)
BEGIN
    INSERT INTO Vaccine (
        medicareNumbStudent,
        medicareNumbEmployee,
        date,
        type
    ) VALUES (
                 in_medicareNumbStudent,
                 in_medicareNumbEmployee,
                 in_date,
                 in_type
             );
END;

