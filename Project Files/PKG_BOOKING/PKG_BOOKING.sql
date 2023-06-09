CREATE OR REPLACE PACKAGE pkg_booking AS
    TYPE passenger_array IS
        TABLE OF passenger%rowtype INDEX BY BINARY_INTEGER;
    PROCEDURE passenger_cancel (
        input_passenger_id passenger.passengerid%TYPE,
        bool_commit        BOOLEAN
    );

    PROCEDURE booking_cancel (
        input_booking_id booking.bookingid%TYPE
    );

    PROCEDURE booking_with_passengers (
        input_booking         booking%rowtype,
        input_passenger_array passenger_array
    );

    invalid_data EXCEPTION;
    insufficient_seats EXCEPTION;
    invalid_dateoftravel EXCEPTION;
END pkg_booking;
/

CREATE OR REPLACE PACKAGE BODY pkg_booking AS

/*    
 *** booking_add *** /
*/
    PROCEDURE booking_add (
        input_customerid  booking.customer_id%TYPE,
        input_promotionid booking.promotion_promotionid%TYPE,
        input_stid        booking.seat_type_seattypeid%TYPE,
        input_fsid        booking.flight_schedules_flight_schedule_id%TYPE,
        booking_id        OUT booking.bookingid%TYPE
    ) AS

        cntcustomer NUMBER;
        cntfs       NUMBER;
        cntpromo    NUMBER;
        cntst       NUMBER;
        fs_date     DATE;
        fs_rec      flight_schedules%rowtype;
        pnr         booking.pnr%TYPE;
    BEGIN
    
        -- CHECKING IF VALID CUSTOMER
        SELECT
            COUNT(*)
        INTO cntcustomer
        FROM
            customer
        WHERE
            customerid = input_customerid;

        -- CHECKING IF VALID FLIGHT SCHEDULE
        SELECT
            COUNT(*)
        INTO cntfs
        FROM
            flight_schedules
        WHERE
            flight_schedule_id = input_fsid;

        -- CHECKING IF VALID PROMOTION
        SELECT
            COUNT(*)
        INTO cntpromo
        FROM
            promotion
        WHERE
                promotionid = input_promotionid
            AND active = 'Y';

        -- CHECKING IF VALID SEAT TYPE
        SELECT
            COUNT(*)
        INTO cntst
        FROM
            seat_type
        WHERE
            seattypeid = input_stid;

        IF cntcustomer = 0 THEN
            dbms_output.put_line('ERROR : NO CUSTOMER EXISTS FOR GIVEN ID');
            RAISE invalid_data;
        ELSIF cntfs = 0 THEN
            dbms_output.put_line('ERROR : NO FLIGHT EXISTS FOR GIVEN ID');
            RAISE invalid_data;
        ELSIF cntpromo = 0 THEN
            dbms_output.put_line('ERROR : NO ACTIVE PROMOTION EXISTS FOR GIVEN ID');
            RAISE invalid_data;
        ELSIF cntst = 0 THEN
            dbms_output.put_line('ERROR : NO SEAT TYPE EXISTS FOR GIVEN ID');
            RAISE invalid_data;
        ELSE
            SELECT
                *
            INTO fs_rec
            FROM
                flight_schedules
            WHERE
                flight_schedule_id = input_fsid;

            -- CHECKING IF ANY SEATS ARE AVAILABLE
            IF fs_rec.seatsavailable = 0 THEN
                RAISE insufficient_seats;
            END IF;
            SELECT
                dateoftravel
            INTO fs_date
            FROM
                flight_schedules
            WHERE
                flight_schedule_id = input_fsid;

            IF fs_date < sysdate THEN
                RAISE invalid_dateoftravel;
            END IF;
            pnr := dbms_random.string('U', 6);
            booking_id := seq_booking.nextval;
            INSERT INTO booking (
                bookingid,
                pnr,
                dateofbooking,
                customer_id,
                promotion_promotionid,
                seat_type_seattypeid,
                flight_schedules_flight_schedule_id
            ) VALUES (
                booking_id,
                pnr,
                sysdate,
                input_customerid,
                input_promotionid,
                input_stid,
                input_fsid
            );

