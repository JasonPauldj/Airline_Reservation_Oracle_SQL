
-- Table Cusotmer
--------------------------------------------------------------------

CREATE TABLE CUSTOMER (
  CustomerID NUMBER NOT NULL,
  FirstName VARCHAR2(45) NOT NULL,
  LastName VARCHAR2(45) NOT NULL,
  Email VARCHAR2(45) NOT NULL,
  MobileNo VARCHAR2(45) NOT NULL,
  PRIMARY KEY (CustomerID));



-- Table FLIGHT_TYPE
--------------------------------------------------------------------

CREATE TABLE FLIGHT_TYPE (
  FlightTypeID NUMBER NOT NULL,
  FlightName VARCHAR2(45) NOT NULL,
  TotalNoOfSeats NUMBER NULL,
  PRIMARY KEY (FlightTypeID));



-- Table Airports
--------------------------------------------------------------------
CREATE TABLE AIRPORTS (
  Airports_ID NUMBER NOT NULL,
  State VARCHAR2(45) NULL,
  City VARCHAR2(45) NULL,
  Airport_Code VARCHAR2(45) NOT NULL UNIQUE,
  Airport_LongName VARCHAR2(100) NOT NULL UNIQUE,
  PRIMARY KEY (Airports_ID));


  -- Inserting values into the Customer table

INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (1, 'Fredrick', 'Kuhic', 'Fredrick97@gmail.com', '9851698275');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (2, 'Alexandra', 'Moen', 'Alexandra76@hotmail.com', '4111467271');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (3, 'Keith', 'Purdy', 'Keith.Purdy@gmail.com', '7086201608');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (4, 'Jerry', 'Hermann', 'Jerry46@hotmail.com', '5162354426');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (5, 'Jackie', 'Runte', 'Jackie.Runte@hotmail.com', '5165091524');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (6, 'Audrey', 'Kohler', 'Audrey_Kohler@yahoo.com', '1025161269');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (7, 'Maria', 'Rolfson', 'Maria_Rolfson91@gmail.com', '7339062790');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (8, 'Santiago', 'Rippin', 'Santiago.Rippin89@yahoo.com', '4155178945');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (9, 'Ruben', 'Okuneva', 'Ruben.Okuneva34@hotmail.com', '6849079568');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (10, 'Andrew', 'Leannon', 'Andrew_Leannon@gmail.com', '1308608494');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (11, 'Bob', 'Miller', 'Bob18@hotmail.com', '5947299265');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (12, 'Erma', 'Mills', 'Erma99@hotmail.com', '3205588765');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (13, 'Teresa', 'Kling', 'Teresa.Kling45@hotmail.com', '8329288895');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (14, 'Shannon', 'Turcotte', 'Shannon23@yahoo.com', '3606292461');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (15, 'Beulah', 'Cruickshank', 'Beulah6@hotmail.com', '1450149332');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (16, 'Darla', 'Balistreri', 'Darla.Balistreri25@gmail.com', '9077051489');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (17, 'Bradford', 'Stiedemann', 'Bradford39@gmail.com', '7668861386');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (18, 'Karen', 'Wintheiser', 'Karen_Wintheiser91@gmail.com', '9679794329');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (19, 'Gilberto', 'Pfeffer', 'Gilberto.Pfeffer@gmail.com', '2531343269');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (20, 'Angie', 'Hessel', 'Angie54@hotmail.com', '3300355373');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (21, 'Anne', 'Schroeder', 'Anne78@hotmail.com', '6147301761');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (22, 'Jacob', 'Bosco', 'Jacob_Bosco82@yahoo.com', '1243021907');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (23, 'Shelia', 'Koepp', 'Shelia74@gmail.com', '3150575514');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (24, 'Genevieve', 'Parker', 'Genevieve_Parker@yahoo.com', '8900435771');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, MOBILENO) 
VALUES (25, 'Carroll', 'Murphy', 'Carroll_Murphy62@gmail.com', '7636236121');


-- Inserting values into Flight_Type table
INSERT INTO FLIGHT_TYPE (FLIGHTTYPEID, FLIGHTNAME, TOTALNOOFSEATS) 
VALUES (1, 'A220', 75);
INSERT INTO FLIGHT_TYPE (FLIGHTTYPEID, FLIGHTNAME, TOTALNOOFSEATS) 
VALUES (2, 'A320', 100);

