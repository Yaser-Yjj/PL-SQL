-- Exercise 1: Predefined exceptions NO_DATA_FOUND and TOO_MANY_ROWS

-- Test 1 : client qui n'existe pas => NO_DATA_FOUND
DECLARE
 v_nom clients.nom%TYPE;
 v_solde clients.solde%TYPE;
BEGIN
 SELECT nom, solde INTO v_nom, v_solde
 FROM clients WHERE client_id = 999; -- n'existe pas
 DBMS_OUTPUT.PUT_LINE('Client : ' || v_nom);
EXCEPTION
 WHEN NO_DATA_FOUND THEN
 DBMS_OUTPUT.PUT_LINE('ERREUR : Aucun client trouvé avec cet ID.');
 WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERREUR inattendue : ' || SQLERRM);
END;
/

-- Test 2 : SELECT INTO retourne plusieurs lignes => TOO_MANY_ROWS
DECLARE
 v_nom clients.nom%TYPE;
BEGIN
 SELECT nom INTO v_nom FROM clients; -- retourne 3 lignes !
 DBMS_OUTPUT.PUT_LINE('Client : ' || v_nom);
EXCEPTION
 WHEN TOO_MANY_ROWS THEN
 DBMS_OUTPUT.PUT_LINE('ERREUR : SELECT INTO ne doit retourner qu''une seule ligne.');
 WHEN NO_DATA_FOUND THEN
 DBMS_OUTPUT.PUT_LINE('ERREUR : Aucun résultat.');
END;
/
