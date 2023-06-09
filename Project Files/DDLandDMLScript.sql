set serveroutput on

declare
    v_table_exists varchar(1) := 'Y';
    v_sql varchar(2000);
begin
   dbms_output.put_line('Start schema cleanup');
for i in (select 'BOOKING_AUDIT' table_name from dual union all
             select 'PASSENGER_CANCEL_AUDIT' table_name from dual union all
             select 'ROUTES_AUDIT' table_name from dual union all
             select 'FLIGHT_SCHEDULES_AUDIT' table_name from dual union all
             select 'FLIGHT_TYPE_AUDIT' table_name from dual union all
             select 'PASSENGER' table_name from dual union all
             select 'STATUS' table_name from dual union all
             select 'BOOKING' table_name from dual union all
             select 'PROMOTION' table_name from dual union all
             select 'FLIGHT_SCHEDULES' table_name from dual union all
             select 'FLIGHT_SEAT_AVAILABILITY' table_name from dual union all
             select 'SEAT_TYPE' table_name from dual  union all
             select 'ROUTES' table_name from dual union all
             select 'AIRPORTS' table_name from dual union all
             select 'FLIGHT_TYPE' table_name from dual union all
             select 'CUSTOMER' table_name from dual
   )
   loop
   dbms_output.put_line('***Drop table '||i.table_name||'***');
   begin
       select 'Y' into v_table_exists
       from USER_TABLES
       where TABLE_NAME=i.table_name;

       v_sql := 'drop table '||i.table_name;
       execute immediate v_sql;
       dbms_output.put_line('.***Table '||i.table_name||' dropped successfully***');
       
   exception
       when no_data_found then
           dbms_output.put_line('***Table already dropped***');
   end;
   end loop;
   dbms_output.put_line('***Schema cleanup successfully completed***');
exception
   when others then
      dbms_output.put_line('***Failed to execute code:'||sqlerrm||'***');
end;

/

declare
    v_seq_exists varchar(1) := 'Y';
    v_sql varchar(2000);
begin
   dbms_output.put_line('Start sequence cleanup');
for i in (select 'SEQ_CUSTOMER' seq_name from dual union all
      select 'SEQ_ROUTE' seq_name from dual union all
      select 'SEQ_BOOKING' seq_name from dual union all
      select 'SEQ_FLIGHT_SEAT_AVAILABILITY' seq_name from dual union all
      select 'SEQ_STATUS' seq_name from dual union all
      select 'SEQ_PASSENGER' seq_name from dual union all
      select 'SEQ_FS' seq_name from dual union all
      select 'SEQ_PROMOTION' seq_name from dual union all
      select 'SEQ_FT' seq_name from dual
   )
   loop
   dbms_output.put_line('***Drop sequence '||i.seq_name||'***');
   begin
       select 'Y' into v_seq_exists
       from user_sequences
       where SEQUENCE_NAME=i.seq_name;

       v_sql := 'drop sequence '||i.seq_name;
       execute immediate v_sql;
       dbms_output.put_line('.***Sequence '||i.seq_name||' dropped successfully***');
       
   exception
       when no_data_found then
           dbms_output.put_line('***Sequence already dropped***');
   end;
   end loop;
   dbms_output.put_line('***Sequence cleanup successfully completed***');
exception
   when others then
      dbms_output.put_line('***Failed to execute code:'||sqlerrm||'***');
end;

/

-- Table Customer
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

-- Table Routes
--------------------------------------------------------------------

CREATE TABLE ROUTES (
  RouteID NUMBER NOT NULL,
  RouteNo VARCHAR2(45) NOT NULL UNIQUE,
  DepartureTime VARCHAR(8) NOT NULL,
  DurationOfTravelInMinutes NUMBER NOT NULL,
  FlightType_FlightTypeID NUMBER NOT NULL,
  SourceAirport NUMBER NOT NULL,
  DestinationAirport NUMBER NOT NULL,
  PRIMARY KEY (RouteID),
  CONSTRAINT fk_ROUTES_FlightType
    FOREIGN KEY (FlightType_FlightTypeID)
    REFERENCES FLIGHT_TYPE (FlightTypeID)
    ON DELETE CASCADE,
  CONSTRAINT fk_ROUTES_AIRPORT_CODES
    FOREIGN KEY (SourceAirport)
    REFERENCES AIRPORTS (Airports_ID)
    ON DELETE CASCADE,
  CONSTRAINT fk_ROUTES_AIRPORT_CODES1
    FOREIGN KEY (DestinationAirport)
    REFERENCES AIRPORTS (Airports_ID)
    ON DELETE CASCADE);

-- Table Seat type
--------------------------------------------------------------------

Create table SEAT_TYPE (SEATTYPEID NUMBER NOT NULL,
SEATTYPENAME VARCHAR2(45) NOT NULL,
PRIMARY KEY (SEATTYPEID));

-- Table FLIGHT_SEAT_AVAILABILITY
--------------------------------------------------------------------
CREATE TABLE FLIGHT_SEAT_AVAILABILITY (
    FlightSeatAvailabilityID NUMBER NOT NULL,
    NoOfSeats NUMBER NULL,
    FlightType_FlightTypeID NUMBER NOT NULL,
    SEAT_TYPE_SeatTypeID NUMBER NOT NULL,
    PRIMARY KEY (FlightSeatAvailabilityID),
    CONSTRAINT fk_FLIGHT_SEAT_AVAILABILITY_FlightType
        FOREIGN KEY (FlightType_FlightTypeID)
        REFERENCES FLIGHT_TYPE (FlightTypeID)
        ON DELETE CASCADE,
    CONSTRAINT fk_FLIGHT_SEAT_AVAILABILITY_SEAT_TYPE
        FOREIGN KEY (SEAT_TYPE_SeatTypeID)
        REFERENCES SEAT_TYPE (SeatTypeID)
        ON DELETE CASCADE);
        

-- Table FLIGHT_SCHEDULES
---------------------------------------------------------------------

CREATE TABLE FLIGHT_SCHEDULES (
  FLIGHT_SCHEDULE_ID NUMBER NOT NULL,
  SeatsAvailable VARCHAR2(45) NULL,
  DateOfTravel DATE NULL,
  ROUTES_RouteID NUMBER NOT NULL,
  PRIMARY KEY (FLIGHT_SCHEDULE_ID),
  CONSTRAINT fk_FLIGHT_SCHEDULES_ROUTES
    FOREIGN KEY (ROUTES_RouteID)
    REFERENCES ROUTES (RouteID)
    ON DELETE CASCADE);

-- Table PROMOTION
--------------------------------------------------------------------
CREATE TABLE PROMOTION (
  PromotionID NUMBER NOT NULL,
  PromotionName VARCHAR2(45) NOT NULL,
  PromotionDesc VARCHAR2(45) NOT NULL,
  Active VARCHAR2(45) NULL,
  PRIMARY KEY (PromotionID));

-- Table BOOKING
--------------------------------------------------------------------
CREATE TABLE BOOKING (
  BookingID NUMBER NOT NULL,
  PNR VARCHAR2(45) NOT NULL,
  DateOfBooking DATE NULL,
  Customer_ID NUMBER NOT NULL,
  PROMOTION_PromotionID NUMBER NOT NULL,
  SEAT_TYPE_SeatTypeID NUMBER NOT NULL,
  FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID NUMBER NOT NULL,
  PRIMARY KEY (BookingID),
  CONSTRAINT fk_BOOKING_USER
    FOREIGN KEY (Customer_ID)
    REFERENCES CUSTOMER (CustomerID)
    ON DELETE CASCADE,
  CONSTRAINT fk_BOOKING_PROMOTION
    FOREIGN KEY (PROMOTION_PromotionID)
    REFERENCES PROMOTION (PromotionID)
    ON DELETE SET NULL,
  CONSTRAINT fk_BOOKING_SEAT_TYPE
    FOREIGN KEY (SEAT_TYPE_SeatTypeID)
    REFERENCES SEAT_TYPE (SeatTypeID)
    ON DELETE SET NULL,
  CONSTRAINT fk_BOOKING_FLIGHT_SCHEDULES
    FOREIGN KEY (FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID)
    REFERENCES FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID)
    ON DELETE SET NULL);

-- Table STATUS
-- -----------------------------------------------------
CREATE TABLE STATUS (
  StatusID NUMBER NOT NULL,
  Status VARCHAR2(45) NOT NULL UNIQUE,
  PRIMARY KEY (StatusID));

-- Table PASSENGER
-- -----------------------------------------------------
CREATE TABLE PASSENGER (
  PassengerID NUMBER NOT NULL,
  FirstName VARCHAR2(45) NOT NULL,
  LastName VARCHAR2(45) NOT NULL,
  Email VARCHAR2(45) NULL,
  PhoneNo VARCHAR2(45) NULL,
  Age NUMBER NOT NULL,
  Gender VARCHAR2(10) NOT NULL,
  BOOKING_BookingID NUMBER NOT NULL,
  Status_StatusID NUMBER NOT NULL,
  PRIMARY KEY (PassengerID),
  CONSTRAINT fk_PASSENGER_BOOKING
    FOREIGN KEY (BOOKING_BookingID)
    REFERENCES BOOKING (BookingID)
    ON DELETE CASCADE,
  CONSTRAINT fk_PASSENGER_Status
    FOREIGN KEY (Status_StatusID)
    REFERENCES STATUS (StatusID)
    ON DELETE CASCADE);

-- Table Booking Audit
--------------------------------------------------------------------
CREATE TABLE booking_audit (
  audit_id NUMBER GENERATED ALWAYS AS IDENTITY,
  booking_id NUMBER NOT NULL,
  operation_type VARCHAR2(10),
  audit_timestamp TIMESTAMP DEFAULT SYSTIMESTAMP,
  PRIMARY KEY (audit_id),
  FOREIGN KEY (booking_id) REFERENCES booking (BookingID) ON DELETE CASCADE
);

-- Table Passenger Cancel Audit
--------------------------------------------------------------------

CREATE TABLE passenger_cancel_audit (
  audit_id NUMBER GENERATED ALWAYS AS IDENTITY,
  PassengerID NUMBER NOT NULL,
  operation_type VARCHAR2(10),
  audit_timestamp TIMESTAMP DEFAULT SYSTIMESTAMP,
  PRIMARY KEY (audit_id),
  FOREIGN KEY (PassengerID) REFERENCES PASSENGER (PassengerID) ON DELETE CASCADE
);


-- Table Route Audit
--------------------------------------------------------------------
CREATE TABLE routes_audit (
  audit_id NUMBER GENERATED ALWAYS AS IDENTITY,
  RouteID NUMBER NOT NULL,
  operation_type VARCHAR2(10),
  audit_timestamp TIMESTAMP DEFAULT SYSTIMESTAMP,
  PRIMARY KEY (audit_id),
  FOREIGN KEY (RouteID) REFERENCES ROUTES (RouteID) ON DELETE CASCADE
);

-- Table Flight Schedule Audit
CREATE TABLE FLIGHT_SCHEDULES_audit (
  audit_id NUMBER GENERATED ALWAYS AS IDENTITY,
  FLIGHT_SCHEDULE_ID NUMBER NOT NULL,
  operation_type VARCHAR2(10),
  audit_timestamp TIMESTAMP DEFAULT SYSTIMESTAMP,
  PRIMARY KEY (audit_id),
  FOREIGN KEY (FLIGHT_SCHEDULE_ID) REFERENCES FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID) ON DELETE CASCADE
);