--            COMMIT;
            dbms_output.put_line('BOOKING ADDED SUCCCESSFULLY WITH PNR ' || pnr || ' AND ID ' || booking_id);
        END IF;

    EXCEPTION
        WHEN invalid_data THEN
            dbms_output.put_line('INVALID DATA ENTERED');
            RAISE;
        WHEN invalid_dateoftravel THEN
            dbms_output.put_line('INVALID Date of Travel ENTERED');
            RAISE;
        WHEN insufficient_seats THEN
            dbms_output.put_line('WE ARE SORRY. NO SEATS LEFT');
            RAISE;
        WHEN OTHERS THEN
            dbms_output.put_line(sqlerrm);
            RAISE;
    END;
/*    
 *** passenger_add *** /
*/
    PROCEDURE passenger_add (
        input_fn        passenger.firstname%TYPE,
        input_ln        passenger.lastname%TYPE,
        input_email     passenger.email%TYPE,
        input_phoneno   passenger.phoneno%TYPE,
        input_age       passenger.age%TYPE,
        input_gender    passenger.gender%TYPE,
        input_bookingid passenger.booking_bookingid%TYPE,
        input_statusid  passenger.status_statusid%TYPE
    ) AS

        cntbooking      NUMBER;
        cntstatus       NUMBER;
        seq_passengerid NUMBER;
        booking_rec     booking%rowtype;
        fs_rec          flight_schedules%rowtype;
        insufficient_seats EXCEPTION;
    BEGIN
        SELECT
            COUNT(*)
        INTO cntbooking
        FROM
            booking
        WHERE
            bookingid = input_bookingid;

        SELECT
            COUNT(*)
        INTO cntstatus
        FROM
            status
        WHERE
            statusid = input_statusid;

        IF cntbooking = 0 THEN
            dbms_output.put_line('ERROR : NO BOOKING EXISTS');
            RAISE invalid_data;
        ELSIF cntstatus = 0 THEN
            dbms_output.put_line('ERROR : NO STATUS EXISTS');
            RAISE invalid_data;
        ELSIF input_fn IS NULL OR length(input_fn) = 0 THEN
            dbms_output.put_line('ERROR : FIRSTNAME ERROR');
            RAISE invalid_data;
        ELSIF input_ln IS NULL OR length(input_ln) = 0 THEN
            dbms_output.put_line('ERROR : LASTNAME ERROR');
            RAISE invalid_data;
        ELSIF input_email IS NULL OR length(input_email) = 0 THEN
            dbms_output.put_line('ERROR : EMAIL ERROR');
            RAISE invalid_data;
        ELSIF input_phoneno IS NULL OR length(input_phoneno) = 0 THEN
            dbms_output.put_line('ERROR : PHONENO ERROR');
            RAISE invalid_data;
        ELSIF input_age IS NULL OR input_age < 0 THEN
            dbms_output.put_line('ERROR : AGE ERROR');
            RAISE invalid_data;
        ELSIF input_gender IS NULL OR length(input_gender) = 0 THEN
            dbms_output.put_line('ERROR : GENDER ERROR');
            RAISE invalid_data;
        ELSE
            -- verify seats exist
            -- get booking rec
            SELECT
                *
            INTO booking_rec
            FROM
                booking
            WHERE
                bookingid = input_bookingid;
                
-- get flight schedule rec
            SELECT
                *
            INTO fs_rec
            FROM
                flight_schedules
            WHERE
                flight_schedule_id = booking_rec.flight_schedules_flight_schedule_id;

            IF fs_rec.seatsavailable = 0 THEN
                RAISE insufficient_seats;
            ELSE
                seq_passengerid := seq_passenger.nextval;
                INSERT INTO passenger (
                    passengerid,
                    firstname,
                    lastname,
                    email,
                    phoneno,
                    age,
                    gender,
                    booking_bookingid,
                    status_statusid
                ) VALUES (
                    seq_passengerid,
                    input_fn,
                    input_ln,
                    input_email,
                    input_phoneno,
                    input_age,
                    input_gender,
                    input_bookingid,
                    input_statusid
                );

