CLASS zcl_zml_travelling_odt_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zml_travelling_odt_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.


    METHODS /iwbep/if_mgw_appl_srv_runtime~create_deep_entity REDEFINITION.

  PROTECTED SECTION.
    methods zml_ibookingset_update_entity redefinition.
    methods zml_ibookingset_delete_entity redefinition.
    methods zml_ibookingset_create_entity redefinition.

    METHODS zml_create_uuid
      RETURNING VALUE(es_uuid) TYPE sysuuid_x16.

    METHODS zml_modify_travel
      IMPORTING
                !ls_entity       TYPE zcl_zml_travelling_odt_mpc=>ts_zml_itravel
      RETURNING VALUE(es_entity) TYPE zcl_zml_travelling_odt_mpc=>ts_zml_itravel.

    METHODS zml_modify_booking
      IMPORTING
                !ls_entity       TYPE zcl_zml_travelling_odt_mpc=>ts_zml_ibooking
      RETURNING VALUE(es_entity) TYPE zcl_zml_travelling_odt_mpc=>ts_zml_ibooking.

    METHODS deep_insert_travel_booking
      IMPORTING
        !io_data_provider TYPE REF TO /iwbep/if_mgw_entry_provider
      EXPORTING
        !es_s_trv_book    TYPE zcl_zml_travelling_odt_mpc_ext=>ty_s_trv_book
      RAISING
        /iwbep/cx_mgw_busi_exception
        /iwbep/cx_mgw_tech_exception .


    METHODS zml_itravelset_update_entity REDEFINITION.
    METHODS zml_itravelset_delete_entity REDEFINITION.
    METHODS zml_itravelset_create_entity REDEFINITION.
    METHODS zml_ibookingset_get_entity REDEFINITION.
    METHODS zml_itravelset_get_entity REDEFINITION.
    METHODS zml_ibookingset_get_entityset REDEFINITION.
    METHODS zml_itravelset_get_entityset REDEFINITION.

  PRIVATE SECTION.


ENDCLASS.



