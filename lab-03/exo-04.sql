-- Exercise 4: Using ROWTYPE - Client data with calculations
DECLARE
   v_client    clients%ROWTYPE;
   v_solde_ttc NUMBER;
BEGIN
   SELECT *  
     INTO v_client 
     FROM clients 
    WHERE nom = 'Nadia Haddad';
   v_solde_ttc := v_client.solde * 1.20;
   DBMS_OUTPUT.PUT_LINE('=== Informations Client ===');
   DBMS_OUTPUT.PUT_LINE('Nom       : ' || v_client.nom);
   DBMS_OUTPUT.PUT_LINE('Statut    : ' || v_client.statut);
   DBMS_OUTPUT.PUT_LINE('Solde TTC : ' || ROUND(v_solde_ttc, 2) || ' MAD');
END;
/