-- Table Flight Schedule Audit
CREATE TABLE FLIGHT_TYPE_audit (
  audit_id NUMBER GENERATED ALWAYS AS IDENTITY,
  FlightTypeID NUMBER NOT NULL,
  operation_type VARCHAR2(10),
  audit_timestamp TIMESTAMP DEFAULT SYSTIMESTAMP,
  PRIMARY KEY (audit_id),
  FOREIGN KEY (FlightTypeID) REFERENCES FLIGHT_TYPE (FLIGHTTYPEID) ON DELETE CASCADE
);




  -- GRANTING PRIVILEGES TO CUSTOMER
  GRANT SELECT, INSERT, UPDATE ON CUSTOMER TO CUSTOMER;
  GRANT SELECT ON FLIGHT_SCHEDULES TO CUSTOMER;
  GRANT SELECT ON PROMOTION TO CUSTOMER;
  GRANT SELECT ON SEAT_TYPE TO CUSTOMER;
  GRANT SELECT, INSERT, UPDATE ON PASSENGER TO CUSTOMER;
  GRANT SELECT,INSERT ON BOOKING TO CUSTOMER;


 -- CREATE SEQUENCE for CUSTOMER TABLE
   CREATE SEQUENCE seq_customer start with 26 increment by 1;

 -- CREATE SEQUENCE for ROUTE TABLE
   CREATE SEQUENCE seq_route start with 6 increment by 1;

 -- CREATE SEQUENCE for BOOKING TABLE
   CREATE SEQUENCE seq_booking start with 251 increment by 1;
   
 -- CREATE SEQUENCE for FLIGHT_SEAT_AVAILABILITY TABLE
    CREATE SEQUENCE seq_flight_seat_availability start with 5 increment by 1;
    
 -- CREATE SEQUENCE for STATUS TABLE
    CREATE SEQUENCE seq_status start with 3 increment by 1;

 -- CREATE SEQUENCE for PASSENGER TABLE
    CREATE SEQUENCE seq_passenger start with 381 increment by 1;

  -- CREATE SEQUENCE for FLIGHT_SCHEDULES TABLE
    CREATE SEQUENCE seq_fs start with 45 increment by 1;

  -- CREATE SEQUENCE for PROMOTION TABLE
    CREATE SEQUENCE seq_promotion start with 4 increment by 1;

    -- CREATE SEQUENCE for  FLIGHT_TYPE TABLE
    CREATE SEQUENCE seq_ft start with 3 increment by 1;

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

COMMIT;

-- Inserting values into Flight_Type table
INSERT INTO FLIGHT_TYPE (FLIGHTTYPEID, FLIGHTNAME, TOTALNOOFSEATS) 
VALUES (1, 'A220', 75);
INSERT INTO FLIGHT_TYPE (FLIGHTTYPEID, FLIGHTNAME, TOTALNOOFSEATS) 
VALUES (2, 'A320', 100);

COMMIT;

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
VALUES (77, 'Tennessee', 'Nashville', 'BNA', 'Nashville International Airport (Berry Field)');
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

COMMIT;

-- Inserting data into the ROUTES table
INSERT INTO ROUTES (ROUTEID, ROUTENO, DEPARTURETIME, DURATIONOFTRAVELINMINUTES, FlightType_FlightTypeID, SOURCEAIRPORT, DESTINATIONAIRPORT) 
VALUES (1, 'PNN', '07:30', 300, 2, 3, 45);
INSERT INTO ROUTES (ROUTEID, ROUTENO, DEPARTURETIME, DURATIONOFTRAVELINMINUTES, FlightType_FlightTypeID, SOURCEAIRPORT, DESTINATIONAIRPORT) 
VALUES (2, 'ZSW', '17:30', 210, 2, 14, 78);
INSERT INTO ROUTES (ROUTEID, ROUTENO, DEPARTURETIME, DURATIONOFTRAVELINMINUTES, FlightType_FlightTypeID, SOURCEAIRPORT, DESTINATIONAIRPORT) 
VALUES (3, 'PVL', '12:15', 155, 1, 21, 89);
INSERT INTO ROUTES (ROUTEID, ROUTENO, DEPARTURETIME, DURATIONOFTRAVELINMINUTES, FlightType_FlightTypeID, SOURCEAIRPORT, DESTINATIONAIRPORT) 
VALUES (4, 'JCP', '11:15', 110, 2, 62, 89 );
INSERT INTO ROUTES (ROUTEID, ROUTENO, DEPARTURETIME, DURATIONOFTRAVELINMINUTES, FlightType_FlightTypeID, SOURCEAIRPORT, DESTINATIONAIRPORT) 
VALUES (5, 'CQC', '18:45', 140, 2, 78, 45);

COMMIT;

-- Inserting data into the Seat types table
Insert into SEAT_TYPE (SEATTYPEID,SEATTYPENAME) values (1,'Economy');
Insert into SEAT_TYPE (SEATTYPEID,SEATTYPENAME) values (2,'Business');

COMMIT;

-- Inserting data into the FLIGHT_SEAT_AVAILABILITY table
Insert into FLIGHT_SEAT_AVAILABILITY (FLIGHTSEATAVAILABILITYID,NOOFSEATS,FLIGHTTYPE_FLIGHTTYPEID,SEAT_TYPE_SEATTYPEID) values (1,50,1,1);
Insert into FLIGHT_SEAT_AVAILABILITY (FLIGHTSEATAVAILABILITYID,NOOFSEATS,FLIGHTTYPE_FLIGHTTYPEID,SEAT_TYPE_SEATTYPEID) values (2,25,1,2);
Insert into FLIGHT_SEAT_AVAILABILITY (FLIGHTSEATAVAILABILITYID,NOOFSEATS,FLIGHTTYPE_FLIGHTTYPEID,SEAT_TYPE_SEATTYPEID) values (3,70,2,1);
Insert into FLIGHT_SEAT_AVAILABILITY (FLIGHTSEATAVAILABILITYID,NOOFSEATS,FLIGHTTYPE_FLIGHTTYPEID,SEAT_TYPE_SEATTYPEID) values (4,30,2,2);

COMMIT;

-- Inserting data into FLIGHT_SCHEDULES table
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (1,93,to_date('04-MAR-23','DD-MON-RR'),1);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (2,84,to_date('11-MAR-23','DD-MON-RR'),1);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (3,91,to_date('18-MAR-23','DD-MON-RR'),1);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (4,95,to_date('25-MAR-23','DD-MON-RR'),1);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (5,95,to_date('05-MAR-23','DD-MON-RR'),2);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (6,89,to_date('12-MAR-23','DD-MON-RR'),2);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (7,90,to_date('19-MAR-23','DD-MON-RR'),2);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (8,94,to_date('26-MAR-23','DD-MON-RR'),2);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (9,72,to_date('06-MAR-23','DD-MON-RR'),3);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (10,65,to_date('13-MAR-23','DD-MON-RR'),3);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (11,67,to_date('20-MAR-23','DD-MON-RR'),3);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (12,72,to_date('27-MAR-23','DD-MON-RR'),3);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (13,91,to_date('03-MAR-23','DD-MON-RR'),4);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (14,90,to_date('08-MAR-23','DD-MON-RR'),4);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (15,94,to_date('15-MAR-23','DD-MON-RR'),4);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (16,92,to_date('22-MAR-23','DD-MON-RR'),4);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (17,95,to_date('29-MAR-23','DD-MON-RR'),4);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (18,94,to_date('03-MAR-23','DD-MON-RR'),5);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (19,86,to_date('10-MAR-23','DD-MON-RR'),5);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (20,92,to_date('17-MAR-23','DD-MON-RR'),5);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (21,91,to_date('24-MAR-23','DD-MON-RR'),5);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (22,86,to_date('31-MAR-23','DD-MON-RR'),5);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (23,90,to_date('01-APR-23','DD-MON-RR'),1);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (24,97,to_date('08-APR-23','DD-MON-RR'),1);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (25,89,to_date('15-APR-23','DD-MON-RR'),1);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (26,92,to_date('22-APR-23','DD-MON-RR'),1);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (27,93,to_date('29-APR-23','DD-MON-RR'),1);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (28,93,to_date('02-APR-23','DD-MON-RR'),2);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (29,95,to_date('09-APR-23','DD-MON-RR'),2);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (30,96,to_date('15-APR-23','DD-MON-RR'),2);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (31,97,to_date('23-APR-23','DD-MON-RR'),2);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (32,94,to_date('30-APR-23','DD-MON-RR'),2);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (33,65,to_date('06-APR-23','DD-MON-RR'),3);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (34,68,to_date('13-APR-23','DD-MON-RR'),3);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (35,64,to_date('20-APR-23','DD-MON-RR'),3);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (36,67,to_date('27-APR-23','DD-MON-RR'),3);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (37,93,to_date('07-APR-23','DD-MON-RR'),4);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (38,93,to_date('14-APR-23','DD-MON-RR'),4);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (39,94,to_date('21-APR-23','DD-MON-RR'),4);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (40,90,to_date('28-APR-23','DD-MON-RR'),4);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (41,94,to_date('04-APR-23','DD-MON-RR'),5);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (42,94,to_date('11-APR-23','DD-MON-RR'),5);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (43,97,to_date('18-APR-23','DD-MON-RR'),5);
Insert into FLIGHT_SCHEDULES (FLIGHT_SCHEDULE_ID,SEATSAVAILABLE,DATEOFTRAVEL,ROUTES_ROUTEID) values (44,87,to_date('25-APR-23','DD-MON-RR'),5);

COMMIT;
-- Inserting data into PROMOTION table
---------------------------------------------------------------------------
Insert into PROMOTION (PROMOTIONID,PROMOTIONNAME,PROMOTIONDESC,ACTIVE) values (1,'BofA',' For Bofa Platinum Members','Y');
Insert into PROMOTION (PROMOTIONID,PROMOTIONNAME,PROMOTIONDESC,ACTIVE) values (2,'Chase',' For Chase Diamond Members','Y');
Insert into PROMOTION (PROMOTIONID,PROMOTIONNAME,PROMOTIONDESC,ACTIVE) values (3,'Santander',' For Santander Gold Members','Y');

