CLASS zcl_zml_travelling_odt_mpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zml_travelling_odt_mpc
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_s_trv_book.
             INCLUDE TYPE zcl_zml_travelling_odt_mpc=>ts_zml_itravel.
    TYPES:
             to_booking TYPE STANDARD TABLE OF zcl_zml_travelling_odt_mpc=>ts_zml_ibooking WITH DEFAULT KEY,
           END OF ty_s_trv_book.

    METHODS define REDEFINITION.



  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zml_travelling_odt_mpc_ext IMPLEMENTATION.

  METHOD define.

    DATA lo_entity_type TYPE REF TO /iwbep/if_mgw_odata_entity_typ.

    super->define( ).

    lo_entity_type = model->get_entity_type( iv_entity_name = 'ZML_ITRAVEL' ).
    lo_entity_type->bind_structure( iv_structure_name = 'zcl_zml_travelling_odt_mpc_ext=>ty_s_trv_book' ).

  ENDMETHOD.

ENDCLASS.
