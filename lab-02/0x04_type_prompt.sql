SET SERVEROUTPUT ON;
DECLARE
  v_id   ETUDIANT.id%TYPE := &saisir_id;
  v_nom  ETUDIANT.nom%TYPE;
BEGIN
  SELECT nom INTO v_nom FROM ETUDIANT WHERE id = v_id;
  DBMS_OUTPUT.PUT_LINE('Nom de l''étudiant : ' || v_nom);
END;
/