COMMIT;
-- Inserting data into BOOKING table
---------------------------------------------------------------------------
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (1,'BHIXM',to_date('29-JAN-23','DD-MON-RR'),18,1,1,1);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (2,'SBAIG',to_date('15-JAN-23','DD-MON-RR'),20,3,1,1);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (3,'TMXTA',to_date('15-FEB-23','DD-MON-RR'),10,1,2,1);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (4,'SJVXB',to_date('17-JAN-23','DD-MON-RR'),4,2,2,1);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (5,'NMNDW',to_date('17-FEB-23','DD-MON-RR'),16,1,2,1);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (6,'AJTEX',to_date('31-JAN-23','DD-MON-RR'),15,1,2,1);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (7,'DUIQM',to_date('16-JAN-23','DD-MON-RR'),14,3,2,1);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (8,'CVOSV',to_date('04-FEB-23','DD-MON-RR'),5,2,1,2);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (9,'GYBVG',to_date('04-JAN-23','DD-MON-RR'),7,1,1,2);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (10,'OLUVS',to_date('19-FEB-23','DD-MON-RR'),8,1,1,2);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (11,'CCSXD',to_date('15-FEB-23','DD-MON-RR'),2,2,1,2);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (12,'LZCIY',to_date('18-FEB-23','DD-MON-RR'),16,3,2,2);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (13,'CHNCM',to_date('03-FEB-23','DD-MON-RR'),3,2,2,2);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (14,'DAMKC',to_date('31-JAN-23','DD-MON-RR'),2,1,2,2);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (15,'PYSUK',to_date('17-FEB-23','DD-MON-RR'),22,3,2,2);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (16,'VXAVL',to_date('27-JAN-23','DD-MON-RR'),11,3,2,2);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (17,'BRSJX',to_date('05-JAN-23','DD-MON-RR'),19,2,1,3);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (18,'DLLQO',to_date('07-FEB-23','DD-MON-RR'),15,1,2,3);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (19,'YFKWS',to_date('30-JAN-23','DD-MON-RR'),24,3,2,3);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (20,'XIVQG',to_date('05-FEB-23','DD-MON-RR'),24,2,2,3);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (21,'RSYXA',to_date('01-FEB-23','DD-MON-RR'),22,3,2,3);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (22,'BBPSX',to_date('02-FEB-23','DD-MON-RR'),10,1,2,3);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (23,'NATQV',to_date('30-JAN-23','DD-MON-RR'),6,3,1,4);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (24,'UMBQS',to_date('28-JAN-23','DD-MON-RR'),5,1,1,4);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (25,'TKAPJ',to_date('07-FEB-23','DD-MON-RR'),20,3,2,4);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (26,'UECQB',to_date('11-FEB-23','DD-MON-RR'),15,3,1,5);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (27,'RIHON',to_date('23-JAN-23','DD-MON-RR'),2,3,2,5);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (28,'GTTZE',to_date('22-JAN-23','DD-MON-RR'),13,1,2,5);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (29,'QFJIN',to_date('17-FEB-23','DD-MON-RR'),7,2,1,6);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (30,'QBCVV',to_date('16-JAN-23','DD-MON-RR'),22,2,1,6);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (31,'QGOHD',to_date('01-JAN-23','DD-MON-RR'),9,3,1,6);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (32,'FIDQU',to_date('26-FEB-23','DD-MON-RR'),7,3,1,6);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (33,'BJZHT',to_date('06-JAN-23','DD-MON-RR'),8,2,1,6);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (34,'AZQPQ',to_date('06-FEB-23','DD-MON-RR'),19,1,2,6);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (35,'YPWIF',to_date('24-JAN-23','DD-MON-RR'),7,3,2,6);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (36,'CKHJN',to_date('01-FEB-23','DD-MON-RR'),24,1,2,6);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (37,'JOIHY',to_date('28-JAN-23','DD-MON-RR'),9,3,2,6);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (38,'TMSGW',to_date('27-FEB-23','DD-MON-RR'),3,1,1,7);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (39,'JKQKL',to_date('26-JAN-23','DD-MON-RR'),6,2,1,7);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (40,'EGYIF',to_date('21-FEB-23','DD-MON-RR'),9,1,2,7);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (41,'SKSXA',to_date('27-FEB-23','DD-MON-RR'),5,2,2,7);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (42,'HZVVU',to_date('03-FEB-23','DD-MON-RR'),23,3,2,7);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (43,'QLMAZ',to_date('02-FEB-23','DD-MON-RR'),4,3,2,7);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (44,'JMOZH',to_date('04-FEB-23','DD-MON-RR'),8,2,2,7);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (45,'ODNWQ',to_date('07-JAN-23','DD-MON-RR'),3,2,1,8);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (46,'LQKLN',to_date('04-FEB-23','DD-MON-RR'),2,2,2,8);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (47,'SNQNA',to_date('17-FEB-23','DD-MON-RR'),18,3,2,8);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (48,'PXFMP',to_date('30-JAN-23','DD-MON-RR'),1,3,2,8);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (49,'OPUFR',to_date('07-JAN-23','DD-MON-RR'),14,2,2,8);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (50,'HQZWL',to_date('14-FEB-23','DD-MON-RR'),22,2,1,9);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (51,'EOHSI',to_date('03-FEB-23','DD-MON-RR'),12,3,1,9);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (52,'IFRIZ',to_date('07-FEB-23','DD-MON-RR'),19,1,2,9);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (53,'DLZOI',to_date('22-JAN-23','DD-MON-RR'),24,2,1,10);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (54,'ZYGHK',to_date('15-FEB-23','DD-MON-RR'),15,3,1,10);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (55,'AEWYH',to_date('09-FEB-23','DD-MON-RR'),20,2,1,10);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (56,'RQZTG',to_date('19-FEB-23','DD-MON-RR'),25,1,1,10);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (57,'ZXEZT',to_date('08-JAN-23','DD-MON-RR'),2,1,2,10);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (58,'MSXVV',to_date('20-JAN-23','DD-MON-RR'),16,2,2,10);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (59,'FNYSB',to_date('21-FEB-23','DD-MON-RR'),1,1,2,10);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (60,'WCPLG',to_date('10-JAN-23','DD-MON-RR'),2,2,2,10);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (61,'JPEKX',to_date('18-FEB-23','DD-MON-RR'),11,2,1,11);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (62,'IYJKR',to_date('02-FEB-23','DD-MON-RR'),7,3,1,11);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (63,'TXXCL',to_date('27-JAN-23','DD-MON-RR'),18,3,1,11);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (64,'IHVCV',to_date('02-FEB-23','DD-MON-RR'),6,1,1,11);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (65,'JHCID',to_date('10-JAN-23','DD-MON-RR'),7,1,1,11);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (66,'IENLD',to_date('22-JAN-23','DD-MON-RR'),4,2,2,11);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (67,'UPLMA',to_date('04-JAN-23','DD-MON-RR'),20,1,1,12);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (68,'QLREV',to_date('15-FEB-23','DD-MON-RR'),17,3,1,12);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (69,'GSYWR',to_date('17-JAN-23','DD-MON-RR'),9,3,2,12);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (70,'TDEUW',to_date('11-FEB-23','DD-MON-RR'),13,2,1,13);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (71,'GCIIV',to_date('17-JAN-23','DD-MON-RR'),6,2,1,13);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (72,'MOAVU',to_date('31-JAN-23','DD-MON-RR'),15,2,2,13);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (73,'WXBLT',to_date('18-JAN-23','DD-MON-RR'),16,1,2,13);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (74,'ZGCAJ',to_date('03-FEB-23','DD-MON-RR'),14,3,2,13);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (75,'SVLKZ',to_date('23-JAN-23','DD-MON-RR'),8,3,1,14);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (76,'SMQOC',to_date('31-JAN-23','DD-MON-RR'),20,1,1,14);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (77,'DMTEQ',to_date('20-FEB-23','DD-MON-RR'),6,3,1,14);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (78,'TDZKA',to_date('18-JAN-23','DD-MON-RR'),6,2,2,14);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (79,'CKUPF',to_date('17-FEB-23','DD-MON-RR'),6,3,2,14);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (80,'KWJFW',to_date('23-FEB-23','DD-MON-RR'),7,2,1,15);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (81,'BRYRR',to_date('14-FEB-23','DD-MON-RR'),8,1,1,15);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (82,'WKMOQ',to_date('01-FEB-23','DD-MON-RR'),11,1,2,15);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (83,'UZXLK',to_date('31-JAN-23','DD-MON-RR'),14,1,2,15);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (84,'CRYOP',to_date('06-FEB-23','DD-MON-RR'),17,3,1,16);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (85,'JZHCE',to_date('21-FEB-23','DD-MON-RR'),1,1,1,16);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (86,'AYCPO',to_date('13-FEB-23','DD-MON-RR'),20,3,1,16);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (87,'OQGKY',to_date('16-FEB-23','DD-MON-RR'),14,1,1,16);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (88,'RVIFB',to_date('06-FEB-23','DD-MON-RR'),23,1,1,16);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (89,'WRCKG',to_date('16-JAN-23','DD-MON-RR'),2,2,2,16);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (90,'LRKQE',to_date('16-JAN-23','DD-MON-RR'),25,3,2,16);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (91,'PMSPX',to_date('23-FEB-23','DD-MON-RR'),7,2,2,16);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (92,'AYOGD',to_date('31-JAN-23','DD-MON-RR'),4,1,1,17);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (93,'TVXAG',to_date('17-JAN-23','DD-MON-RR'),13,3,1,17);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (94,'DDUGP',to_date('21-FEB-23','DD-MON-RR'),21,2,2,17);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (95,'XPLUD',to_date('06-JAN-23','DD-MON-RR'),9,2,1,18);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (96,'LVSGB',to_date('07-FEB-23','DD-MON-RR'),13,1,1,18);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (97,'ZDPGT',to_date('07-JAN-23','DD-MON-RR'),20,3,1,18);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (98,'YYYOX',to_date('21-JAN-23','DD-MON-RR'),15,2,2,18);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (99,'NHAXI',to_date('21-JAN-23','DD-MON-RR'),12,2,1,19);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (100,'PZQBJ',to_date('18-FEB-23','DD-MON-RR'),15,3,1,19);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (101,'SRDVD',to_date('11-FEB-23','DD-MON-RR'),20,3,1,19);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (102,'GLBAQ',to_date('30-JAN-23','DD-MON-RR'),11,1,1,19);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (103,'DPNQJ',to_date('12-JAN-23','DD-MON-RR'),17,2,1,19);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (104,'BYNYG',to_date('23-FEB-23','DD-MON-RR'),15,2,2,19);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (105,'VRPXG',to_date('18-FEB-23','DD-MON-RR'),20,3,2,19);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (106,'CHROK',to_date('30-JAN-23','DD-MON-RR'),12,1,2,19);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (107,'PGNEL',to_date('01-FEB-23','DD-MON-RR'),12,1,2,19);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (108,'JJEUN',to_date('26-FEB-23','DD-MON-RR'),25,2,2,19);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (109,'TOWBK',to_date('10-FEB-23','DD-MON-RR'),5,3,1,20);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (110,'XRSVZ',to_date('14-JAN-23','DD-MON-RR'),3,3,1,20);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (111,'XSBYY',to_date('19-JAN-23','DD-MON-RR'),18,1,1,20);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (112,'JJLAA',to_date('01-FEB-23','DD-MON-RR'),23,2,2,20);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (113,'ISDYV',to_date('16-FEB-23','DD-MON-RR'),23,3,2,20);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (114,'DKWXE',to_date('22-JAN-23','DD-MON-RR'),25,2,2,20);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (115,'EVRGV',to_date('10-JAN-23','DD-MON-RR'),7,2,1,21);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (116,'DXLVN',to_date('28-JAN-23','DD-MON-RR'),6,2,1,21);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (117,'GVIKS',to_date('16-FEB-23','DD-MON-RR'),16,1,1,21);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (118,'XMOEA',to_date('03-JAN-23','DD-MON-RR'),23,1,1,21);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (119,'UIIEW',to_date('24-FEB-23','DD-MON-RR'),24,2,1,21);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (120,'HXDGJ',to_date('05-FEB-23','DD-MON-RR'),13,2,2,21);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (121,'BJORY',to_date('08-FEB-23','DD-MON-RR'),13,2,1,22);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (122,'TARGS',to_date('05-FEB-23','DD-MON-RR'),11,2,1,22);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (123,'NAAFN',to_date('18-JAN-23','DD-MON-RR'),10,2,1,22);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (124,'MYPUN',to_date('11-JAN-23','DD-MON-RR'),15,2,1,22);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (125,'TLUJR',to_date('30-JAN-23','DD-MON-RR'),9,2,2,22);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (126,'SIEUI',to_date('30-JAN-23','DD-MON-RR'),1,3,2,22);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (127,'PUEHL',to_date('20-FEB-23','DD-MON-RR'),18,1,2,22);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (128,'WENYS',to_date('17-JAN-23','DD-MON-RR'),9,2,2,22);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (129,'AVHCF',to_date('08-JAN-23','DD-MON-RR'),24,3,1,23);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (130,'IGXWV',to_date('04-FEB-23','DD-MON-RR'),9,3,1,23);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (131,'CKWWZ',to_date('03-JAN-23','DD-MON-RR'),6,3,1,23);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (132,'SEGIA',to_date('09-MAR-23','DD-MON-RR'),16,2,1,23);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (133,'XZSDD',to_date('05-JAN-23','DD-MON-RR'),1,3,2,23);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (134,'OZVFZ',to_date('02-JAN-23','DD-MON-RR'),18,2,2,23);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (135,'JENRA',to_date('29-JAN-23','DD-MON-RR'),19,3,2,23);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (136,'WFMQG',to_date('13-FEB-23','DD-MON-RR'),19,3,2,23);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (137,'SDFQX',to_date('26-JAN-23','DD-MON-RR'),10,2,2,23);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (138,'ULSQW',to_date('20-FEB-23','DD-MON-RR'),23,3,1,24);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (139,'QOLDZ',to_date('03-FEB-23','DD-MON-RR'),17,1,1,24);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (140,'ZVSHK',to_date('09-JAN-23','DD-MON-RR'),5,3,1,24);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (141,'VLCOB',to_date('04-JAN-23','DD-MON-RR'),8,1,1,24);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (142,'ISPUG',to_date('04-JAN-23','DD-MON-RR'),25,1,2,24);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (143,'YEXMV',to_date('11-MAR-23','DD-MON-RR'),6,1,1,25);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (144,'IQCKF',to_date('31-JAN-23','DD-MON-RR'),14,2,1,25);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (145,'HDLPW',to_date('01-FEB-23','DD-MON-RR'),14,3,1,25);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (146,'IHEUR',to_date('13-MAR-23','DD-MON-RR'),4,2,2,25);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (147,'MGSTM',to_date('23-JAN-23','DD-MON-RR'),13,2,2,25);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (148,'NXJZP',to_date('20-JAN-23','DD-MON-RR'),24,3,2,25);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (149,'IHCSJ',to_date('05-FEB-23','DD-MON-RR'),22,3,2,25);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (150,'XVUOV',to_date('20-JAN-23','DD-MON-RR'),22,3,1,26);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (151,'GGURA',to_date('07-JAN-23','DD-MON-RR'),3,3,1,26);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (152,'CPVNY',to_date('21-FEB-23','DD-MON-RR'),1,2,1,26);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (153,'QXNVU',to_date('20-FEB-23','DD-MON-RR'),21,2,1,26);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (154,'HXCIO',to_date('27-JAN-23','DD-MON-RR'),22,2,2,26);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (155,'GWNLX',to_date('03-FEB-23','DD-MON-RR'),8,1,1,27);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (156,'BMNNR',to_date('20-JAN-23','DD-MON-RR'),18,1,1,27);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (157,'MWJKV',to_date('07-MAR-23','DD-MON-RR'),6,1,1,27);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (158,'URXGD',to_date('08-MAR-23','DD-MON-RR'),6,1,2,27);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (159,'TJYWR',to_date('20-JAN-23','DD-MON-RR'),21,2,2,27);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (160,'JPSJS',to_date('14-MAR-23','DD-MON-RR'),18,3,2,27);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (161,'SMGRL',to_date('02-MAR-23','DD-MON-RR'),24,2,2,27);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (162,'TOZNA',to_date('22-JAN-23','DD-MON-RR'),25,3,2,27);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (163,'OSLZY',to_date('30-JAN-23','DD-MON-RR'),16,1,1,28);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (164,'ZLHOG',to_date('29-JAN-23','DD-MON-RR'),12,2,1,28);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (165,'VTVPS',to_date('13-JAN-23','DD-MON-RR'),21,3,1,28);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (166,'UDLOY',to_date('17-JAN-23','DD-MON-RR'),1,2,1,28);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (167,'SYZCQ',to_date('07-JAN-23','DD-MON-RR'),25,2,2,28);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (168,'TNDGD',to_date('11-FEB-23','DD-MON-RR'),4,2,1,29);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (169,'BBNOC',to_date('24-FEB-23','DD-MON-RR'),16,3,2,29);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (170,'DJSIJ',to_date('09-JAN-23','DD-MON-RR'),22,2,2,29);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (171,'HKFNN',to_date('24-JAN-23','DD-MON-RR'),3,3,1,30);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (172,'NKRBB',to_date('27-JAN-23','DD-MON-RR'),12,3,2,30);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (173,'LKGLU',to_date('13-MAR-23','DD-MON-RR'),15,1,2,30);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (174,'BWHTU',to_date('20-JAN-23','DD-MON-RR'),13,1,1,31);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (175,'KYTVK',to_date('23-FEB-23','DD-MON-RR'),12,3,1,31);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (176,'LQQOV',to_date('01-JAN-23','DD-MON-RR'),16,2,1,31);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (177,'UZARP',to_date('23-JAN-23','DD-MON-RR'),7,1,2,31);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (178,'WKYKW',to_date('07-JAN-23','DD-MON-RR'),14,3,2,31);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (179,'UGFSG',to_date('13-JAN-23','DD-MON-RR'),3,1,1,32);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (180,'AXDJK',to_date('14-MAR-23','DD-MON-RR'),10,1,2,32);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (181,'LNVJS',to_date('09-FEB-23','DD-MON-RR'),2,2,2,32);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (182,'XCZIV',to_date('17-FEB-23','DD-MON-RR'),19,1,2,32);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (183,'FJATA',to_date('18-FEB-23','DD-MON-RR'),10,1,2,32);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (184,'DEKKW',to_date('25-JAN-23','DD-MON-RR'),16,2,1,33);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (185,'FPZGT',to_date('09-FEB-23','DD-MON-RR'),23,3,1,33);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (186,'GEYEV',to_date('03-MAR-23','DD-MON-RR'),12,3,2,33);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (187,'NHOKI',to_date('03-JAN-23','DD-MON-RR'),25,3,2,33);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (188,'FLCCD',to_date('12-MAR-23','DD-MON-RR'),24,1,2,33);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (189,'IANOL',to_date('29-JAN-23','DD-MON-RR'),2,2,2,33);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (190,'DQGDV',to_date('09-FEB-23','DD-MON-RR'),3,3,2,33);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (191,'EWIAN',to_date('19-FEB-23','DD-MON-RR'),15,2,1,34);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (192,'ZTBGI',to_date('28-FEB-23','DD-MON-RR'),11,3,1,34);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (193,'UONFV',to_date('27-FEB-23','DD-MON-RR'),15,2,1,34);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (194,'OWJQW',to_date('13-JAN-23','DD-MON-RR'),25,2,1,34);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (195,'TYUUK',to_date('30-JAN-23','DD-MON-RR'),4,3,2,34);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (196,'NMEMZ',to_date('26-FEB-23','DD-MON-RR'),9,1,1,35);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (197,'PLPKR',to_date('18-JAN-23','DD-MON-RR'),10,3,1,35);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (198,'MJUCY',to_date('06-FEB-23','DD-MON-RR'),22,3,1,35);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (199,'NOHAI',to_date('10-MAR-23','DD-MON-RR'),24,2,1,35);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (200,'KMHEQ',to_date('05-MAR-23','DD-MON-RR'),13,2,2,35);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (201,'NZCPS',to_date('06-JAN-23','DD-MON-RR'),16,2,2,35);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (202,'UDCSM',to_date('20-FEB-23','DD-MON-RR'),16,1,2,35);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (203,'VIMJQ',to_date('02-FEB-23','DD-MON-RR'),7,1,2,35);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (204,'WNWTM',to_date('12-JAN-23','DD-MON-RR'),23,3,2,35);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (205,'MELFE',to_date('23-JAN-23','DD-MON-RR'),14,2,1,36);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (206,'LRXYS',to_date('04-MAR-23','DD-MON-RR'),3,3,2,36);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (207,'NDUOY',to_date('01-MAR-23','DD-MON-RR'),15,1,2,36);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (208,'ADOVQ',to_date('15-JAN-23','DD-MON-RR'),19,1,2,36);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (209,'DAERM',to_date('03-MAR-23','DD-MON-RR'),16,1,2,36);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (210,'DVYSW',to_date('06-FEB-23','DD-MON-RR'),17,2,2,36);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (211,'LZKWZ',to_date('09-MAR-23','DD-MON-RR'),19,2,1,37);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (212,'PQLCV',to_date('10-FEB-23','DD-MON-RR'),1,1,1,37);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (213,'MOYGC',to_date('13-FEB-23','DD-MON-RR'),19,3,2,37);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (214,'LWPND',to_date('25-JAN-23','DD-MON-RR'),13,3,2,37);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (215,'LHIKL',to_date('10-JAN-23','DD-MON-RR'),11,3,2,37);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (216,'YCOOZ',to_date('13-FEB-23','DD-MON-RR'),6,2,1,38);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (217,'IXDKT',to_date('14-JAN-23','DD-MON-RR'),4,2,2,38);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (218,'YEEQI',to_date('16-JAN-23','DD-MON-RR'),2,3,2,38);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (219,'FYKAW',to_date('28-JAN-23','DD-MON-RR'),25,3,2,38);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (220,'NNKNQ',to_date('25-JAN-23','DD-MON-RR'),11,2,1,39);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (221,'RWWWX',to_date('07-FEB-23','DD-MON-RR'),15,3,1,39);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (222,'WWSKV',to_date('18-FEB-23','DD-MON-RR'),25,3,2,39);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (223,'JOZYT',to_date('19-FEB-23','DD-MON-RR'),23,3,2,39);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (224,'FOXTJ',to_date('07-MAR-23','DD-MON-RR'),14,3,1,40);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (225,'SQKMU',to_date('09-JAN-23','DD-MON-RR'),23,1,1,40);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (226,'ZTYJL',to_date('28-FEB-23','DD-MON-RR'),14,3,2,40);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (227,'HXJIS',to_date('17-JAN-23','DD-MON-RR'),11,1,2,40);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (228,'HNTOG',to_date('13-JAN-23','DD-MON-RR'),11,2,2,40);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (229,'OMIXT',to_date('03-JAN-23','DD-MON-RR'),11,2,2,40);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (230,'FAVDM',to_date('01-FEB-23','DD-MON-RR'),3,3,2,40);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (231,'MUHCC',to_date('07-FEB-23','DD-MON-RR'),8,3,1,41);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (232,'MVMBH',to_date('10-MAR-23','DD-MON-RR'),6,2,1,41);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (233,'SZTXT',to_date('08-JAN-23','DD-MON-RR'),11,2,2,41);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (234,'RUMQW',to_date('17-FEB-23','DD-MON-RR'),17,1,1,42);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (235,'QXPCF',to_date('10-JAN-23','DD-MON-RR'),21,1,1,42);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (236,'RGNES',to_date('11-FEB-23','DD-MON-RR'),21,1,1,42);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (237,'HZHKC',to_date('22-FEB-23','DD-MON-RR'),9,2,2,42);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (238,'QSNAX',to_date('13-FEB-23','DD-MON-RR'),14,3,1,43);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (239,'JMFBF',to_date('24-JAN-23','DD-MON-RR'),16,1,2,43);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (240,'OWWVE',to_date('04-JAN-23','DD-MON-RR'),16,1,2,43);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (241,'QCHRI',to_date('26-FEB-23','DD-MON-RR'),20,1,2,43);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (242,'TTFQJ',to_date('02-FEB-23','DD-MON-RR'),14,1,1,44);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (243,'DDTDR',to_date('14-FEB-23','DD-MON-RR'),8,3,1,44);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (244,'DWEZG',to_date('01-JAN-23','DD-MON-RR'),19,1,1,44);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (245,'FHMND',to_date('24-JAN-23','DD-MON-RR'),18,2,1,44);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (246,'FIOMZ',to_date('17-JAN-23','DD-MON-RR'),21,3,2,44);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (247,'CKWGE',to_date('05-JAN-23','DD-MON-RR'),6,3,2,44);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (248,'XNLQV',to_date('03-MAR-23','DD-MON-RR'),10,3,2,44);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (249,'WKLYC',to_date('22-FEB-23','DD-MON-RR'),13,2,2,44);
Insert into BOOKING (BOOKINGID,PNR,DATEOFBOOKING,CUSTOMER_ID,PROMOTION_PROMOTIONID,SEAT_TYPE_SEATTYPEID,FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID) values (250,'DAQHC',to_date('07-FEB-23','DD-MON-RR'),2,3,2,44);

