-- Exercise 4: Procedure with IN OUT parameter - Toggle consultant availability
CREATE OR REPLACE PROCEDURE basculer_dispo(
 p_cons_id IN consultants.cons_id%TYPE,
 p_nouvelle IN OUT consultants.disponible%TYPE -- (1) mode : lecture ET écriture
) AS
 v_actuelle consultants.disponible%TYPE;
 v_nom consultants.nom%TYPE;
BEGIN
 -- Lire la disponibilité actuelle
 SELECT disponible, nom
 INTO v_actuelle, v_nom -- (2) variable disponibilité
 FROM consultants WHERE cons_id = p_cons_id;
 -- Basculer la valeur
 IF v_actuelle = 'O' THEN
 p_nouvelle := 'N'; -- (3) valeur opposée
 ELSE
 p_nouvelle := 'O'; -- (4) valeur opposée
 END IF;
 -- Mettre à jour la table
 UPDATE consultants -- (5) instruction de mise à jour
 SET disponible = p_nouvelle
 WHERE cons_id = p_cons_id; -- (6) paramètre ID
 COMMIT;
 DBMS_OUTPUT.PUT_LINE(
 v_nom || ' : ' || v_actuelle || ' => ' || p_nouvelle
 );
EXCEPTION
 WHEN NO_DATA_FOUND THEN
 RAISE_APPLICATION_ERROR(-20001, -- (7) code entre -20001 et -20999
 'Consultant ID ' || p_cons_id || ' introuvable.');
END basculer_dispo; -- (8) nom de la procédure
/

-- Test
DECLARE
 v_dispo VARCHAR2(1) := NULL;
BEGIN
 basculer_dispo(1, v_dispo); -- Karim : O => N
 DBMS_OUTPUT.PUT_LINE('Nouvelle valeur retournée : ' || v_dispo);
 basculer_dispo(1, v_dispo); -- Karim : N => O
 DBMS_OUTPUT.PUT_LINE('Nouvelle valeur retournée : ' || v_dispo);
END;
/

SELECT cons_id, nom, disponible FROM consultants;
/
