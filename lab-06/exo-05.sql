-- Exercise 5: Function to calculate total TTC cost of a project
CREATE OR REPLACE FUNCTION cout_projet_ttc(
 p_proj_id IN projets.proj_id%TYPE
) RETURN NUMBER AS
 v_tarif NUMBER;
 v_jours NUMBER;
BEGIN
 SELECT c.tarif_jour, p.nb_jours
 INTO v_tarif, v_jours
 FROM projets p
 JOIN consultants c ON p.cons_id = c.cons_id
 WHERE p.proj_id = p_proj_id;
 RETURN ROUND(v_tarif * v_jours * 1.20, 2);
EXCEPTION
 WHEN NO_DATA_FOUND THEN
 RETURN 0; -- projet inconnu => coût = 0
END cout_projet_ttc;
/

-- Utilisation dans un bloc PL/SQL
BEGIN
 DBMS_OUTPUT.PUT_LINE('Coût TTC projet 1 : ' || cout_projet_ttc(1) || ' MAD');
 DBMS_OUTPUT.PUT_LINE('Coût TTC projet 2 : ' || cout_projet_ttc(2) || ' MAD');
END;
/

-- Utilisation directement dans SQL
SELECT p.proj_id, p.titre, c.nom AS consultant,
 p.nb_jours, c.tarif_jour,
 cout_projet_ttc(p.proj_id) AS cout_ttc
FROM projets p
JOIN consultants c ON p.cons_id = c.cons_id
ORDER BY cout_ttc DESC;
/
