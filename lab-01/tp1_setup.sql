VARIABLE v_nom VARCHAR2(50);
BEGIN
:v_nom := 'Yaser';
DBMS_OUTPUT.PUT_LINE(v_nom);
END;
/

PRINT v_nom
