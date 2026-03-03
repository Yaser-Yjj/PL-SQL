SET SERVEROUTPUT ON;
DECLARE
-- %TYPE permet de déclarer une variable du même type que la colonne d'une table
-- et on utilise %TYPE pour éviter les problèmes de compatibilité si le type de la colonne change
  v_nom  ETUDIANT.nom%TYPE;
  v_note ETUDIANT.note%TYPE;
BEGIN
  SELECT nom, note INTO v_nom, v_note FROM ETUDIANT WHERE id = 1;
  DBMS_OUTPUT.PUT_LINE('Nom : ' || v_nom);
  DBMS_OUTPUT.PUT_LINE('Note : ' || v_note);
END;
/