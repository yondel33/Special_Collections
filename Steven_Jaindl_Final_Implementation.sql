
CREATE DATABASE SpecialCollectionsDB
GO 

USE SpecialCollectionsDB

DROP TABLE dbo.Appointment;
DROP TABLE dbo.Film;
DROP TABLE dbo.ArchivalItem;
DROP TABLE dbo.Periodical;
DROP TABLE dbo.Book;
DROP TABLE dbo.Staff;
DROP TABLE dbo.Users;
DROP TABLE dbo.Item;
DROP TABLE dbo.Restriction;
DROP TABLE dbo.ItemLocation;


--User Table AND Computed Column 
CREATE TABLE dbo.Users
	(
	UserID int NOT NULL PRIMARY KEY,
	UserFirstName varchar(50) NOT NULL,
	UserLastName varchar (50) NOT NULL,
	Street varchar(50) NOT NULL,
	City varchar(50) NOT NULL,
	State char(2) NOT NULL,
	Zipcode varchar(10) NOT NULL,
	InstitutionalAffiliation varchar(50) NOT NULL,
	NumberofAppointmentsScheduled int NOT NULL, 
	NumberofAppointmentsAttended int NOT NULL,
	NumberoffAppointmentsMissed 
AS NumberofAppointmentsScheduled - NumberofAppointmentsAttended
	);

-- Staff Table
CREATE TABLE dbo.Staff
	(
	StaffID int NOT NULL PRIMARY KEY,
	StaffFirstName varchar(50) NOT NULL,
	StaffLastName varchar(50) NOT NULL
	);

-- Item Location Table
CREATE TABLE dbo.ItemLocation
	(
	ItemLocationID int NOT NULL PRIMARY KEY,
	ShelfNumber int NOT NULL,
	RowNumber int NOT NULL,
	SectionNumber int NOT NULL,
	LocationNote varchar (300)
	);

-- Restriction Table
CREATE TABLE dbo.Restriction 
	(
	RestrictionID char (1) NOT NULL PRIMARY KEY,
	ReproductionNote varchar (300),
	UseNote varchar (300)
	);

-- Item Table
CREATE TABLE dbo.Item
	(
	ItemID int NOT NULL PRIMARY KEY,
	ItemLocationID int NOT NULL,
	RestrictionID char (1) NOT NULL,
	FOREIGN KEY (ItemLocationID) REFERENCES dbo.ItemLocation(ItemLocationID),
	FOREIGN KEY (RestrictionID) REFERENCES dbo.Restriction(RestrictionID)
	);

-- Book Table
CREATE TABLE dbo.Book
	(
	ItemID int NOT NULL REFERENCES dbo.Item(ItemID),
	BookItemID int NOT NULL,
	ISBN varchar(20),
	CallNumber varchar (20),
	BookTitle varchar (100),
	VolumeNumber int,
	PublicationDate DATE,
	CONSTRAINT PKBook PRIMARY KEY CLUSTERED (ItemID,BookItemID)
	);

CREATE TABLE dbo.Periodical
	(
-- Periodical Table
	ItemID int NOT NULL REFERENCES dbo.Item(ItemID),
	PeriodicalID int NOT NULL,
	ISSN varchar(20),
	CallNumber varchar (30),
	PeriodicalTitle varchar (100), 
	IssueNumber int NOT NULL,
	VolumeNumber int NOT NULL,
	PublicationDate DATE,
	CONSTRAINT PKPeriodical PRIMARY KEY CLUSTERED (ItemID,PeriodicalID)
	);

-- Archival Item Table
CREATE TABLE dbo.ArchivalItem
	(
	ItemID int NOT NULL REFERENCES dbo.Item(ItemID),
	ArchivalItemID int NOT NULL,
	ArchivalItemName varchar (100),
	CollectionNumber int NOT NULL,
	BoxNumber varchar (100),
	PublicationDate DATE,
	CONSTRAINT PKArchivalItem PRIMARY KEY CLUSTERED (ItemID,ArchivalItemID) 
	);

-- Film Table
CREATE TABLE dbo.Film
	(
	ItemID int NOT NULL REFERENCES dbo.Item(ItemID),
	FilmID int NOT NULL,
	FilmName varchar (100),
	ReleaseDate DATE,
	CONSTRAINT PKFilm PRIMARY KEY CLUSTERED (ItemID,FilmID)
	);