--                UPDATE flight_schedules
--                SET
--                    seatsavailable = seatsavailable - 1
--                WHERE
--                    flight_schedule_id = booking_rec.flight_schedules_flight_schedule_id;

--                COMMIT;
                dbms_output.put_line('PASSENGER ADDED SUCCCESSFULLY WITH ID ' || seq_passengerid);
            END IF;

        END IF;

    EXCEPTION
        WHEN invalid_data THEN
            dbms_output.put_line('INVALID DATA ENTERED');
            RAISE;
        WHEN insufficient_seats THEN
            dbms_output.put_line('WE ARE SORRY. NO SEATS LEFT');
            RAISE;
        WHEN OTHERS THEN
            dbms_output.put_line(sqlerrm);
            RAISE;
    END;
    
/*    
 *** get_number_of_seats_by_seat_type_flight *** /
*/
    FUNCTION get_no_available_seats_by_seat_type_flight (
        input_fs_id flight_schedules.flight_schedule_id%TYPE,
        input_st_id NUMBER
    ) RETURN NUMBER IS

        no_of_seats          NUMBER;
        rt_rec               routes%rowtype;
        ft_rec               flight_type%rowtype;
        fs_rec               flight_schedules%rowtype;
        no_of_seats_seattype NUMBER;
        no_of_seats_booked   NUMBER;
    BEGIN
        -- FETCH FLIGHT SCHEDULE RECORD
        SELECT
            *
        INTO fs_rec
        FROM
            flight_schedules
        WHERE
            flight_schedule_id = input_fs_id;
        -- FETCH ROUTE RECORD
        SELECT
            *
        INTO rt_rec
        FROM
            routes
        WHERE
            routeid = fs_rec.routes_routeid;
            -- FETCH FLIGHT TYPE RECORD
        SELECT
            *
        INTO ft_rec
        FROM
            flight_type
        WHERE
            flighttypeid = rt_rec.flighttype_flighttypeid;
            
            -- FETCH TOTAL NUMBER OF SEATS FOR SEAT TYPE
        SELECT
            noofseats
        INTO no_of_seats_seattype
        FROM
            flight_seat_availability
        WHERE
                flighttype_flighttypeid = ft_rec.flighttypeid
            AND seat_type_seattypeid = input_st_id;
            
            -- FETCH NO OF PASSENGERS/ BOOKED SEATS
        SELECT
            COUNT(*)
        INTO no_of_seats_booked
        FROM
            passenger
        WHERE
            booking_bookingid IN (
                SELECT
                    bookingid
                FROM
                    booking
                WHERE
                        flight_schedules_flight_schedule_id = input_fs_id
                    AND seat_type_seattypeid = input_st_id
            )
            AND status_statusid = 1;

        RETURN ( no_of_seats_seattype - no_of_seats_booked );
    END;
    

