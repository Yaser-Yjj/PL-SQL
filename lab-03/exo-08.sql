-- Exercise 8: DELETE with SQL%ROWCOUNT and VARIABLE
VARIABLE rows_deleted VARCHAR2(30)

DECLARE
v_client_id clients.client_id%TYPE := 2;
BEGIN
DELETE FROM clients WHERE client_id = v_client_id;
:rows_deleted := SQL%ROWCOUNT;
END;
/

PRINT rows_deleted
/