-- Appointment Table and CHECK Constraint
CREATE TABLE dbo.Appointment
	(
	AppointmentID int NOT NULL PRIMARY KEY,
	UserID int NOT NULL,
	ItemID int NOT NULL,
	StaffID int NOT NULL,
	StartDateTime datetime,
	EndDateTime datetime,
	CONSTRAINT appointment_check CHECK (EndDateTime >= StartDateTime),
	FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
	FOREIGN KEY (ItemID) REFERENCES dbo.Item(ItemID),
	FOREIGN KEY (StaffID) REFERENCES dbo.Staff(StaffID)
	);

-- Insertion of Values

-- Staff Values
INSERT INTO dbo.Staff(StaffID,StaffFirstName,StaffLastName)
	VALUES 
	('1','Felicity','Worthington'),
	('2','John','Smith'),
	('3','Liem','Phan'),
	('4','Raphael','Toussaint'),
	('5','Sophie','Perez'),
	('6','Lukas','Schmidt'),
	('7','Giuseppe','Romano'),
	('8','Tamia','Kumar'),
	('9','Nari','Kim'),
	('10','Lola','Whitman');

-- Users Values
INSERT INTO dbo.Users(UserID,UserFirstName,UserLastName,Street,City,State,Zipcode,InstitutionalAffiliation,
NumberofAppointmentsScheduled,NumberofAppointmentsAttended)
	VALUES 
	('1','Lily','James','1234 Pouty Place','Seattle','WA','98105','Not Affiliated','4','4'),
	('2','Hulk','Hogan','777 Smashing Street','Seattle','WA','98101','Student','2','1'),
	('3','Nancy','Drew','0987 Laughy Lane','Seattle','WA','98103','Alumni','3','3'),
	('4','Dio','Brando','5678 Brooding Boulevard','Seattle','WA','98102','Faculty','1','1'),
	('5','Thor', 'Odinson', '888 Rowdy Road', 'Seattle', 'WA','98104','Not Affiliated','3','2'),
	('6','Sherlock','Holmes','221B Baker Street','Seattle','WA','98102','Student','1','0'),
	('7','Anakin','Skywalker','Tatooine Turnpike','Seattle','WA','98101','Alumni','5','1'),
	('8','Thomas','Shelby','Peaky Parkway','Seattle','WA','98106','Not Affiliated', '6', '5'),
	('9','Katniss','Everdeen','MockingJay Way','Seattle','WA','98106','Student','2', '1'),
	('10','Miles','Morales','Radioactive Route','Seattle','WA','98103','Student', '5', '5');

-- Item Location Values
INSERT INTO dbo.ItemLocation(ItemLocationID, ShelfNumber,RowNumber,SectionNumber,LocationNote)
	VALUES 
	('1','5','2','4','Book Location: Alphabetic By Title A-G'),
	('2','11','4','5', 'Book Location: Alphabetic By Title H-P'),
	('3','25','5', '3', 'Book Location: Alphabetic By Title Q-Z'),
	('4','34','5','2', 'Periodical Location: Alphabetic By Title A-G'),
	('5','41','4','1','Periodical Location: Alphabetic By Title H-P'),
	('6', '57','1','3','Periodical Location: Alphabetic By Title Q-Z'),
	('7','66','2','2', 'Archival Item Location: Alphabetic By Title A-G'),
	('8','71','1','4', 'Archival Item Location: Alphabetic By Title H-P'),
	('9','78','1','2', 'Archival Item Location:Alphabetic By Title Q-Z'),
	('10','81','3','1', 'Film Location: Alphabetic By Title A-G'),
	('11','86','8','2', 'Film Location: Alphabetic By Title H-P'),
	('12','91','4','5', 'Film Location: Alphabetic By Title Q-Z');

-- Restriction Values
INSERT INTO dbo.Restriction(RestrictionID,ReproductionNote,UseNote)
	VALUES 
	('A','No Reproduction Note','No Use Note'),
	('B','No Reproduction Note','Curator permission required to use'),
	('C','Curator permission required to reproduce','No Use Note'),
	('D','Curator permission required to reproduce','Curator permission required to use'),
	('E','No reproduction note','Donor permission required to use'),
	('F','Donor permission required to reproduce','No Use Note'),
	('G','Donor permission required to reproduce','Donor permission required to use'),
	('H','No Reproduction Note','Release form must be signed to use'),
	('I','Release form must be signed to reproduce','No Use Note'),
	('J','Release form must be signed to reproduce','Release form must be signed to use');

