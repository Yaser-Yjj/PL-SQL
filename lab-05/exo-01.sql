-- Exception handling - Division by zero
declare 
nbr number;
begin
nbr := 10;
DBMS_OUTPUT.PUT_LINE(nbr/0);
end;
/
