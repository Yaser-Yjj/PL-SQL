SET SERVEROUTPUT ON;
DECLARE
-- is record c'est une structure de données qui peut contenir plusieurs champs de différents types
-- et en utilisant is record on peut créer une variable qui peut stocker plusieurs valeurs liées entre elles
  TYPE t_etudiant IS RECORD(
    nom ETUDIANT.nom%TYPE,
    note ETUDIANT.note%TYPE
  );
  v_rec t_etudiant;
BEGIN
  SELECT nom, note INTO v_rec FROM ETUDIANT WHERE id = 3;
  DBMS_OUTPUT.PUT_LINE('Chargé via RECORD -> Nom: ' || v_rec.nom || ' Note: ' || v_rec.note);
END;
/