/*    
 *** booking_with_passengers *** /
*/
    PROCEDURE booking_with_passengers (
        input_booking         booking%rowtype,
        input_passenger_array passenger_array
    ) AS

        cntretry              NUMBER := 1;
        no_of_passengers      NUMBER;
        fs_rec                flight_schedules%rowtype;
        cnt_st_check          NUMBER;
        cnt_customer_check    NUMBER;
        cnt_fs_check          NUMBER;
        cnt_promo_check       NUMBER;
        fs_date               DATE;
        booking_id            NUMBER;
        availableseats_flag   NUMBER;
        maximum_retry_reached EXCEPTION;
    BEGIN
        dbms_output.put_line('*** START BOOKING WITH PASSENGERS ***');
        -- CHECKING IF VALID CUSTOMER
        SELECT
            COUNT(*)
        INTO cnt_customer_check
        FROM
            customer
        WHERE
            customerid = input_booking.customer_id;

        -- CHECKING IF VALID FLIGHT SCHEDULE
        SELECT
            COUNT(*)
        INTO cnt_fs_check
        FROM
            flight_schedules
        WHERE
            flight_schedule_id = input_booking.flight_schedules_flight_schedule_id;

        -- CHECKING IF VALID PROMOTION
        SELECT
            COUNT(*)
        INTO cnt_promo_check
        FROM
            promotion
        WHERE
                promotionid = input_booking.promotion_promotionid
            AND active = 'Y';

        -- CHECKING IF VALID SEAT TYPE
        SELECT
            COUNT(*)
        INTO cnt_st_check
        FROM
            seat_type
        WHERE
            seattypeid = input_booking.seat_type_seattypeid;
        
        -- CHECKING IF NO PASSENGERS ARE ADDED

        IF input_passenger_array IS NULL OR input_passenger_array.count = 0 THEN
            dbms_output.put_line('ERROR : NO PASSENGERS HAVE BEEN PASSED');
            RAISE invalid_data;
        ELSIF cnt_customer_check = 0 THEN
            dbms_output.put_line('ERROR : NO CUSTOMER EXISTS FOR GIVEN ID');
            RAISE invalid_data;
        ELSIF cnt_fs_check = 0 THEN
            dbms_output.put_line('ERROR : NO FLIGHT FOR GIVEN ID');
            RAISE invalid_data;
        ELSIF cnt_promo_check = 0 THEN
            dbms_output.put_line('ERROR : NO PROMOTION EXISTS FOR GIVEN ID');
            RAISE invalid_data;
        ELSIF cnt_st_check = 0 THEN
            dbms_output.put_line('ERROR : NO SEAT TYPE EXISTS FOR GIVEN ID');
            RAISE invalid_data;
        END IF;
        
        -- CHECKING IF FS DATE IS VALID AND ANY SEATS ARE AVAILBLE
        SELECT
            *
        INTO fs_rec
        FROM
            flight_schedules
        WHERE
            flight_schedule_id = input_booking.flight_schedules_flight_schedule_id;
        
            -- CHECKING IF FLIGHT DATE IS IN PAST
        IF fs_rec.dateoftravel < sysdate THEN
            dbms_output.put_line('ERROR : FLIGHT IS IN PAST');
            RAISE invalid_dateoftravel;
        END IF;

        IF fs_rec.seatsavailable = 0 OR fs_rec.seatsavailable < no_of_passengers THEN
            dbms_output.put_line('INFO : NO SEATS LEFT');
            RAISE insufficient_seats;
        END IF;

        LOOP
            no_of_passengers := input_passenger_array.count;
            SELECT
                *
            INTO fs_rec
            FROM
                flight_schedules
            WHERE
                flight_schedule_id = input_booking.flight_schedules_flight_schedule_id;

            availableseats_flag := fs_rec.seatsavailable;
        
            -- CHECKING IF SEATS FOR GIVEN SEAT TYPE ARE AVAILABLE           
            -- IF NO SEATS LEFT THEN RAISE EXCEPTION
            IF get_no_available_seats_by_seat_type_flight(input_booking.flight_schedules_flight_schedule_id, input_booking.seat_type_seattypeid
            ) < no_of_passengers THEN
                dbms_output.put_line('INFO : NO SEATS LEFT');
                RAISE insufficient_seats;
            END IF;
        
        -- INSERT INTO BOOKING TABLE
            BEGIN
                booking_add(input_booking.customer_id, input_booking.promotion_promotionid, input_booking.seat_type_seattypeid, input_booking.flight_schedules_flight_schedule_id
                , booking_id);

                dbms_output.put_line('BOOKING ID IS ' || booking_id);
            END;

            FOR i IN 1..input_passenger_array.count LOOP
                dbms_output.put_line('**START INSERT PASSENGER**');
                passenger_add(input_passenger_array(i).firstname, input_passenger_array(i).lastname, input_passenger_array(i).email, input_passenger_array
                (i).phoneno, input_passenger_array(i).age,
                             input_passenger_array(i).gender, booking_id, 1);

                dbms_output.put_line('**PASSENGER '
                                     || input_passenger_array(i).firstname
                                     || ' '
                                     || input_passenger_array(i).lastname
                                     || ' WAS ADDED **');

            END LOOP;

            SAVEPOINT retry_flight_update_savepoint;
            UPDATE flight_schedules
            SET
                seatsavailable = seatsavailable - no_of_passengers
            WHERE
                    flight_schedule_id = input_booking.flight_schedules_flight_schedule_id
                AND seatsavailable = availableseats_flag;
            
            -- IF CONCURRENT BOOKING IS DETECTED RETRY FOR SPECIFFIED NUMBER OF TIMES
            IF SQL%rowcount = 0 THEN
                dbms_output.put_line(' CONCURRENCY DETECTED. WILL RETRY TO BOOK');
                IF cntretry > 3 THEN
                    RAISE maximum_retry_reached;
                ELSE
                    cntretry := cntretry + 1;
                    SELECT
                        seatsavailable
                    INTO availableseats_flag
                    FROM
                        flight_schedules
                    WHERE
                        flight_schedule_id = input_booking.flight_schedules_flight_schedule_id;

                    IF availableseats_flag = 0 OR availableseats_flag < no_of_passengers THEN
                        dbms_output.put_line('INFO : NO SEATS LEFT');
                        RAISE insufficient_seats;
                    END IF;

                    IF get_no_available_seats_by_seat_type_flight(input_booking.flight_schedules_flight_schedule_id, input_booking.seat_type_seattypeid
                    ) < no_of_passengers THEN
                        dbms_output.put_line('INFO : NO SEATS LEFT');
                        RAISE insufficient_seats;
                    END IF;

                    ROLLBACK TO retry_flight_update_savepoint;
                END IF;

            ELSE
                COMMIT;
                EXIT;
            END IF;

            dbms_output.put_line(NULL);
        END LOOP;

    EXCEPTION
        WHEN invalid_data THEN
            dbms_output.put_line('INVALID DATA ENTERED. WE ARE ROLLING BACK YOUR TRANSACTION.');
            dbms_output.put_line(NULL);
            ROLLBACK;
        WHEN insufficient_seats THEN
            dbms_output.put_line('WE ARE SORRY. NO SEATS LEFT');
            dbms_output.put_line(NULL);
            ROLLBACK;
        WHEN invalid_dateoftravel THEN
            dbms_output.put_line('TRYING TO BOOK FOR PAST FLIGHT');
            dbms_output.put_line(NULL);
            ROLLBACK;
        WHEN maximum_retry_reached THEN
            dbms_output.put_line('MAXIMUM NO OF RETRIES HAVE BEEN REACHED. PLEASE TRY AGAIN');
            dbms_output.put_line(NULL);
            ROLLBACK;
        WHEN OTHERS THEN
            dbms_output.put_line(sqlerrm);
            dbms_output.put_line(NULL);
            ROLLBACK;
    END;
    