-- Item Values
INSERT INTO dbo.Item(ItemID,ItemLocationID,RestrictionID)
	VALUES 
	('1','3','A'),
	('2','3','F'),
	('3','2','J'),
	('4','1','B'),
	('5','2','C'),
	('6','3','C'),
	('7','3','A'),
	('8','2','H'),
	('9','3','I'),
	('10','1','A'),
	('11','5','A'),
	('12','6','J'),
	('13','6','E'),
	('14','6','A'),
	('15','5','H'),
	('16','5','A'),
	('17','6','C'),
	('18','5','D'),
	('19','6','F'),
	('20','6','I'),
	('21','9','J'),
	('22','8','E'),
	('23','9','B'),
	('24','8','B'),
	('25','9','C'),
	('26','9','D'),
	('27','8','H'),
	('28','8','J'),
	('29','7','D'),
	('30','11','C'),
	('31','10','A'),
	('32','10','I'),
	('33','12','F'),
	('34','12','J'),
	('35','10','C'),
	('36','12','D'),
	('37','12','H'),
	('38','11','E'),
	('39','11','G'),
	('40','10','A');

-- Book Values
INSERT INTO dbo.Book(ItemID,BookItemID,ISBN,CallNumber,BookTitle,VolumeNumber,PublicationDate)
	VALUES
	('1','1','50479204','F891 .R58','Washington''s History: The People, Land, and Events of the Far Northwest','1','2003'), 
	('2','2','57193246','PZ7.M57188','Twilight','1','2005'),
	('3','3','898419804','F897.K4 T4','Lake Sammamish Through Time','1','2015'),
	('4','4','946461779','QL212.B76','The City is More than Human: an Animal History of Seattle','1','2016'),
	('5','5','7752262','BX8949.S43 W45','The Presbytery of Seattle, 1858-2005: the Dream of a Presbyterian Colony in the West','1','2006'),
	('6','6','921995125','F889.3 .B46','Walking Washington''s History','1','2016'),
	('7','7','907295703','TA05.3W2 W55','Too High and Too Steep: Reshaping Seattle''s Topography','1','2015'),
	('8','8','952155007','HV6795.S5 N67','Murder & Mayhem in Seattle','1','2016'),
	('9','9','77746621','F899.S444 H86','Vanishing Seattle','1','2006'),
	('10','10','909974391','QE523.S23 O47','Eruption: the untold story of Mount St. Helens','1','2016');

--Periodical Values
INSERT INTO dbo.Periodical(ItemID,PeriodicalID,ISSN,CallNumber,PeriodicalTitle,IssueNumber,VolumeNumber,PublicationDate)
	VALUES
	('11','1','00322113','AP2.P746','Poetry Northwest','42','1','2019-05-03'),
	('12','2','10896651','BP605.N48 Y47','Yes!','11','5','2005-11-11'),
	('13','3','26898349','LH1.W37 W218','University of Washington Magazine','32','2','2009-06-17'),
	('14','4','1085729X','Newspaper','Real Change','29','17','2022-02-01'),
	('15','5','07417586','No Call Number Available','Pacific Maritime Magazine','8','9','2017-05-22'),
	('16','6','15324869','F852.N67','Nostalgia Magazine','19','3','2019-03-08'),
	('17','7','07465394','Newspaper','The Seattle Medium','92','4','2020-10-05'),
	('18','8','23283963','Newspaper','The Lynden Tribune','6','12','2003-07-15'),
	('19','9','19312792','PX88.I390','Seattle Metropolitan','3','6','2021-08-03'),
	('20','10','07459696','PS93.O245','Seattle Times','16','8','2006-09-02');

--ArchivalItem Values
INSERT INTO dbo.ArchivalItem(ItemID,ArchivalItemID,CollectionNumber,ArchivalItemName,BoxNumber,PublicationDate)
	VALUES 
('21','1','2148','Seattle Port Commission records','5','1899'),
	('22','2','4757','Hop Growers Association of Snoqualmie Washington Ledger','1','1885'),
	('23','3','3416','Washington Women''s Heritage Project','26','1900'),
	('24','4','1529','Pacific Northwest Library Association','4','1952' ),
