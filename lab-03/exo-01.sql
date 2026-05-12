-- Exercise 1: SELECT INTO with exception handling - Client info
DECLARE
   v_nom     clients.nom%TYPE;
   v_email   clients.email%TYPE;
   v_solde   clients.solde%TYPE;
   v_statut  clients.statut%TYPE;
BEGIN
   SELECT nom, email, solde, statut
     INTO v_nom, v_email, v_solde, v_statut
     FROM clients
    WHERE client_id = 1;
   DBMS_OUTPUT.PUT_LINE('=== Informations Client ===');
   DBMS_OUTPUT.PUT_LINE('Nom    : ' || v_nom);
   DBMS_OUTPUT.PUT_LINE('Email  : ' || v_email);
   DBMS_OUTPUT.PUT_LINE('Solde  : ' || TO_CHAR(v_solde, '9999.99') || ' MAD');
   DBMS_OUTPUT.PUT_LINE('Statut : ' || v_statut);

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Client introuvable !');
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
END;
/
