REPORT z_employee_leave_management.

DATA: lt_leave_requests TYPE TABLE OF ty_leave_request,
      lv_employee_id TYPE sy-uname,
      lv_leave_type TYPE string,
      lv_start_date TYPE datum,
      lv_end_date TYPE datum.

TYPES: BEGIN OF ty_leave_request,
         request_id TYPE sy-index,
         employee_id TYPE sy-uname,
         leave_type TYPE string,
         start_date TYPE datum,
         end_date TYPE datum,
         status TYPE string,
       END OF ty_leave_request.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS: p_employee TYPE sy-uname OBLIGATORY,
            p_leave_type TYPE string OBLIGATORY,
            p_start_date TYPE datum OBLIGATORY,
            p_end_date TYPE datum OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  lv_employee_id = p_employee.
  lv_leave_type = p_leave_type.
  lv_start_date = p_start_date.
  lv_end_date = p_end_date.

  " Simulated leave request insertion
  CLEAR lt_leave_requests.
  MOVE-CORRESPONDING p TO lt_leave_requests.
  lt_leave_requests-request_id = sy-index.
  lt_leave_requests-status = 'Pending'.
  APPEND lt_leave_requests.

  " Display the leave request
  PERFORM display_leave_request.

FORM display_leave_request.
  DATA: lt_display TYPE TABLE OF ty_leave_request,
        lt_status TYPE TABLE OF string.

  SELECT * FROM lt_leave_requests INTO TABLE lt_display WHERE employee_id = lv_employee_id.

  LOOP AT lt_display INTO DATA(ls_display).
    APPEND ls_display-status TO lt_status.
    WRITE: / 'Request ID:', ls_display-request_id,
            / 'Leave Type:', ls_display-leave_type,
            / 'Start Date:', ls_display-start_date,
            / 'End Date:', ls_display-end_date,
            / 'Status:', ls_display-status.
  ENDLOOP.

  " Check if any request is pending
  IF 'Pending' IN lt_status.
    WRITE: / 'You have pending leave requests.'.
  ELSE.
    WRITE: / 'No pending leave requests.'.
  ENDIF.
ENDFORM.