/*    
 *** PASSENGER_CANCEL *** /
*/
    PROCEDURE passenger_cancel (
        input_passenger_id passenger.passengerid%TYPE,
        bool_commit        BOOLEAN
    ) AS
        pass_rec       passenger%rowtype;
        book_rec       booking%rowtype;
        cnt_pass_check NUMBER;
        flight_rec     flight_schedules%rowtype;
    BEGIN
        SELECT
            COUNT(*)
        INTO cnt_pass_check
        FROM
            passenger
        WHERE
            passengerid = input_passenger_id;

        IF cnt_pass_check = 0 THEN
            dbms_output.put_line('ERROR : PASSENGER DOESN"T EXIST FOR THE GIVEN ID');
            RAISE invalid_data;
        END IF;
        
        -- FETCH PASSENGER
        SELECT
            *
        INTO pass_rec
        FROM
            passenger
        WHERE
            passengerid = input_passenger_id
        FOR UPDATE;
        -- FETCH BOOKING
        SELECT
            *
        INTO book_rec
        FROM
            booking
        WHERE
            bookingid = pass_rec.booking_bookingid;
        -- FETCH FLIGHT
        SELECT
            *
        INTO flight_rec
        FROM
            flight_schedules
        WHERE
            flight_schedule_id = book_rec.flight_schedules_flight_schedule_id
        FOR UPDATE;
        
        -- CHECK IF FLIGHT IS IN PAST
        IF flight_rec.dateoftravel < sysdate THEN
            dbms_output.put_line('ERROR : FLIGHT IS IN THE PAST');
            RAISE invalid_dateoftravel;
        END IF;
        
        -- UPDATE PASSENGER
        UPDATE passenger
        SET
            status_statusid = 2
        WHERE
            passengerid = pass_rec.passengerid;
        
        -- UPDATE FLIGHT SEAT AVAILABILITY
        UPDATE flight_schedules
        SET
            seatsavailable = seatsavailable + 1
        WHERE
            flight_schedule_id = flight_rec.flight_schedule_id;

        IF bool_commit THEN
            COMMIT;
        END IF;
    EXCEPTION
        WHEN invalid_data THEN
            dbms_output.put_line('INVALID DATA ENTERED. WE ARE ROLLING BACK YOUR TRANSACTION.');
            dbms_output.put_line(NULL);
            ROLLBACK;
        WHEN OTHERS THEN
            dbms_output.put_line(sqlerrm);
            dbms_output.put_line(NULL);
            ROLLBACK;
    END;