-- Inserting values into the Airports table  
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (1, 'Alabama', 'Birmingham', 'BHM', 'Birmingham–Shuttlesworth International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (2, 'Alabama', 'Anchorage', 'ANC', 'Ted Stevens Anchorage International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (3, 'Arizona', 'Phoenix', 'PHX', 'Phoenix Sky Harbor International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (4, 'Arizona', 'Tucson', 'TUS', 'Tucson International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (5, 'California', 'Burbank', 'BUR', 'Hollywood Burbank Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (6, 'California', 'Long Beach', 'LGB', 'Long Beach Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (7, 'California', 'Los Angeles', 'LAX', 'Los Angeles International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (8, 'California', 'Oakland', 'OAK', 'Oakland International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (9, 'California', 'Ontario', 'ONT', 'Ontario International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (10, 'California', 'Orange County', 'SNA', 'John Wayne Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (11, 'California', 'Palm Springs', 'PSP', 'Palm Springs International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (12, 'California', 'Sacramento', 'SMF', 'Sacramento International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (13, 'California', 'San Diego', 'SAN', 'San Diego International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (14, 'California', 'San Francisco', 'SFO', 'San Francisco International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (15, 'California', 'San Jose', 'SJC', 'Norman Y. Mineta San José International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (16, 'Colorado', 'Denver', 'DEN', 'Denver International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (17, 'Connecticut', 'Hartford', 'BDL', 'Bradley International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (18, 'Florida', 'Fort Lauderdale', 'FLL', 'Fort Lauderdale–Hollywood International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (19, 'Florida', 'Fort Myers', 'RSW', 'Southwest Florida International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (20, 'Florida', 'Jacksonville', 'JAX', 'Jacksonville International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (21, 'Florida', 'Miami', 'MIA', 'Miami International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (22, 'Florida', 'Orlando', 'MCO', 'Orlando International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (23, 'Florida', 'Pensacola', 'PNS', 'Pensacola International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (24, 'Florida', 'Sanford', 'SFB', 'Orlando Sanford International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (25, 'Florida', 'Sarasota', 'SRQ', 'Sarasota–Bradenton International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (26, 'Florida', 'St. Petersburg', 'PIE', 'St. Pete–Clearwater International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (27, 'Florida', 'Tampa', 'TPA', 'Tampa International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (28, 'Florida', 'West Palm Beach', 'PBI', 'Palm Beach International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (29, 'Georgia', 'Atlanta', 'ATL', 'Hartsfield–Jackson Atlanta International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (30, 'Georgia', 'Savannah', 'SAV', 'Savannah/Hilton Head International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (31, 'Hawaii', 'Honolulu, Oahu', 'HNL', 'Daniel K. Inouye International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (32, 'Hawaii', 'Kahului, Maui', 'OGG', 'Kahului Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (33, 'Hawaii', 'Kailua-Kona, Hawaii', 'KOA', 'Ellison Onizuka Kona International Airport at Keahole');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (34, 'Hawaii', 'Lihue, Kauai', 'LIH', 'Lihue Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (35, 'Idaho', 'Boise', 'BOI', 'Boise Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (36, 'Illinois', 'Chicago', 'MDW', 'Chicago Midway International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (37, 'Illinois', 'Chicago', 'ORD', 'Chicago O''Hare International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (38, 'Indiana', 'Indianapolis', 'IND', 'Indianapolis International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (39, 'Iowa', 'Des Moines', 'DSM', 'Des Moines International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (40, 'Kentucky', 'Cincinnati', 'CVG', 'Cincinnati/Northern Kentucky International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (41, 'Kentucky', 'Louisville', 'SDF', 'Louisville International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (42, 'Louisiana', 'New Orleans', 'MSY', 'Louis Armstrong New Orleans International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (43, 'Maine', 'Portland', 'PWM', 'Portland International Jetport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (44, 'Maryland', 'Baltimore', 'BWI', 'Baltimore/Washington International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (45, 'Massachusetts', 'Boston', 'BOS', 'Gen. Edward Lawrence Logan International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (46, 'Michigan', 'Detroit', 'DTW', 'Detroit Metro Wayne County Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (47, 'Michigan', 'Grand Rapids', 'GRR', 'Gerald R. Ford International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (48, 'Minnesota', 'Minneapolis-St. Paul', 'MSP', 'Minneapolis–St. Paul International');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (49, 'Missouri', 'Kansas City', 'MCI', 'Kansas City International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (50, 'Missouri', 'St. Louis', 'STL', 'St. Louis Lambert International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (51, 'Nebraska', 'Omaha', 'OMA', 'Eppley Airfield');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (52, 'Nevada', 'Las Vegas', 'LAS', 'Harry Reid International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (53, 'Nevada', 'Reno', 'RNO', 'Reno/Tahoe International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (54, 'New Jersey', 'Newark', 'EWR', 'Newark Liberty International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (55, 'New Mexico', 'Albuquerque', 'ABQ', 'Albuquerque International Sunport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (56, 'New York', 'Albany', 'ALB', 'Albany International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (57, 'New York', 'Buffalo', 'BUF', 'Buffalo Niagara International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (58, 'New York', 'New York', 'JFK', 'John F. Kennedy International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (59, 'New York', 'New York', 'LGA', 'LaGuardia Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (60, 'New York', 'Rochester', 'ROC', 'Frederick Douglass/Greater Rochester International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (61, 'New York', 'Syracuse', 'SYR', 'Syracuse Hancock International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (62, 'North Carolina', 'Charlotte', 'CLT', 'Charlotte Douglas International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (63, 'North Carolina', 'Raleigh', 'RDU', 'Raleigh–Durham International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (64, 'Ohio', 'Cleveland', 'CLE', 'Cleveland Hopkins International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (65, 'Ohio', 'Columbus', 'CMH', 'John Glenn Columbus International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (66, 'Oklahoma', 'Oklahoma City', 'OKC', 'Will Rogers World Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (67, 'Oklahoma', 'Tulsa', 'TUL', 'Tulsa International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (68, 'Oregon', 'Portland', 'PDX', 'Portland International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (69, 'Pennsylvania', 'Philadelphia', 'PHL', 'Philadelphia International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (70, 'Pennsylvania', 'Pittsburgh', 'PIT', 'Pittsburgh International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (71, 'Rhode Island', 'Providence', 'PVD', 'Rhode Island T. F. Green International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (72, 'South Carolina', 'Charleston', 'CHS', 'Charleston International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (73, 'South Carolina', 'Greenville', 'GSP', 'Greenville–Spartanburg International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (74, 'South Carolina', 'Myrtle Beach', 'MYR', 'Myrtle Beach International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (75, 'Tennessee', 'Knoxville', 'TYS', 'McGhee Tyson Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (76, 'Tennessee', 'Memphis', 'MEM', 'Memphis International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (77, 'Tennessee', 'Nashville', 'BNA', 'Nashville International Airport (Berry Field)');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (78, 'Texas', 'Austin', 'AUS', 'Austin–Bergstrom International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (79, 'Texas', 'Dallas', 'DAL', 'Dallas Love Field');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (80, 'Texas', 'Dallas', 'DFW', 'Dallas Fort Worth International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (81, 'Texas', 'El Paso', 'ELP', 'El Paso International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (82, 'Texas', 'Houston', 'IAH', 'George Bush Intercontinental/Houston Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (83, 'Texas', 'Houston', 'HOU', 'William P. Hobby Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (84, 'Texas', 'San Antonio', 'SAT', 'San Antonio International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (85, 'Utah', 'Salt Lake City', 'SLC', 'Salt Lake City International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (86, 'Virginia', 'Norfolk', 'ORF', 'Norfolk International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (87, 'Virginia', 'Richmond', 'RIC', 'Richmond International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (88, 'Virginia', 'Washington, D.C.', 'DCA', 'Ronald Reagan Washington National Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (89, 'Virginia', 'Washington, D.C.', 'IAD', 'Washington Dulles International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (90, 'Washington', 'Seattle', 'SEA', 'Seattle–Tacoma International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (91, 'Washington', 'Spokane', 'GEG', 'Spokane International Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (92, 'Wisconsin', 'Madison', 'MSN', 'Dane County Regional Airport');
INSERT INTO AIRPORTS (AIRPORTS_ID, STATE, CITY, AIRPORT_CODE, AIRPORT_LONGNAME) 
VALUES (93, 'Wisconsin', 'Milwaukee', 'MKE', 'Milwaukee Mitchell International Airport');

