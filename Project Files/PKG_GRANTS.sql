/* 
    NOTE THIS SCRIPT SHOULD BE RUN ONLY AFTER THE CREATION OF PACKAGES ARE DONE.
    NOTE THIS SCRIPT SHOULD BE RUN ONLY AFTER THE USERS HAVE BEEN CREATED.
    THIS SCRIPT SHOULD BE RUN BY APP_ADMIN.
*/

GRANT EXECUTE ON pkg_booking TO customer;

GRANT EXECUTE ON pkg_customer TO customer;

GRANT EXECUTE ON pkg_airline TO airline_admin;