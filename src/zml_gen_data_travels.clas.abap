CLASS zml_gen_data_travels DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zml_gen_data_travels IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA it_travel TYPE TABLE OF zml_travel.
    DATA it_booking TYPE TABLE OF zml_booking.

    DATA lv_long_time_stamp TYPE timestampl.
    GET TIME STAMP FIELD lv_long_time_stamp.
    DATA: l_uuid_x16 TYPE sysuuid_x16.
    DATA: system_uuid TYPE REF TO if_system_uuid.
    DATA: oref        TYPE REF TO cx_uuid_error.
    system_uuid = cl_uuid_factory=>create_system_uuid( ).

    TRY.

        it_travel =  VALUE #(
          ( client = sy-mandt travel_id = system_uuid->create_uuid_x16( ) name = 'Travel Minsk - Dubai' )
          ( client = sy-mandt travel_id = system_uuid->create_uuid_x16( ) name = 'Travel Minsk - Moscow' )
          ( client = sy-mandt travel_id = system_uuid->create_uuid_x16( ) name = 'Travel Minsk - Warsaw' )
          ( client = sy-mandt travel_id = system_uuid->create_uuid_x16( ) name = 'Travel Minsk - Dushanbe' )
          ( client = sy-mandt travel_id = system_uuid->create_uuid_x16( ) name = 'Travel Minsk - Batumi' )

        ).

        it_booking = VALUE #(
            ( client = sy-mandt booking_id = system_uuid->create_uuid_x16( ) travel_id = it_travel[ name = 'Travel Minsk - Dubai' ]-travel_id dayfrom = '20240101'  dayto = '20240104' hotel = 'Amirates Dubai' )
            ( client = sy-mandt booking_id = system_uuid->create_uuid_x16( ) travel_id = it_travel[ name = 'Travel Minsk - Moscow' ]-travel_id dayfrom = '20240105'  dayto = '20240107' hotel = 'Marriot' )
            ( client = sy-mandt booking_id = system_uuid->create_uuid_x16( ) travel_id = it_travel[ name = 'Travel Minsk - Warsaw' ]-travel_id dayfrom = '20240108'  dayto = '20240114' hotel = 'Outstanding WSW' )
            ( client = sy-mandt booking_id = system_uuid->create_uuid_x16( ) travel_id = it_travel[ name = 'Travel Minsk - Dushanbe' ]-travel_id dayfrom = '20240115'  dayto = '20240124' hotel = 'Marriot Hayat' )
            ( client = sy-mandt booking_id = system_uuid->create_uuid_x16( ) travel_id = it_travel[ name = 'Travel Minsk - Batumi' ]-travel_id dayfrom = '20240125'  dayto = '20240130' hotel = 'Amber Sea' )
        ).

        out->write( it_travel ).
        out->write( it_booking ).

*       delete existing entries in the database table
        DELETE FROM zml_booking.
        DELETE FROM zml_travel.


*       insert the new table entries
        INSERT zml_travel FROM TABLE @it_travel.
        INSERT zml_booking FROM TABLE @it_booking.

        out->write( |Demo data generated for tables...| ).

      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.



  ENDMETHOD.

ENDCLASS.