COMMIT;

-- Data for table Status
-- -----------------------------------------------------
Insert into STATUS (STATUSID,STATUS) values (1,'Booked');
Insert into STATUS (STATUSID,STATUS) values (2,'Cancelled');

COMMIT;

-- Data for table Passenger
-- -----------------------------------------------------
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (205,'Kristi','Kohler','Kristi76@yahoo.com','1051681906',26,'F',131,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (206,'Darla','Balistreri','Darla.Balistreri25@gmail.com','9077051489',56,'F',132,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (207,'Fredrick','Kuhic','Fredrick97@gmail.com','9851698275',60,'F',133,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (208,'Karen','Wintheiser','Karen_Wintheiser91@gmail.com','9679794329',9,'M',134,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (209,'Elsa','Wintheiser','Elsa91@yahoo.com','6152854149',19,'F',134,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (210,'Gilberto','Pfeffer','Gilberto.Pfeffer@gmail.com','2531343269',34,'F',135,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (211,'Gilberto','Pfeffer','Gilberto.Pfeffer@gmail.com','2531343269',15,'F',136,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (212,'Jacqueline','Pfeffer','Jacqueline.Larson37@hotmail.com','3790162569',60,'F',136,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (213,'Andrew','Leannon','Andrew_Leannon@gmail.com','1308608494',16,'M',137,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (214,'Shelia','Koepp','Shelia74@gmail.com','3150575514',54,'F',138,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (215,'Bradford','Stiedemann','Bradford39@gmail.com','7668861386',61,'M',139,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (216,'Jackie','Runte','Jackie.Runte@hotmail.com','5165091524',49,'M',140,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (217,'Santiago','Rippin','Santiago.Rippin89@yahoo.com','4155178945',62,'M',141,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (218,'Carroll','Murphy','Carroll_Murphy62@gmail.com','7636236121',20,'M',142,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (219,'Audrey','Kohler','Audrey_Kohler@yahoo.com','1025161269',4,'M',143,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (220,'Hilda','Kohler','Hilda_Tremblay95@gmail.com','7880586711',48,'F',143,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (221,'Shannon','Turcotte','Shannon23@yahoo.com','3606292461',19,'F',144,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (222,'Sharon','Turcotte','Sharon60@yahoo.com','5503522982',40,'F',144,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (223,'Shannon','Turcotte','Shannon23@yahoo.com','3606292461',29,'M',145,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (224,'Jerry','Hermann','Jerry46@hotmail.com','5162354426',54,'F',146,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (225,'Harry','Hermann','Harry_Beier54@yahoo.com','5786688061',43,'M',146,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (226,'Molly','Hermann','Molly78@gmail.com','5597993506',13,'F',146,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (227,'Teresa','Kling','Teresa.Kling45@hotmail.com','8329288895',7,'M',147,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (228,'Genevieve','Parker','Genevieve_Parker@yahoo.com','8900435771',64,'M',148,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (229,'Jacob','Bosco','Jacob_Bosco82@yahoo.com','1243021907',48,'M',149,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (230,'Lucia','Bosco','Lucia90@gmail.com','9237714624',4,'F',149,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (231,'Tasha','Bosco','Tasha.OKon@gmail.com','7212683065',12,'F',149,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (232,'Jacob','Bosco','Jacob_Bosco82@yahoo.com','1243021907',7,'F',150,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (233,'Keith','Purdy','Keith.Purdy@gmail.com','7086201608',67,'M',151,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (234,'Fredrick','Kuhic','Fredrick97@gmail.com','9851698275',41,'F',152,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (235,'Anne','Schroeder','Anne78@hotmail.com','6147301761',31,'M',153,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (236,'Molly','Schroeder','Molly_Shanahan@hotmail.com','5927639156',13,'F',153,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (237,'Jacob','Bosco','Jacob_Bosco82@yahoo.com','1243021907',30,'F',154,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (238,'Troy','Bosco','Troy48@gmail.com','4666322163',4,'M',154,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (239,'Nelson','Bosco','Nelson_Wisoky68@hotmail.com','8783181250',19,'M',154,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (240,'Santiago','Rippin','Santiago.Rippin89@yahoo.com','4155178945',6,'M',155,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (241,'Karen','Wintheiser','Karen_Wintheiser91@gmail.com','9679794329',22,'F',156,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (242,'Audrey','Kohler','Audrey_Kohler@yahoo.com','1025161269',9,'M',157,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (243,'Audrey','Kohler','Audrey_Kohler@yahoo.com','1025161269',52,'M',158,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (244,'Anne','Schroeder','Anne78@hotmail.com','6147301761',19,'F',159,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (245,'Karen','Wintheiser','Karen_Wintheiser91@gmail.com','9679794329',54,'F',160,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (246,'Leonard','Wintheiser','Leonard_OKeefe@yahoo.com','1831291098',9,'M',160,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (247,'Genevieve','Parker','Genevieve_Parker@yahoo.com','8900435771',59,'M',161,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (248,'Carroll','Murphy','Carroll_Murphy62@gmail.com','7636236121',65,'F',162,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (249,'Travis','Murphy','Travis8@gmail.com','9596510867',6,'M',162,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (250,'Victoria','Murphy','Victoria_Legros@gmail.com','3846016556',54,'F',162,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (251,'Darla','Balistreri','Darla.Balistreri25@gmail.com','9077051489',59,'M',163,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (252,'Erma','Mills','Erma99@hotmail.com','3205588765',52,'F',164,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (253,'Allan','Mills','Allan44@gmail.com','1029570830',66,'M',164,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (254,'Howard','Mills','Howard_Moen@gmail.com','6634265764',13,'M',164,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (255,'Anne','Schroeder','Anne78@hotmail.com','6147301761',34,'M',165,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (256,'Fredrick','Kuhic','Fredrick97@gmail.com','9851698275',7,'M',166,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (257,'Carroll','Murphy','Carroll_Murphy62@gmail.com','7636236121',2,'F',167,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (258,'Jerry','Hermann','Jerry46@hotmail.com','5162354426',12,'M',168,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (259,'Darla','Balistreri','Darla.Balistreri25@gmail.com','9077051489',16,'F',169,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (260,'Tracy','Balistreri','Tracy.Kohler77@hotmail.com','4987081116',14,'M',169,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (261,'Benny','Balistreri','Benny.Smith@hotmail.com','6463053419',35,'M',169,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (262,'Jacob','Bosco','Jacob_Bosco82@yahoo.com','1243021907',41,'M',170,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (263,'Keith','Purdy','Keith.Purdy@gmail.com','7086201608',24,'F',171,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (264,'Camille','Purdy','Camille.Glover3@hotmail.com','8969349552',6,'F',171,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (265,'Erma','Mills','Erma99@hotmail.com','3205588765',33,'M',172,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (266,'Beulah','Cruickshank','Beulah6@hotmail.com','1450149332',60,'M',173,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (267,'Teresa','Kling','Teresa.Kling45@hotmail.com','8329288895',42,'F',174,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (268,'Erma','Mills','Erma99@hotmail.com','3205588765',14,'F',175,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (269,'Darla','Balistreri','Darla.Balistreri25@gmail.com','9077051489',22,'M',176,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (270,'Maria','Rolfson','Maria_Rolfson91@gmail.com','7339062790',1,'F',177,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (271,'Shannon','Turcotte','Shannon23@yahoo.com','3606292461',51,'M',178,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (272,'Keith','Purdy','Keith.Purdy@gmail.com','7086201608',41,'F',179,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (273,'Andrew','Leannon','Andrew_Leannon@gmail.com','1308608494',39,'F',180,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (274,'Alexandra','Moen','Alexandra76@hotmail.com','4111467271',6,'M',181,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (275,'Gilberto','Pfeffer','Gilberto.Pfeffer@gmail.com','2531343269',5,'M',182,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (276,'Tracy','Pfeffer','Tracy_Upton@hotmail.com','6573248260',21,'F',182,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (277,'Andrew','Leannon','Andrew_Leannon@gmail.com','1308608494',52,'F',183,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (278,'Darla','Balistreri','Darla.Balistreri25@gmail.com','9077051489',43,'F',184,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (279,'Jennie','Balistreri','Jennie_Cruickshank@hotmail.com','2011712548',68,'F',184,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (280,'Brandi','Balistreri','Brandi_Kris37@gmail.com','9783449254',52,'F',184,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (281,'Shelia','Koepp','Shelia74@gmail.com','3150575514',4,'F',185,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (282,'Eloise','Koepp','Eloise.Klein74@hotmail.com','5105008328',1,'F',185,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (283,'Erma','Mills','Erma99@hotmail.com','3205588765',36,'M',186,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (284,'Carroll','Murphy','Carroll_Murphy62@gmail.com','7636236121',30,'M',187,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (285,'Genevieve','Parker','Genevieve_Parker@yahoo.com','8900435771',35,'M',188,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (286,'Alexandra','Moen','Alexandra76@hotmail.com','4111467271',60,'F',189,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (287,'Viola','Moen','Viola_Abbott85@gmail.com','3833237076',24,'F',189,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (288,'Francis','Moen','Francis.Kohler@yahoo.com','2420133313',65,'F',189,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (289,'Keith','Purdy','Keith.Purdy@gmail.com','7086201608',18,'F',190,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (290,'Beulah','Cruickshank','Beulah6@hotmail.com','1450149332',26,'F',191,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (291,'Paul','Cruickshank','Paul1@gmail.com','6041779446',10,'M',191,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (292,'Damon','Cruickshank','Damon_Dibbert34@hotmail.com','5507960990',40,'M',191,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (293,'Bob','Miller','Bob18@hotmail.com','5947299265',22,'F',192,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (294,'Beulah','Cruickshank','Beulah6@hotmail.com','1450149332',41,'M',193,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (295,'Jean','Cruickshank','Jean89@gmail.com','7632216965',10,'M',193,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (296,'Carroll','Murphy','Carroll_Murphy62@gmail.com','7636236121',25,'M',194,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (297,'Jerry','Hermann','Jerry46@hotmail.com','5162354426',25,'M',195,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (298,'Ruben','Okuneva','Ruben.Okuneva34@hotmail.com','6849079568',49,'M',196,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (299,'Andrew','Leannon','Andrew_Leannon@gmail.com','1308608494',5,'M',197,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (300,'Jacob','Bosco','Jacob_Bosco82@yahoo.com','1243021907',12,'M',198,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (301,'Greg','Bosco','Greg.Larson@yahoo.com','4140133486',55,'M',198,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (302,'Calvin','Bosco','Calvin.Gerlach18@yahoo.com','8361811072',2,'M',198,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (303,'Genevieve','Parker','Genevieve_Parker@yahoo.com','8900435771',57,'M',199,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (304,'Teresa','Kling','Teresa.Kling45@hotmail.com','8329288895',49,'M',200,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (305,'Darla','Balistreri','Darla.Balistreri25@gmail.com','9077051489',8,'M',201,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (306,'Darla','Balistreri','Darla.Balistreri25@gmail.com','9077051489',29,'F',202,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (307,'Maria','Rolfson','Maria_Rolfson91@gmail.com','7339062790',61,'F',203,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (308,'Shelia','Koepp','Shelia74@gmail.com','3150575514',44,'M',204,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (309,'Shannon','Turcotte','Shannon23@yahoo.com','3606292461',19,'M',205,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (310,'Carole','Turcotte','Carole45@gmail.com','5043049864',57,'F',205,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (311,'Keith','Purdy','Keith.Purdy@gmail.com','7086201608',49,'F',206,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (312,'Beulah','Cruickshank','Beulah6@hotmail.com','1450149332',8,'M',207,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (313,'Vickie','Cruickshank','Vickie0@hotmail.com','3407471613',66,'F',207,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (314,'Gilberto','Pfeffer','Gilberto.Pfeffer@gmail.com','2531343269',18,'F',208,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (315,'Darla','Balistreri','Darla.Balistreri25@gmail.com','9077051489',56,'F',209,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (316,'Bradford','Stiedemann','Bradford39@gmail.com','7668861386',62,'M',210,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (317,'Gilberto','Pfeffer','Gilberto.Pfeffer@gmail.com','2531343269',48,'M',211,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (318,'Fredrick','Kuhic','Fredrick97@gmail.com','9851698275',34,'F',212,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (319,'Gilberto','Pfeffer','Gilberto.Pfeffer@gmail.com','2531343269',24,'F',213,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (320,'Teresa','Kling','Teresa.Kling45@hotmail.com','8329288895',46,'M',214,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (321,'Bob','Miller','Bob18@hotmail.com','5947299265',43,'M',215,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (322,'Charlene','Miller','Charlene_Hilpert1@gmail.com','9165070905',6,'F',215,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (323,'Dora','Miller','Dora95@yahoo.com','8768006849',58,'F',215,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (324,'Audrey','Kohler','Audrey_Kohler@yahoo.com','1025161269',68,'M',216,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (325,'Jerry','Hermann','Jerry46@hotmail.com','5162354426',54,'M',217,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (326,'Jim','Hermann','Jim.Hickle@hotmail.com','8588862725',35,'M',217,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (327,'Alexandra','Moen','Alexandra76@hotmail.com','4111467271',38,'M',218,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (328,'Eddie','Moen','Eddie93@hotmail.com','6852195733',22,'M',218,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (329,'Wesley','Moen','Wesley.Koelpin43@gmail.com','9844572483',37,'M',218,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (330,'Carroll','Murphy','Carroll_Murphy62@gmail.com','7636236121',16,'M',219,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (331,'Bob','Miller','Bob18@hotmail.com','5947299265',51,'M',220,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (332,'Beulah','Cruickshank','Beulah6@hotmail.com','1450149332',3,'M',221,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (333,'Carroll','Murphy','Carroll_Murphy62@gmail.com','7636236121',16,'F',222,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (334,'Eleanor','Murphy','Eleanor_Schmeler68@hotmail.com','7704573284',26,'F',222,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (335,'Charlotte','Murphy','Charlotte35@gmail.com','2837906295',26,'F',222,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (336,'Shelia','Koepp','Shelia74@gmail.com','3150575514',70,'M',223,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (337,'Shannon','Turcotte','Shannon23@yahoo.com','3606292461',56,'F',224,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (338,'Shelia','Koepp','Shelia74@gmail.com','3150575514',21,'F',225,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (339,'Glenda','Koepp','Glenda98@yahoo.com','2348398751',36,'F',225,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (340,'Charles','Koepp','Charles.Braun@yahoo.com','5854537799',49,'M',225,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (341,'Shannon','Turcotte','Shannon23@yahoo.com','3606292461',50,'F',226,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (342,'Bob','Miller','Bob18@hotmail.com','5947299265',3,'M',227,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (343,'Cary','Miller','Cary_Buckridge@hotmail.com','3675652531',52,'M',227,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (344,'Timmy','Miller','Timmy_Reilly27@gmail.com','5964507623',44,'M',227,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (345,'Bob','Miller','Bob18@hotmail.com','5947299265',1,'F',228,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (346,'Bob','Miller','Bob18@hotmail.com','5947299265',29,'F',229,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (347,'Keith','Purdy','Keith.Purdy@gmail.com','7086201608',49,'F',230,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (348,'Santiago','Rippin','Santiago.Rippin89@yahoo.com','4155178945',43,'F',231,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (349,'Audrey','Kohler','Audrey_Kohler@yahoo.com','1025161269',11,'F',232,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (350,'Sheldon','Kohler','Sheldon35@hotmail.com','9840150047',36,'M',232,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (351,'Shannon','Kohler','Shannon88@hotmail.com','1570971938',66,'M',232,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (352,'Bob','Miller','Bob18@hotmail.com','5947299265',46,'M',233,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (353,'Lionel','Miller','Lionel.Wolf32@yahoo.com','7925475591',26,'M',233,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (354,'Bradford','Stiedemann','Bradford39@gmail.com','7668861386',64,'M',234,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (355,'Anne','Schroeder','Anne78@hotmail.com','6147301761',6,'M',235,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (356,'Leigh','Schroeder','Leigh.Hartmann@yahoo.com','8319392312',57,'F',235,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (357,'Claudia','Schroeder','Claudia40@yahoo.com','5202866404',15,'F',235,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (358,'Anne','Schroeder','Anne78@hotmail.com','6147301761',36,'F',236,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (359,'Gary','Schroeder','Gary_Kuvalis@hotmail.com','2475179642',64,'M',236,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (360,'Ruben','Okuneva','Ruben.Okuneva34@hotmail.com','6849079568',27,'F',237,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (361,'Shannon','Turcotte','Shannon23@yahoo.com','3606292461',30,'M',238,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (362,'Darla','Balistreri','Darla.Balistreri25@gmail.com','9077051489',67,'M',239,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (363,'Darla','Balistreri','Darla.Balistreri25@gmail.com','9077051489',70,'F',240,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (364,'Brenda','Balistreri','Brenda.Grady87@yahoo.com','4857136606',42,'F',240,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (365,'Angie','Hessel','Angie54@hotmail.com','3300355373',42,'M',241,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (366,'Shannon','Turcotte','Shannon23@yahoo.com','3606292461',58,'F',242,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (367,'Lora','Turcotte','Lora77@hotmail.com','1010412828',9,'F',242,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (368,'Santiago','Rippin','Santiago.Rippin89@yahoo.com','4155178945',28,'F',243,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (369,'Gilberto','Pfeffer','Gilberto.Pfeffer@gmail.com','2531343269',56,'M',244,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (370,'Norman','Pfeffer','Norman.Mante46@hotmail.com','2115198536',55,'M',244,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (371,'Karen','Wintheiser','Karen_Wintheiser91@gmail.com','9679794329',53,'F',245,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (372,'Howard','Wintheiser','Howard21@gmail.com','3720397442',62,'M',245,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (373,'John','Wintheiser','John95@yahoo.com','7856863841',7,'M',245,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (374,'Anne','Schroeder','Anne78@hotmail.com','6147301761',55,'M',246,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (375,'Audrey','Kohler','Audrey_Kohler@yahoo.com','1025161269',9,'F',247,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (376,'Donnie','Kohler','Donnie.Lowe@gmail.com','9431723728',38,'M',247,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (377,'Linda','Kohler','Linda_Kunde@gmail.com','3115645315',70,'F',247,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (378,'Andrew','Leannon','Andrew_Leannon@gmail.com','1308608494',19,'M',248,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (379,'Teresa','Kling','Teresa.Kling45@hotmail.com','8329288895',50,'M',249,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (380,'Alexandra','Moen','Alexandra76@hotmail.com','4111467271',4,'M',250,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (1,'Karen','Wintheiser','Karen_Wintheiser91@gmail.com','9679794329',13,'M',1,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (2,'Noel','Wintheiser','Noel.Block@hotmail.com','6099088596',16,'M',1,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (3,'Marie','Wintheiser','Marie40@hotmail.com','9753760679',53,'F',1,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (4,'Angie','Hessel','Angie54@hotmail.com','3300355373',65,'F',2,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (5,'Andrew','Leannon','Andrew_Leannon@gmail.com','1308608494',16,'M',3,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (6,'Jerry','Hermann','Jerry46@hotmail.com','5162354426',56,'M',4,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (7,'Darla','Balistreri','Darla.Balistreri25@gmail.com','9077051489',34,'F',5,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (8,'Aubrey','Balistreri','Aubrey.Deckow@hotmail.com','1235320593',7,'M',5,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (9,'Beulah','Cruickshank','Beulah6@hotmail.com','1450149332',38,'M',6,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (10,'Shannon','Turcotte','Shannon23@yahoo.com','3606292461',50,'F',7,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (11,'Jackie','Runte','Jackie.Runte@hotmail.com','5165091524',33,'M',8,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (12,'Verna','Runte','Verna69@hotmail.com','7316873257',15,'F',8,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (13,'Maria','Rolfson','Maria_Rolfson91@gmail.com','7339062790',55,'F',9,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (14,'Eileen','Rolfson','Eileen.Cruickshank66@hotmail.com','4598748061',59,'F',9,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (15,'Mary','Rolfson','Mary4@gmail.com','6656274631',57,'F',9,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (16,'Santiago','Rippin','Santiago.Rippin89@yahoo.com','4155178945',8,'M',10,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (17,'Heather','Rippin','Heather.Cassin@gmail.com','7921311531',47,'F',10,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (18,'Jason','Rippin','Jason_Botsford@yahoo.com','9495262563',66,'M',10,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (19,'Alexandra','Moen','Alexandra76@hotmail.com','4111467271',56,'F',11,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (20,'Audrey','Moen','Audrey.DAmore@gmail.com','9449445789',34,'F',11,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (21,'Darla','Balistreri','Darla.Balistreri25@gmail.com','9077051489',12,'F',12,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (22,'Keith','Purdy','Keith.Purdy@gmail.com','7086201608',4,'M',13,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (23,'Alexandra','Moen','Alexandra76@hotmail.com','4111467271',14,'M',14,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (24,'Sheila','Moen','Sheila.Rutherford98@gmail.com','3922690402',5,'F',14,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (25,'Jacob','Bosco','Jacob_Bosco82@yahoo.com','1243021907',16,'F',15,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (26,'Johanna','Bosco','Johanna_Farrell@hotmail.com','9371263588',57,'F',15,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (27,'Elmer','Bosco','Elmer61@gmail.com','8238067546',52,'M',15,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (28,'Bob','Miller','Bob18@hotmail.com','5947299265',4,'F',16,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (29,'Gilberto','Pfeffer','Gilberto.Pfeffer@gmail.com','2531343269',35,'M',17,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (30,'Yolanda','Pfeffer','Yolanda34@yahoo.com','5294381781',21,'F',17,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (31,'Brad','Pfeffer','Brad_Schamberger@hotmail.com','5915846181',43,'M',17,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (32,'Beulah','Cruickshank','Beulah6@hotmail.com','1450149332',52,'F',18,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (33,'Genevieve','Parker','Genevieve_Parker@yahoo.com','8900435771',51,'F',19,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (34,'Alma','Parker','Alma.Schultz82@hotmail.com','5652838632',45,'F',19,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (35,'Janie','Parker','Janie.Hermann16@hotmail.com','5416622301',68,'F',19,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (36,'Genevieve','Parker','Genevieve_Parker@yahoo.com','8900435771',57,'M',20,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (37,'Jacob','Bosco','Jacob_Bosco82@yahoo.com','1243021907',56,'M',21,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (38,'Andrew','Leannon','Andrew_Leannon@gmail.com','1308608494',4,'F',22,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (39,'Audrey','Kohler','Audrey_Kohler@yahoo.com','1025161269',34,'M',23,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (40,'Patty','Kohler','Patty64@hotmail.com','4745959866',7,'F',23,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (41,'Antoinette','Kohler','Antoinette.Stanton@gmail.com','2589086874',27,'F',23,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (42,'Jackie','Runte','Jackie.Runte@hotmail.com','5165091524',66,'M',24,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (43,'Angie','Hessel','Angie54@hotmail.com','3300355373',22,'F',25,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (44,'Beulah','Cruickshank','Beulah6@hotmail.com','1450149332',37,'M',26,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (45,'Alexandra','Moen','Alexandra76@hotmail.com','4111467271',23,'F',27,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (46,'Teresa','Kling','Teresa.Kling45@hotmail.com','8329288895',16,'F',28,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (47,'Mabel','Kling','Mabel61@hotmail.com','3669976772',1,'F',28,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (48,'Lonnie','Kling','Lonnie.Kshlerin@gmail.com','8083756390',5,'M',28,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (49,'Maria','Rolfson','Maria_Rolfson91@gmail.com','7339062790',67,'M',29,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (50,'Jacob','Bosco','Jacob_Bosco82@yahoo.com','1243021907',41,'F',30,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (51,'Ruben','Okuneva','Ruben.Okuneva34@hotmail.com','6849079568',45,'M',31,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (52,'Maria','Rolfson','Maria_Rolfson91@gmail.com','7339062790',52,'M',32,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (53,'Monique','Rolfson','Monique_OReilly90@hotmail.com','7539922522',25,'F',32,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (54,'Santiago','Rippin','Santiago.Rippin89@yahoo.com','4155178945',65,'F',33,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (55,'Gilberto','Pfeffer','Gilberto.Pfeffer@gmail.com','2531343269',12,'F',34,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (56,'Maria','Rolfson','Maria_Rolfson91@gmail.com','7339062790',7,'M',35,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (57,'Sheri','Rolfson','Sheri_Renner@yahoo.com','3341292472',8,'F',35,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (58,'Genevieve','Parker','Genevieve_Parker@yahoo.com','8900435771',64,'F',36,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (59,'Dan','Parker','Dan.Sauer7@hotmail.com','8734658606',49,'M',36,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (60,'Ruben','Okuneva','Ruben.Okuneva34@hotmail.com','6849079568',40,'M',37,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (61,'Keith','Purdy','Keith.Purdy@gmail.com','7086201608',58,'F',38,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (62,'Joshua','Purdy','Joshua.Schiller@hotmail.com','5124128385',70,'M',38,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (63,'Arnold','Purdy','Arnold28@yahoo.com','1359347885',29,'M',38,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (64,'Audrey','Kohler','Audrey_Kohler@yahoo.com','1025161269',50,'F',39,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (65,'Ruben','Okuneva','Ruben.Okuneva34@hotmail.com','6849079568',63,'M',40,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (66,'Jackie','Runte','Jackie.Runte@hotmail.com','5165091524',40,'M',41,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (67,'John','Runte','John13@gmail.com','4862421050',68,'M',41,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (68,'Shelia','Koepp','Shelia74@gmail.com','3150575514',45,'M',42,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (69,'Jerry','Hermann','Jerry46@hotmail.com','5162354426',6,'M',43,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (70,'Santiago','Rippin','Santiago.Rippin89@yahoo.com','4155178945',12,'F',44,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (71,'Keith','Purdy','Keith.Purdy@gmail.com','7086201608',66,'F',45,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (72,'Alexandra','Moen','Alexandra76@hotmail.com','4111467271',20,'M',46,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (73,'Mildred','Moen','Mildred_OConnell@yahoo.com','9563866794',34,'F',46,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (74,'Allison','Moen','Allison.Lind@gmail.com','9827007656',26,'F',46,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (75,'Karen','Wintheiser','Karen_Wintheiser91@gmail.com','9679794329',19,'M',47,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (76,'Fredrick','Kuhic','Fredrick97@gmail.com','9851698275',66,'M',48,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (77,'Shannon','Turcotte','Shannon23@yahoo.com','3606292461',62,'M',49,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (78,'Jacob','Bosco','Jacob_Bosco82@yahoo.com','1243021907',65,'M',50,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (79,'Erma','Mills','Erma99@hotmail.com','3205588765',31,'M',51,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (80,'Gilberto','Pfeffer','Gilberto.Pfeffer@gmail.com','2531343269',8,'M',52,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (81,'Genevieve','Parker','Genevieve_Parker@yahoo.com','8900435771',6,'F',53,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (82,'Kenny','Parker','Kenny45@hotmail.com','8201347791',29,'M',53,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (83,'Beulah','Cruickshank','Beulah6@hotmail.com','1450149332',23,'F',54,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (84,'Ralph','Cruickshank','Ralph_Murray60@hotmail.com','2828032864',32,'M',54,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (85,'Angie','Hessel','Angie54@hotmail.com','3300355373',18,'M',55,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (86,'Carroll','Murphy','Carroll_Murphy62@gmail.com','7636236121',27,'M',56,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (87,'Alexandra','Moen','Alexandra76@hotmail.com','4111467271',15,'F',57,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (88,'Darla','Balistreri','Darla.Balistreri25@gmail.com','9077051489',7,'F',58,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (89,'Fredrick','Kuhic','Fredrick97@gmail.com','9851698275',7,'F',59,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (90,'Alexandra','Moen','Alexandra76@hotmail.com','4111467271',55,'F',60,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (91,'Bob','Miller','Bob18@hotmail.com','5947299265',37,'F',61,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (92,'Maria','Rolfson','Maria_Rolfson91@gmail.com','7339062790',41,'F',62,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (93,'Karen','Wintheiser','Karen_Wintheiser91@gmail.com','9679794329',15,'M',63,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (94,'Audrey','Kohler','Audrey_Kohler@yahoo.com','1025161269',65,'F',64,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (95,'Cristina','Kohler','Cristina.Kautzer63@gmail.com','5355066587',7,'F',64,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (96,'Devin','Kohler','Devin.Bechtelar@gmail.com','5259004677',62,'M',64,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (97,'Maria','Rolfson','Maria_Rolfson91@gmail.com','7339062790',65,'M',65,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (98,'Jerry','Hermann','Jerry46@hotmail.com','5162354426',10,'M',66,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (99,'Angie','Hessel','Angie54@hotmail.com','3300355373',29,'M',67,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (100,'Bradford','Stiedemann','Bradford39@gmail.com','7668861386',5,'M',68,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (101,'Ruben','Okuneva','Ruben.Okuneva34@hotmail.com','6849079568',41,'M',69,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (102,'Teresa','Kling','Teresa.Kling45@hotmail.com','8329288895',14,'M',70,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (103,'Elias','Kling','Elias.Watsica35@gmail.com','6287434123',50,'M',70,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (104,'Audrey','Kohler','Audrey_Kohler@yahoo.com','1025161269',37,'F',71,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (105,'Beulah','Cruickshank','Beulah6@hotmail.com','1450149332',18,'M',72,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (106,'Charlotte','Cruickshank','Charlotte.Huel@yahoo.com','9505678826',12,'F',72,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (107,'Warren','Cruickshank','Warren.Metz@hotmail.com','9279859269',41,'M',72,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (108,'Darla','Balistreri','Darla.Balistreri25@gmail.com','9077051489',67,'F',73,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (109,'Shannon','Turcotte','Shannon23@yahoo.com','3606292461',62,'M',74,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (110,'Paula','Turcotte','Paula25@yahoo.com','8788168673',10,'F',74,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (111,'Santiago','Rippin','Santiago.Rippin89@yahoo.com','4155178945',65,'F',75,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (112,'Margaret','Rippin','Margaret.Deckow@gmail.com','8269997413',27,'F',75,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (113,'Angie','Hessel','Angie54@hotmail.com','3300355373',43,'M',76,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (114,'Bernice','Hessel','Bernice_Lockman14@hotmail.com','7811462307',45,'F',76,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (115,'Audrey','Kohler','Audrey_Kohler@yahoo.com','1025161269',35,'F',77,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (116,'Paula','Kohler','Paula.Pfeffer3@gmail.com','8454553040',46,'F',77,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (117,'Jaime','Kohler','Jaime_Cartwright86@yahoo.com','2529130952',36,'F',77,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (118,'Audrey','Kohler','Audrey_Kohler@yahoo.com','1025161269',51,'M',78,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (119,'Courtney','Kohler','Courtney53@gmail.com','1376611450',63,'F',78,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (120,'Alfonso','Kohler','Alfonso_Schultz58@yahoo.com','4633093456',67,'M',78,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (121,'Audrey','Kohler','Audrey_Kohler@yahoo.com','1025161269',2,'F',79,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (122,'Maria','Rolfson','Maria_Rolfson91@gmail.com','7339062790',8,'F',80,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (123,'Santiago','Rippin','Santiago.Rippin89@yahoo.com','4155178945',23,'F',81,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (124,'Bob','Miller','Bob18@hotmail.com','5947299265',45,'M',82,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (125,'Tabitha','Miller','Tabitha.Marvin77@yahoo.com','5585425006',63,'F',82,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (126,'Doris','Miller','Doris56@gmail.com','3024584306',6,'F',82,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (127,'Shannon','Turcotte','Shannon23@yahoo.com','3606292461',7,'M',83,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (128,'Kristy','Turcotte','Kristy.Hills@yahoo.com','5482458462',2,'F',83,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (129,'Bradford','Stiedemann','Bradford39@gmail.com','7668861386',35,'F',84,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (130,'Fredrick','Kuhic','Fredrick97@gmail.com','9851698275',13,'F',85,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (131,'Cary','Kuhic','Cary_Jacobs@hotmail.com','8582911746',64,'M',85,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (132,'Mitchell','Kuhic','Mitchell_Morissette62@gmail.com','4477184998',29,'M',85,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (133,'Angie','Hessel','Angie54@hotmail.com','3300355373',44,'F',86,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (134,'Shannon','Turcotte','Shannon23@yahoo.com','3606292461',18,'M',87,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (135,'Shelia','Koepp','Shelia74@gmail.com','3150575514',11,'M',88,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (136,'Alexandra','Moen','Alexandra76@hotmail.com','4111467271',69,'M',89,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (137,'Carroll','Murphy','Carroll_Murphy62@gmail.com','7636236121',53,'F',90,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (138,'Maria','Rolfson','Maria_Rolfson91@gmail.com','7339062790',61,'M',91,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (139,'Jerry','Hermann','Jerry46@hotmail.com','5162354426',8,'M',92,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (140,'Teresa','Kling','Teresa.Kling45@hotmail.com','8329288895',34,'M',93,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (141,'Anne','Schroeder','Anne78@hotmail.com','6147301761',23,'F',94,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (142,'Rene','Schroeder','Rene_Fritsch@hotmail.com','3636961931',53,'M',94,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (143,'Anita','Schroeder','Anita35@gmail.com','2290682000',35,'F',94,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (144,'Ruben','Okuneva','Ruben.Okuneva34@hotmail.com','6849079568',54,'M',95,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (145,'Teresa','Kling','Teresa.Kling45@hotmail.com','8329288895',37,'F',96,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (146,'Angie','Hessel','Angie54@hotmail.com','3300355373',36,'F',97,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (147,'Beulah','Cruickshank','Beulah6@hotmail.com','1450149332',29,'F',98,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (148,'Marco','Cruickshank','Marco_Osinski@hotmail.com','5967415853',60,'M',98,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (149,'Grace','Cruickshank','Grace_Huel@gmail.com','9211634119',30,'F',98,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (150,'Erma','Mills','Erma99@hotmail.com','3205588765',39,'M',99,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (151,'Beulah','Cruickshank','Beulah6@hotmail.com','1450149332',44,'F',100,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (152,'Sherman','Cruickshank','Sherman.Powlowski@gmail.com','7474558510',32,'M',100,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (153,'Elbert','Cruickshank','Elbert_Jones@hotmail.com','3268931606',33,'M',100,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (154,'Angie','Hessel','Angie54@hotmail.com','3300355373',68,'M',101,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (155,'Bob','Miller','Bob18@hotmail.com','5947299265',16,'F',102,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (156,'Bradford','Stiedemann','Bradford39@gmail.com','7668861386',68,'M',103,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (157,'Terry','Stiedemann','Terry96@yahoo.com','7425685051',7,'F',103,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (158,'Tom','Stiedemann','Tom.Heidenreich58@yahoo.com','8371344980',48,'M',103,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (159,'Beulah','Cruickshank','Beulah6@hotmail.com','1450149332',68,'M',104,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (160,'Angie','Hessel','Angie54@hotmail.com','3300355373',46,'M',105,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (161,'Kelly','Hessel','Kelly29@gmail.com','6650518195',28,'F',105,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (162,'Erma','Mills','Erma99@hotmail.com','3205588765',26,'F',106,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (163,'Edmond','Mills','Edmond.Muller@yahoo.com','3418599084',7,'M',106,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (164,'Erma','Mills','Erma99@hotmail.com','3205588765',49,'F',107,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (165,'Carroll','Murphy','Carroll_Murphy62@gmail.com','7636236121',12,'F',108,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (166,'Jackie','Runte','Jackie.Runte@hotmail.com','5165091524',1,'F',109,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (167,'Keith','Purdy','Keith.Purdy@gmail.com','7086201608',67,'F',110,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (168,'Diane','Purdy','Diane_Morar@yahoo.com','4904380287',67,'F',110,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (169,'Mathew','Purdy','Mathew_Waelchi9@hotmail.com','3647455968',45,'M',110,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (170,'Karen','Wintheiser','Karen_Wintheiser91@gmail.com','9679794329',31,'M',111,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (171,'Shelia','Koepp','Shelia74@gmail.com','3150575514',60,'M',112,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (172,'Shelia','Koepp','Shelia74@gmail.com','3150575514',48,'F',113,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (173,'Carroll','Murphy','Carroll_Murphy62@gmail.com','7636236121',11,'F',114,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (174,'Roberta','Murphy','Roberta.Kulas51@yahoo.com','7485572151',69,'F',114,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (175,'Santiago','Murphy','Santiago75@hotmail.com','8160247661',37,'M',114,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (176,'Maria','Rolfson','Maria_Rolfson91@gmail.com','7339062790',61,'M',115,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (177,'Mike','Rolfson','Mike.Block74@yahoo.com','4552013288',26,'M',115,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (178,'Jimmy','Rolfson','Jimmy61@yahoo.com','9878530028',17,'M',115,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (179,'Audrey','Kohler','Audrey_Kohler@yahoo.com','1025161269',68,'F',116,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (180,'Darla','Balistreri','Darla.Balistreri25@gmail.com','9077051489',65,'M',117,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (181,'Shelia','Koepp','Shelia74@gmail.com','3150575514',1,'F',118,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (182,'Fernando','Koepp','Fernando.Donnelly@gmail.com','1137808297',39,'M',118,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (183,'Genevieve','Parker','Genevieve_Parker@yahoo.com','8900435771',59,'F',119,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (184,'Teresa','Kling','Teresa.Kling45@hotmail.com','8329288895',12,'F',120,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (185,'Omar','Kling','Omar91@gmail.com','2752727674',2,'M',120,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (186,'Teresa','Kling','Teresa.Kling45@hotmail.com','8329288895',35,'M',121,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (187,'Bob','Miller','Bob18@hotmail.com','5947299265',4,'M',122,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (188,'Lee','Miller','Lee_Kuphal@hotmail.com','8444993223',41,'M',122,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (189,'Andrew','Leannon','Andrew_Leannon@gmail.com','1308608494',34,'M',123,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (190,'Beulah','Cruickshank','Beulah6@hotmail.com','1450149332',44,'M',124,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (191,'Annette','Cruickshank','Annette_Ziemann@hotmail.com','9136750959',35,'F',124,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (192,'Willard','Cruickshank','Willard.Ziemann@hotmail.com','6822575000',48,'M',124,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (193,'Ruben','Okuneva','Ruben.Okuneva34@hotmail.com','6849079568',13,'F',125,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (194,'Nicholas','Okuneva','Nicholas_Price25@gmail.com','9907230391',24,'M',125,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (195,'Fredrick','Kuhic','Fredrick97@gmail.com','9851698275',56,'M',126,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (196,'Diana','Kuhic','Diana42@yahoo.com','5758775878',20,'F',126,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (197,'Donnie','Kuhic','Donnie_Doyle10@hotmail.com','2511456856',30,'M',126,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (198,'Karen','Wintheiser','Karen_Wintheiser91@gmail.com','9679794329',48,'M',127,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (199,'Ruben','Okuneva','Ruben.Okuneva34@hotmail.com','6849079568',28,'M',128,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (200,'Salvador','Okuneva','Salvador.Effertz95@hotmail.com','6222689528',13,'M',128,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (201,'Alma','Okuneva','Alma_Dickinson@gmail.com','2120608316',10,'F',128,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (202,'Genevieve','Parker','Genevieve_Parker@yahoo.com','8900435771',1,'M',129,2);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (203,'Ruben','Okuneva','Ruben.Okuneva34@hotmail.com','6849079568',17,'M',130,1);
Insert into PASSENGER (PASSENGERID,FIRSTNAME,LASTNAME,EMAIL,PHONENO,AGE,GENDER,BOOKING_BOOKINGID,STATUS_STATUSID) values (204,'Audrey','Kohler','Audrey_Kohler@yahoo.com','1025161269',40,'F',131,1);

COMMIT;
-- -----------------------------------------------------
-- Top Flights Operational Today VIEW
-- -----------------------------------------------------
CREATE OR REPLACE VIEW TopFlightsOperationalToday AS
SELECT r.ROUTENO "ROUTE NO", src.AIRPORT_LONGNAME "SOURCE AIRPORT", src.CITY "SOURCE CITY", dest.AIRPORT_LONGNAME "DESTINATION AIRPORT", dest.CITY "DESTINATION CITY", r.DEPARTURETIME "DEPARTURE TIME", ft.TOTALNOOFSEATS - SEATSAVAILABLE "No of Passengers"   FROM FLIGHT_SCHEDULES fs
INNER JOIN ROUTES r ON fs.ROUTES_ROUTEID = r.ROUTEID
INNER JOIN AIRPORTS src ON r.SOURCEAIRPORT = src.AIRPORTS_ID
INNER JOIN AIRPORTS dest ON r.DESTINATIONAIRPORT = dest.AIRPORTS_ID
INNER JOIN FLIGHT_TYPE ft ON r.FlightType_FlightTypeID = ft.FLIGHTTYPEID
WHERE fs.DATEOFTRAVEL=TRUNC(sysdate)
ORDER BY SEATSAVAILABLE ASC FETCH FIRST 10 ROWS WITH TIES;

-- -----------------------------------------------------
-- PromotionsView VIEW
-- -----------------------------------------------------
CREATE OR REPLACE VIEW PromotionsView AS
SELECT p.PROMOTIONID "PROMOTION ID", p.PROMOTIONNAME "PROMOTION NAME", p.PROMOTIONDESC "PROMOTION DESCRIPTION", COUNT(*) "No. of Times Used" FROM BOOKING b
INNER JOIN PROMOTION p ON b.PROMOTION_PROMOTIONID= p.PROMOTIONID
GROUP BY (p.PROMOTIONID, p.PROMOTIONNAME, p.PROMOTIONDESC);

------------------------------------------------------------
-- Passengers traveling today VIEW
------------------------------------------------------------
create or replace view Passenger_Travelling_Today as
select * from passenger where BOOKING_BOOKINGID in 
(select BOOKINGID from booking where FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID = 
(select FLIGHT_SCHEDULE_ID from flight_schedules where dateoftravel = 
(select to_char(to_date(sysdate)) from dual))) AND STATUS_STATUSID=1 ;


------------------------------------------------------------
-- Number of passengers traveling per quarter VIEW
------------------------------------------------------------
create or replace view Passengers_travelling_per_quarter as
SELECT COUNT(*) "No of Passengers", QUARTER FROM
(SELECT 'Quarter ' || to_char(fs.DATEOFTRAVEL, 'Q') QUARTER FROM PASSENGER p
INNER JOIN BOOKING b ON p.BOOKING_BOOKINGID = b.BOOKINGID
INNER JOIN FLIGHT_SCHEDULES fs on fs.FLIGHT_SCHEDULE_ID = b.FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID
WHERE EXTRACT(YEAR FROM DATEOFTRAVEL)= EXTRACT(YEAR FROM sysdate) AND p.STATUS_STATUSID=1)
GROUP BY QUARTER;

------------------------------------------------------------
-- Seat Distribution VIEW
------------------------------------------------------------
CREATE OR REPLACE VIEW SeatDistribution as 
Select f.FLIGHTNAME "FLIGHT TYPE", s.SEATTYPENAME "SEAT TYPE",  fs.NOOFSEATS "Number of Seats" from FLIGHT_TYPE  f
inner join FLIGHT_SEAT_AVAILABILITY  fs on 
f.FLIGHTTYPEID = fs.FLIGHTTYPE_FLIGHTTYPEID
inner join SEAT_TYPE s on
s.SEATTYPEID = fs.SEAT_TYPE_SEATTYPEID;

------------------------------------------------------------
-- Flights Operational Today VIEW
------------------------------------------------------------
CREATE OR REPLACE VIEW FlightsOperationalToday AS
SELECT r.ROUTENO "ROUTE NO", src.AIRPORT_LONGNAME "SOURCE AIRPORT", src.CITY "SOURCE CITY", dest.AIRPORT_LONGNAME "DESTINATION AIRPORT", dest.CITY "DESTINATION CITY", r.DEPARTURETIME "DEPARTURE TIME"
FROM FLIGHT_SCHEDULES fs
INNER JOIN ROUTES r ON fs.ROUTES_ROUTEID = r.ROUTEID
INNER JOIN AIRPORTS src ON r.SOURCEAIRPORT = src.AIRPORTS_ID
INNER JOIN AIRPORTS dest ON r.DESTINATIONAIRPORT = dest.AIRPORTS_ID
WHERE TRUNC(DateOfTravel) = TRUNC(SYSDATE);

------------------------------------------------------------
-- Top Routes with Vacant Seats VIEW
------------------------------------------------------------
CREATE OR REPLACE VIEW TopRouteswithVacantSeats AS
SELECT r.ROUTENO, fs.SEATSAVAILABLE, ft.TOTALNOOFSEATS, fs.DATEOFTRAVEL
FROM ROUTES r
INNER JOIN FLIGHT_TYPE ft ON r.FlightType_FlightTypeID = ft.FLIGHTTYPEID
INNER JOIN FLIGHT_SCHEDULES fs ON r.ROUTEID = fs.ROUTES_ROUTEID
WHERE fs.SEATSAVAILABLE / ft.TOTALNOOFSEATS > 0.5
ORDER BY (fs.SEATSAVAILABLE / ft.TOTALNOOFSEATS) DESC FETCH FIRST 10 ROWS WITH TIES;

------------------------------------------------------------
-- Passenger Traffic by Source State VIEW
------------------------------------------------------------
CREATE or replace VIEW passenger_traffic_by_source_state AS
WITH temp AS(
SELECT a.state,p.passengerid
FROM airports a
join routes r on a.airports_id = r.sourceairport
join flight_schedules f on r.routeid = f.routes_routeid
join booking b on f.flight_schedule_id = b.flight_schedules_flight_schedule_id
join passenger p on b.bookingid = p.booking_bookingid
)
SELECT state, count(passengerid) "Passenger Count" FROM temp group by state order by "Passenger Count" DESC FETCH FIRST 10 ROWS WITH TIES;

------------------------------------------------------------
-- Passenger Traffic by Destination State VIEW
------------------------------------------------------------
CREATE or replace VIEW passenger_traffic_by_destination_state AS
WITH temp AS(
SELECT a.state,p.passengerid
FROM airports a
join routes r on a.airports_id = r.destinationairport
join flight_schedules f on r.routeid = f.routes_routeid
join booking b on f.flight_schedule_id = b.flight_schedules_flight_schedule_id
join passenger p on b.bookingid = p.booking_bookingid
)
SELECT state, count(passengerid) "Passenger Count" FROM temp group by state order by "Passenger Count" DESC FETCH FIRST 10 ROWS WITH TIES;

-- ------------------------------------------------------------
-- Frequent Users VIEW
------------------------------------------------------------
create or replace view Frequent_Users as
Select b.Customer_ID "CUSTOMER ID", COUNT(b.BOOKINGID) "No. of Bookings Made", C.FirstName "FIRST NAME", C.LastName "LAST NAME" FROM CUSTOMER C
INNER JOIN BOOKING b ON c.CustomerID = b.CUSTOMER_ID
GROUP BY (b.Customer_ID, C.FirstName, C.LastName)
ORDER BY Count(b.BOOKINGID) DESC FETCH FIRST 10 ROWS WITH TIES;

------------------------------------------------------------
-- Top Routes in a Year VIEW
------------------------------------------------------------

create or replace view Top_Routes_This_Year as
Select COUNT(*) "No. of Passengers travelled in past Year", r.RouteNo "Route No.", src.Airport_LongName "Source", dst.Airport_LongName "Destination" FROM BOOKING b
INNER JOIN PASSENGER p ON p.BOOKING_BOOKINGID = b.BOOKINGID
INNER JOIN FLIGHT_SCHEDULES fs ON b.FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID = fs.FLIGHT_SCHEDULE_ID
INNER JOIN ROUTES r ON r.RouteID = fs.ROUTES_RouteID
INNER JOIN AIRPORTS src ON src.Airports_ID = r.SourceAirport
INNER JOIN AIRPORTS dst ON dst.Airports_ID = r.DestinationAirport
WHERE fs.DateOfTravel <= SYSDATE AND fs.DateOfTravel >= ADD_MONTHS(SYSDATE, -12)
GROUP BY (r.RouteNo, r.SourceAirport, r.DestinationAirport, src.Airport_LongName, dst.Airport_LongName)
ORDER BY Count(*) DESC FETCH FIRST 10 ROWS WITH TIES;

------------------------------------------------------------
-- Top Routes in a Month VIEW
------------------------------------------------------------

create or replace view Top_Routes_This_Month as
Select COUNT(*) "No. of Passengers travelled in past 30 days" , r.RouteNo "Route No.", src.Airport_LongName "Source", dst.Airport_LongName "Destination" FROM BOOKING b
INNER JOIN PASSENGER p ON p.BOOKING_BOOKINGID = b.BOOKINGID
INNER JOIN FLIGHT_SCHEDULES fs ON b.FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID = fs.FLIGHT_SCHEDULE_ID
INNER JOIN ROUTES r ON r.RouteID = fs.ROUTES_RouteID
INNER JOIN AIRPORTS src ON src.Airports_ID = r.SourceAirport
INNER JOIN AIRPORTS dst ON dst.Airports_ID = r.DestinationAirport
WHERE fs.DateOfTravel <= SYSDATE AND fs.DateOfTravel >= ADD_MONTHS(SYSDATE, -1)
GROUP BY (r.RouteNo, r.SourceAirport, r.DestinationAirport, src.Airport_LongName, dst.Airport_LongName)
ORDER BY Count(*) DESC FETCH FIRST 10 ROWS WITH TIES;

------------------------------------------------------------
-- Top Routes in a Day VIEW
------------------------------------------------------------

create or replace view Top_Routes_Today as
Select COUNT(*) "No. of Passengers Today", r.RouteNo "Route No.", src.Airport_LongName "Source", dst.Airport_LongName "Destination" FROM BOOKING b
INNER JOIN PASSENGER p ON p.BOOKING_BOOKINGID = b.BOOKINGID
INNER JOIN FLIGHT_SCHEDULES fs ON b.FLIGHT_SCHEDULES_FLIGHT_SCHEDULE_ID = fs.FLIGHT_SCHEDULE_ID
INNER JOIN ROUTES r ON r.RouteID = fs.ROUTES_RouteID
INNER JOIN AIRPORTS src ON src.Airports_ID = r.SourceAirport
INNER JOIN AIRPORTS dst ON dst.Airports_ID = r.DestinationAirport
WHERE fs.DateOfTravel = TRUNC(SYSDATE)
GROUP BY (r.RouteNo, r.SourceAirport, r.DestinationAirport, src.Airport_LongName, dst.Airport_LongName)
ORDER BY Count(*) DESC FETCH FIRST 10 ROWS WITH TIES;