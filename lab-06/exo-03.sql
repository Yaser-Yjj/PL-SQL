-- Exercise 3: Procedure for automatic invoice creation
CREATE OR REPLACE PROCEDURE creer_facture(
 p_proj_id IN projets.proj_id%TYPE,
 p_fact_id OUT factures.fact_id%TYPE
) AS
 v_tarif NUMBER;
 v_jours NUMBER;
 v_titre VARCHAR2(100);
 v_ht NUMBER;
 v_ttc NUMBER;
BEGIN
 -- Récupérer les données du projet + tarif consultant
 SELECT p.nb_jours, c.tarif_jour, p.titre
 INTO v_jours, v_tarif, v_titre
 FROM projets p
 JOIN consultants c ON p.cons_id = c.cons_id
 WHERE p.proj_id = p_proj_id;
 -- Calcul
 v_ht := v_tarif * v_jours;
 v_ttc := v_ht * 1.20;
 -- Insérer la facture
 INSERT INTO factures(proj_id, montant_ht, tva, montant_ttc)
 VALUES(p_proj_id, v_ht, 0.20, v_ttc)
 RETURNING fact_id INTO p_fact_id;
 COMMIT;
 DBMS_OUTPUT.PUT_LINE(
 'Facture #' || p_fact_id || ' créée — Projet : ' || v_titre ||
 ' — HT : ' || v_ht || ' MAD — TTC : ' || v_ttc || ' MAD'
 );
EXCEPTION
 WHEN NO_DATA_FOUND THEN
 DBMS_OUTPUT.PUT_LINE('ERREUR : Projet ' || p_proj_id || ' introuvable.');
 ROLLBACK;
 WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERREUR : ' || SQLERRM);
 ROLLBACK;
END creer_facture;
/

-- Test 1 : projet existant
DECLARE
 v_id factures.fact_id%TYPE;
BEGIN
 creer_facture(1, v_id);
 DBMS_OUTPUT.PUT_LINE('=> fact_id retourné : ' || v_id);
END;
/

-- Test 2 : projet inexistant
DECLARE
 v_id factures.fact_id%TYPE;
BEGIN
 creer_facture(999, v_id);
END;
/

-- Vérifier la facture créée
SELECT f.fact_id, p.titre, f.montant_ht, f.tva, f.montant_ttc
FROM factures f JOIN projets p ON f.proj_id = p.proj_id;
/
