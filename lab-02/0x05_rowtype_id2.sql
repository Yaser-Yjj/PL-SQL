SET SERVEROUTPUT ON;
DECLARE
-- %ROWTYPE permet de déclarer une variable du même type que la ligne d'une table
-- et on utilise %ROWTYPE pour éviter les problèmes de compatibilité si la structure de la ligne change
  v_etudiant ETUDIANT%ROWTYPE;
BEGIN
  SELECT * INTO v_etudiant FROM ETUDIANT WHERE id = 2;
  DBMS_OUTPUT.PUT_LINE('ID : ' || v_etudiant.id);
  DBMS_OUTPUT.PUT_LINE('Nom : ' || v_etudiant.nom);
  DBMS_OUTPUT.PUT_LINE('Note : ' || v_etudiant.note);
END;
/