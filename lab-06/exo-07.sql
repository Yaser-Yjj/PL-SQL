-- Exercise 7: Complete package PKG_FACTURATION with specification and body

-- ÉTAPE 1 : Spécification du package
CREATE OR REPLACE PACKAGE pkg_facturation AS
 -- Compteur global de factures créées (session)
 g_nb_factures NUMBER := 0;
 -- Créer une facture pour un projet
 PROCEDURE creer_facture(
 p_proj_id IN projets.proj_id%TYPE,
 p_fact_id OUT factures.fact_id%TYPE
 );
 -- Retourner le montant TTC d'un projet
 FUNCTION cout_ttc(
 p_proj_id IN projets.proj_id%TYPE
 ) RETURN NUMBER;
 -- Afficher le résumé de toutes les factures
 PROCEDURE afficher_bilan;
END pkg_facturation;
/

-- ÉTAPE 2 : Corps du package
CREATE OR REPLACE PACKAGE BODY pkg_facturation AS
 -- Implémentation de creer_facture
 PROCEDURE creer_facture(
 p_proj_id IN projets.proj_id%TYPE,
 p_fact_id OUT factures.fact_id%TYPE
 ) AS
 v_ht NUMBER;
 v_ttc NUMBER;
 BEGIN
 v_ttc := cout_ttc(p_proj_id); -- appel interne
 v_ht := ROUND(v_ttc / 1.20, 2);
 INSERT INTO factures(proj_id, montant_ht, tva, montant_ttc)
 VALUES(p_proj_id, v_ht, 0.20, v_ttc)
 RETURNING fact_id INTO p_fact_id;
 g_nb_factures := g_nb_factures + 1; -- incrémenter le compteur global
 COMMIT;
 DBMS_OUTPUT.PUT_LINE('Facture ' || p_fact_id || ' créée — TTC : ' || v_ttc || ' MAD');
 EXCEPTION
 WHEN NO_DATA_FOUND THEN
 RAISE_APPLICATION_ERROR(-20010, 'Projet introuvable : ' || p_proj_id);
 END creer_facture;
 -- Implémentation de cout_ttc
 FUNCTION cout_ttc(p_proj_id IN projets.proj_id%TYPE) RETURN NUMBER AS
 v_t NUMBER; v_j NUMBER;
 BEGIN
 SELECT c.tarif_jour, p.nb_jours INTO v_t, v_j
 FROM projets p JOIN consultants c ON p.cons_id = c.cons_id
 WHERE p.proj_id = p_proj_id;
 RETURN ROUND(v_t * v_j * 1.20, 2);
 EXCEPTION
 WHEN NO_DATA_FOUND THEN RETURN 0;
 END cout_ttc;
 -- Implémentation de afficher_bilan
 PROCEDURE afficher_bilan AS
 v_total NUMBER;
 BEGIN
 SELECT NVL(SUM(montant_ttc), 0) INTO v_total FROM factures;
 DBMS_OUTPUT.PUT_LINE('=== BILAN FACTURATION ===');
 DBMS_OUTPUT.PUT_LINE('Factures cette session : ' || g_nb_factures);
 DBMS_OUTPUT.PUT_LINE('Total TTC (toutes) : ' || v_total || ' MAD');
 END afficher_bilan;
END pkg_facturation;
/

-- Tests du package
DECLARE
 v_id factures.fact_id%TYPE;
BEGIN
 pkg_facturation.creer_facture(1, v_id);
 pkg_facturation.creer_facture(2, v_id);
 pkg_facturation.afficher_bilan;
 DBMS_OUTPUT.PUT_LINE('Compteur global : ' || pkg_facturation.g_nb_factures);
END;
/

-- Utiliser la fonction dans SQL
SELECT p.proj_id, p.titre, pkg_facturation.cout_ttc(p.proj_id) AS cout_ttc
FROM projets p ORDER BY proj_id;
/