CLASS zcl_zml_travelling_odt_dpc_ext IMPLEMENTATION.

  METHOD zml_itravelset_get_entityset.

    DATA: lv_source_entity_set_name TYPE /iwbep/mgw_tech_name.

    lv_source_entity_set_name = io_tech_request_context->get_source_entity_set_name( ).

    IF lv_source_entity_set_name IS INITIAL.

      SELECT * FROM zml_travel INTO CORRESPONDING FIELDS OF TABLE et_entityset.
    ELSE.
      SELECT * FROM zml_travel INTO CORRESPONDING FIELDS OF TABLE et_entityset.
    ENDIF.
  ENDMETHOD.

  METHOD zml_ibookingset_get_entityset.
    DATA:ls_keytab TYPE LINE OF /iwbep/t_mgw_name_value_pair.
    LOOP AT it_key_tab INTO ls_keytab.
    ENDLOOP.
    IF ( ls_keytab IS NOT INITIAL ).
      IF ( ls_keytab-name = 'BookingId' ).
        SELECT * FROM zml_booking INTO CORRESPONDING FIELDS OF TABLE et_entityset WHERE booking_id = ls_keytab-value.
      ELSEIF ( ls_keytab-name = 'TravelId' ).
        DATA: lv_travel_id TYPE zml_travel-travel_id.
        SELECT SINGLE travel_id FROM zml_booking INTO lv_travel_id WHERE travel_id = ls_keytab-value.
        SELECT * FROM zml_booking INTO CORRESPONDING FIELDS OF TABLE et_entityset WHERE travel_id = lv_travel_id.
      ENDIF.
    ELSE.
      SELECT * FROM zml_booking INTO CORRESPONDING FIELDS OF TABLE et_entityset.
    ENDIF.
  ENDMETHOD.

  METHOD zml_itravelset_get_entity.
    DATA:ls_keytab TYPE LINE OF /iwbep/t_mgw_name_value_pair.
    LOOP AT it_key_tab INTO ls_keytab.
    ENDLOOP.
    IF ( ls_keytab-name = 'BookingId' ).
      DATA: lv_travel_id TYPE zml_booking-travel_id.
      SELECT SINGLE travel_id FROM zml_booking INTO lv_travel_id WHERE booking_id = ls_keytab-value.
      IF sy-subrc = 0.
        SELECT SINGLE * FROM zml_travel INTO CORRESPONDING FIELDS OF er_entity WHERE travel_id = lv_travel_id.
      ENDIF.
    ELSEIF ( ls_keytab-name = 'TravelId' ).
      SELECT SINGLE * FROM zml_travel INTO CORRESPONDING FIELDS OF er_entity WHERE travel_id = ls_keytab-value.
    ENDIF.
  ENDMETHOD.

  METHOD zml_ibookingset_get_entity.
    DATA:ls_keytab TYPE LINE OF /iwbep/t_mgw_name_value_pair.
    LOOP AT it_key_tab INTO ls_keytab.
    ENDLOOP.
    IF ( ls_keytab-name = 'BookingId' ).
      SELECT SINGLE * FROM zml_booking INTO CORRESPONDING FIELDS OF er_entity WHERE booking_id = ls_keytab-value.
    ELSEIF ( ls_keytab-name = 'TravelId' ).
      SELECT SINGLE * FROM zml_booking INTO CORRESPONDING FIELDS OF er_entity WHERE travel_id = ls_keytab-value.
    ENDIF.
  ENDMETHOD.

  METHOD zml_itravelset_create_entity.
    DATA: ls_entity TYPE zcl_zml_travelling_odt_mpc=>ts_zml_itravel.
    io_data_provider->read_entry_data( IMPORTING es_data = ls_entity ).
    CLEAR er_entity.
    er_entity = zml_modify_travel( ls_entity = ls_entity ).
  ENDMETHOD.

  method zml_ibookingset_create_entity.
    DATA: ls_entity TYPE zcl_zml_travelling_odt_mpc=>ts_zml_ibooking.
    io_data_provider->read_entry_data( IMPORTING es_data = ls_entity ).
    CLEAR er_entity.
    er_entity = zml_modify_booking( ls_entity = ls_entity ).
  endmethod.

  METHOD zml_itravelset_delete_entity.
    DATA: ls_converted_keys TYPE zcl_zml_travelling_odt_mpc=>ts_zml_itravel.
    io_tech_request_context->get_converted_keys( IMPORTING es_key_values = ls_converted_keys ).
    DELETE FROM zml_booking WHERE travel_id = ls_converted_keys-travel_id.
    DELETE FROM zml_travel WHERE travel_id = ls_converted_keys-travel_id.
  ENDMETHOD.

  method zml_ibookingset_delete_entity.
    DATA: ls_converted_keys TYPE zcl_zml_travelling_odt_mpc=>ts_zml_ibooking.
    io_tech_request_context->get_converted_keys( IMPORTING es_key_values = ls_converted_keys ).
    DELETE FROM zml_booking WHERE booking_id = ls_converted_keys-booking_id.
  endmethod.

  METHOD zml_itravelset_update_entity.
    DATA:
      ls_converted_keys TYPE zcl_zml_travelling_odt_mpc=>ts_zml_itravel,
      ls_entity         TYPE zcl_zml_travelling_odt_mpc=>ts_zml_itravel.
    io_data_provider->read_entry_data( IMPORTING es_data = ls_entity ).
    IF ( ls_entity-travel_id IS INITIAL ).
      io_tech_request_context->get_converted_keys(  IMPORTING es_key_values = ls_converted_keys ).
      ls_entity-travel_id = ls_converted_keys-travel_id.
    ENDIF.
    io_data_provider->read_entry_data( IMPORTING es_data = ls_entity ).
    CLEAR er_entity.
    er_entity = zml_modify_travel( ls_entity = ls_entity ).
  ENDMETHOD.

  method zml_ibookingset_update_entity.
    DATA:
      ls_converted_keys TYPE zcl_zml_travelling_odt_mpc=>ts_zml_ibooking,
      ls_entity         TYPE zcl_zml_travelling_odt_mpc=>ts_zml_ibooking.
    io_data_provider->read_entry_data( IMPORTING es_data = ls_entity ).
    IF ( ls_entity-booking_id IS INITIAL ).
      io_tech_request_context->get_converted_keys(  IMPORTING es_key_values = ls_converted_keys ).
      ls_entity-booking_id = ls_converted_keys-booking_id.
    ENDIF.
    io_data_provider->read_entry_data( IMPORTING es_data = ls_entity ).
    CLEAR er_entity.
    er_entity = zml_modify_booking( ls_entity = ls_entity ).
  endmethod.

  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.
    DATA: ls_travel_booking_data TYPE zcl_zml_travelling_odt_mpc_ext=>ty_s_trv_book.
    CLEAR: er_deep_entity.
    TRY.
        CALL METHOD deep_insert_travel_booking
          EXPORTING
            io_data_provider = io_data_provider
          IMPORTING
            es_s_trv_book    = ls_travel_booking_data.
        copy_data_to_ref(
         EXPORTING
           is_data = ls_travel_booking_data
         CHANGING
           cr_data = er_deep_entity ).
      CATCH /iwbep/cx_mgw_busi_exception.
    ENDTRY.
  ENDMETHOD.


  METHOD deep_insert_travel_booking.
    DATA: ls_travel_booking_data TYPE zcl_zml_travelling_odt_mpc_ext=>ty_s_trv_book.
    DATA: ls_entity TYPE zcl_zml_travelling_odt_mpc=>ts_zml_itravel.
    DATA: ls_childentity TYPE zcl_zml_travelling_odt_mpc=>ts_zml_ibooking.
    DATA: ar_childentities TYPE STANDARD TABLE OF zcl_zml_travelling_odt_mpc=>ts_zml_ibooking WITH DEFAULT KEY.
    io_data_provider->read_entry_data( IMPORTING es_data = ls_travel_booking_data ).
    MOVE-CORRESPONDING ls_travel_booking_data TO ls_entity.
    ls_entity = zml_modify_travel( ls_entity = ls_entity ).
    MOVE-CORRESPONDING ls_travel_booking_data-to_booking TO ar_childentities.
    LOOP AT ar_childentities INTO ls_childentity.
      ls_childentity-travel_id = ls_entity-travel_id.
      ls_childentity = zml_modify_booking( ls_entity = ls_childentity ).
      ar_childentities[ sy-index ] = ls_childentity.
    ENDLOOP.
    MOVE-CORRESPONDING ls_entity TO es_s_trv_book.
    MOVE-CORRESPONDING ar_childentities TO es_s_trv_book-to_booking.
  ENDMETHOD.

  METHOD zml_create_uuid.
    DATA lv_long_time_stamp TYPE timestampl.
    GET TIME STAMP FIELD lv_long_time_stamp.
    DATA: l_uuid_x16 TYPE sysuuid_x16.
    DATA: system_uuid TYPE REF TO if_system_uuid.
    DATA: oref        TYPE REF TO cx_uuid_error.
    system_uuid = cl_uuid_factory=>create_system_uuid( ).

    TRY.
        es_uuid = system_uuid->create_uuid_x16( ).
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.
  ENDMETHOD.

  METHOD zml_modify_travel.
    DATA:
      it_entity TYPE zcl_zml_travelling_odt_mpc=>ts_zml_itravel.
    MOVE-CORRESPONDING ls_entity TO it_entity.
    IF ( it_entity-client IS INITIAL ).
      it_entity-client = sy-mandt.
    ENDIF.
    TRY.
        it_entity-name = ls_entity-name.
        DATA itb_entity TYPE TABLE OF zml_travel.
        IF ( it_entity-travel_id IS INITIAL ).
          it_entity-travel_id = zml_create_uuid( ).
          itb_entity = VALUE #( ( it_entity )  ).
          INSERT zml_travel FROM TABLE @itb_entity.
        ELSE.
          itb_entity = VALUE #( ( it_entity )  ).
          MODIFY zml_travel FROM TABLE @itb_entity.
        ENDIF.
        es_entity = it_entity.
      CATCH cx_uuid_error.
    ENDTRY.
  ENDMETHOD.

  METHOD zml_modify_booking.
    DATA:
    it_entity TYPE zcl_zml_travelling_odt_mpc=>ts_zml_ibooking.
    MOVE-CORRESPONDING ls_entity TO it_entity.
    IF ( ls_entity-client IS INITIAL ).
      it_entity-client = sy-mandt.
    ENDIF.
    IF ( ls_entity-travel_id IS NOT INITIAL ).
      TRY.
          DATA itb_entity TYPE TABLE OF zml_booking.
          IF ( it_entity-booking_id IS INITIAL ).
            it_entity-booking_id = zml_create_uuid( ).
            itb_entity = VALUE #( ( it_entity )  ).
            INSERT zml_booking FROM TABLE @itb_entity.
          ELSE.
            itb_entity = VALUE #( ( it_entity )  ).
            MODIFY zml_booking FROM TABLE @itb_entity.
          ENDIF.
          es_entity = it_entity.
        CATCH cx_uuid_error.
      ENDTRY.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
