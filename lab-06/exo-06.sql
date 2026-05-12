-- Exercise 6: Function to classify consultant by tariff level
CREATE OR REPLACE FUNCTION niveau_consultant(
 p_cons_id IN consultants.cons_id%TYPE
) RETURN VARCHAR2 AS
 v_tarif NUMBER;
 v_niveau grille_tarifaire.niveau%TYPE;
BEGIN
 -- Lire le tarif du consultant
 SELECT tarif_jour INTO v_tarif
 FROM consultants WHERE cons_id = p_cons_id;
 -- Trouver le niveau correspondant dans la grille
 SELECT niveau INTO v_niveau
 FROM grille_tarifaire
 WHERE v_tarif BETWEEN tarif_min AND tarif_max;
 RETURN v_niveau;
EXCEPTION
 WHEN NO_DATA_FOUND THEN
 RETURN 'NON_CLASSE';
 WHEN TOO_MANY_ROWS THEN
 RETURN 'GRILLE_ERREUR';
END niveau_consultant;
/

-- Test sur tous les consultants
SELECT cons_id, nom, tarif_jour,
 niveau_consultant(cons_id) AS niveau
FROM consultants
ORDER BY tarif_jour;

-- Test avec ID inexistant
SELECT niveau_consultant(99) AS niveau_inconnu FROM DUAL;
/