/*
 *** BOOKING CANCEL *** /
*/
    PROCEDURE booking_cancel (
        input_booking_id booking.bookingid%TYPE
    ) AS
        cnt_booking_check NUMBER;
        book_rec          booking%rowtype;
        flight_rec        flight_schedules%rowtype;
    BEGIN
        dbms_output.put_line('** START CANCELLATION OF BOOKING **');
        -- CHECKING IF BOOKING EXISTS
        SELECT
            COUNT(*)
        INTO cnt_booking_check
        FROM
            booking
        WHERE
            bookingid = input_booking_id;

        IF cnt_booking_check = 0 THEN
            dbms_output.put_line('ERROR : BOOKING DOESN"T EXIST FOR THE GIVEN ID');
            RAISE invalid_data;
        END IF;
        
        -- FETCH BOOKING
        SELECT
            *
        INTO book_rec
        FROM
            booking
        WHERE
            bookingid = input_booking_id;

        
         -- FETCH FLIGHT
        SELECT
            *
        INTO flight_rec
        FROM
            flight_schedules
        WHERE
            flight_schedule_id = book_rec.flight_schedules_flight_schedule_id;
            
        -- CHECK IF FLIGHT IS IN PAST
        IF flight_rec.dateoftravel < sysdate THEN
            dbms_output.put_line('ERROR : FLIGHT IS IN THE PAST');
            RAISE invalid_dateoftravel;
        END IF;
        
        -- FETCH PASSENGERS
        FOR p IN (
            SELECT
                *
            FROM
                passenger
            WHERE
                    booking_bookingid = input_booking_id
                AND status_statusid = 1
        ) LOOP
            dbms_output.put_line('** START CANCELLATION OF PASSENGER  '
                                 || p.firstname
                                 || ' '
                                 || p.lastname
                                 || ' **');

            passenger_cancel(p.passengerid, false);
        END LOOP;

        COMMIT;
    EXCEPTION
        WHEN invalid_data THEN
            dbms_output.put_line('INVALID DATA ENTERED. WE ARE ROLLING BACK YOUR TRANSACTION.');
            dbms_output.put_line(NULL);
            ROLLBACK;
        WHEN invalid_dateoftravel THEN
            dbms_output.put_line('TRYING TO CANCEL FOR PAST FLIGHT');
            dbms_output.put_line(NULL);
            ROLLBACK;
        WHEN OTHERS THEN
            dbms_output.put_line(sqlerrm);
            dbms_output.put_line(NULL);
            ROLLBACK;
    END;

END;
/