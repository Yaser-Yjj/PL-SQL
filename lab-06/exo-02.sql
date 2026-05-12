-- Exercise 2: Custom exception with RAISE and logging
DECLARE
 -- (1) Déclarer une exception personnalisée
 cons_non_dispo EXCEPTION;
 v_dispo consultants.disponible%TYPE;
 v_nom consultants.nom%TYPE;
 v_cons_id NUMBER := 3; -- Omar Tazi, disponible = N
BEGIN
 SELECT nom, disponible INTO v_nom, v_dispo
 FROM consultants WHERE cons_id = v_cons_id;
 -- (2) Lever l'exception si le consultant n'est pas disponible
 IF v_dispo = 'N' THEN
 RAISE cons_non_dispo; -- lever l'exception cons_non_dispo
 END IF;
 DBMS_OUTPUT.PUT_LINE(v_nom || ' affecté avec succès.');
EXCEPTION
 -- (3) Intercepter l'exception personnalisée
 WHEN cons_non_dispo THEN
 DBMS_OUTPUT.PUT_LINE('ERREUR : Le consultant ' || v_nom || ' n''est pas disponible.');
 -- (4) Logger l'erreur dans logs_erreurs
 INSERT INTO logs_erreurs (code_err, message_err, contexte)
 VALUES (-20001, 'Consultant non disponible : ' || v_nom, 'Affectation projet');
 COMMIT;
 WHEN NO_DATA_FOUND THEN
 DBMS_OUTPUT.PUT_LINE('ERREUR : Consultant introuvable.');
 WHEN OTHERS THEN
 -- (5) Capturer le code et message Oracle
 DBMS_OUTPUT.PUT_LINE('Erreur inattendue : ' || SQLERRM);
END;
/

-- Vérifier le log
SELECT code_err, message_err, contexte, log_date FROM logs_erreurs;
/