('25','5','4305','Washington World''s Fair Commission records','20','1893'),
('26','6','340','Seattle Symphony Orchestra Records','4','1937'),
('27','7','1716','League of Women Voters of Washington','23','1920'),
('28','8','6316','Olympia Property Ledger Books','2','1892'),
('29','9','2006','Alaska-Yukon-Pacific Exposition Collection,','2','1906'),
('30','10','5902','Pacific Northwest Scrapbook Collection','580','1845');

--Film Values
INSERT INTO dbo.Film(ItemID,
FilmID,
FilmName,
ReleaseDate)
VALUES
	('31', '1','Airbud', '1997-08-01'),
	('32', '2','Five Easy Pieces', '1970-09-12'),
	('33', '3','Singles', '1992-09-18'),
	('34', '4','Twilight', '2008-11-21'),
	('35', '5','Dog', '2022-02-18'),
	('36', '6','The Wicker Man', '2006-09-01'),
	('37', '7','Twin Peaks: Fire Walk with Me', '1992-08-28'),
	('38', '8','Ma and Pa Kettle', '1949-04-01'),
	('39', '9','McCabe & Mrs. Miller', '1971-06-24'),
	('40', '10','Dancer in the Dark', '2000-12-08');

--Appointment Values
INSERT INTO dbo.Appointment(AppointmentID,UserID,ItemID,StaffID,StartDateTime,EndDateTime)
	VALUES
	('1','8','27','10','2022-02-04 10:01:03','2022-02-04 11:31:22'),
	('2','1','7','6','2022-02-23 14:00:34','2022-02-23 15:46:22'),
	('3','10','23','3','2022-02-24 13:22:01','2022-02-24 13:55:07'),
	('4','1','37','9','2022-02-24 09:45:02','2022-02-24 10:45:34'),
	('5','2','18','7','2022-02-26 11:36:10','2022-02-26 13:02:01'),
	('6','10','32','4','2022-02-27 14:57:33','2022-02-27 15:25:45'),
	('7','3','22','3','2022-02-28 10:03:22','2022-02-28 11:55:24'),
	('8','7','24','8','2022-02-28 11:02:42','2022-02-28 12:10:38'),
	('9','3','8','2','2022-03-01 09:29:01','2022-03-01 10:45:11'),
	('10','1','5','1', '2022-03-01 10:55:52','2022-03-01 12:45:23'),
	('11','10','38','5', '2022-03-01 13:00:34','2022-03-01 14:00:56'),
	('12','5','10','6', '2022-03-02 14:00:34','2022-03-02 14:08:34'),
	('13','9','5','3', '2022-03-02 10:00:45','2022-03-02 11:30:57'),
	('14','8','17','1', '2022-03-02 14:34:01','2022-03-02 15:00:57'),
	('15','5','7','7','2022-03-03 14:07:23','2022-03-03 14:58:24'),
	('16','8','33','8', '2022-03-03 11:07:38','2022-03-03 12:12:46'), 
	('17','4','19','3', '2022-03-03 12:00:37','2022-03-03 13:06:16'),
	('18','10','1','9', '2022-03-03 14:00:29','2022-03-03 14:56:57'),
	('19','10','8','10', '2022-03-04 09:00:49','2022-03-04 10:47:45'),
	('20','1','13','7', '2022-03-05 14:00:34','2022-03-05 16:00:38'),
	('21','8','36','2', '2022-03-05 16:06:41','2022-03-05 16:55:34'),
	('22','3','5','3', '2022-03-06 08:00:34','2022-03-06 09:20:38'),
	('23','8','3','9','2022-03-06 14:00:34','2022-03-06 15:00:22');

-- Items Not Accessed View
-- View that reports what items have not been accessed during appointments

CREATE VIEW V_ItemsNotAccessed 
AS
SELECT ItemID FROM Item  
WHERE ItemID NOT IN (Select ItemID FROM dbo.Appointment);

SELECT * FROM V_ItemsNotAccessed;


-- Books Viewed in Appointments
-- View that reports what books have been accessed during appointments

CREATE VIEW V_BooksViewedInAppointments
AS
SELECT ItemID FROM dbo.Appointment
INTERSECT
SELECT ItemID FROM dbo.Book;

SELECT * FROM V_BooksViewedInAppointments;



