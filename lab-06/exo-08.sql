-- Exercise 8: Autonomous exercise - Package PKG_CONSULTANTS (to be completed)
-- Create from scratch: specification and body with all 5 elements

-- PKG_CONSULTANTS must contain:
-- 1. g_tarif_moyen (global variable) - stores average tariff of available consultants
-- 2. ajouter_consultant (procedure) - adds new consultant with validation
-- 3. tarif_niveau (function) - classifies consultant by tariff level
-- 4. rafraichir_stats (procedure) - recalculates average tariff
-- 5. afficher_consultants (procedure) - displays all consultants with their levels

-- ============================================
-- YOUR SPECIFICATION HERE
-- ============================================

CREATE OR REPLACE PACKAGE pkg_consultants AS
 g_tarif_moyen NUMBER;
 
 PROCEDURE ajouter_consultant(p_nom IN VARCHAR2, p_specialite IN VARCHAR2, p_tarif_jour IN NUMBER);
 FUNCTION tarif_niveau(p_cons_id IN NUMBER) RETURN VARCHAR2;
 PROCEDURE rafraichir_stats;
 PROCEDURE afficher_consultants;
END pkg_consultants;
/

-- ============================================
-- YOUR BODY HERE
-- ============================================

CREATE OR REPLACE PACKAGE BODY pkg_consultants AS

 PROCEDURE ajouter_consultant(p_nom IN VARCHAR2, p_specialite IN VARCHAR2, p_tarif_jour IN NUMBER) AS
 BEGIN
  IF p_tarif_jour <= 0 THEN
    RAISE_APPLICATION_ERROR(-20050, 'Le tarif doit être positif');
  END IF;
  
  INSERT INTO consultants(cons_id, nom, specialite, tarif_jour, disponible)
  VALUES((SELECT NVL(MAX(cons_id), 0) + 1 FROM consultants), p_nom, p_specialite, p_tarif_jour, 'O');
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Consultant ' || p_nom || ' ajouté avec succès.');
 EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur lors de l''ajout : ' || SQLERRM);
 END ajouter_consultant;

 FUNCTION tarif_niveau(p_cons_id IN NUMBER) RETURN VARCHAR2 AS
 v_tarif NUMBER;
 v_niveau VARCHAR2(20);
 BEGIN
  SELECT tarif_jour INTO v_tarif FROM consultants WHERE cons_id = p_cons_id;
  
  SELECT niveau INTO v_niveau FROM grille_tarifaire
  WHERE v_tarif BETWEEN tarif_min AND tarif_max;
  
  RETURN v_niveau;
 EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'NON_CLASSE';
 END tarif_niveau;

 PROCEDURE rafraichir_stats AS
 BEGIN
  SELECT AVG(tarif_jour) INTO g_tarif_moyen
  FROM consultants WHERE disponible = 'O';
  
  DBMS_OUTPUT.PUT_LINE('Tarif moyen (consultants disponibles) : ' || ROUND(g_tarif_moyen, 2) || ' MAD');
 END rafraichir_stats;

 PROCEDURE afficher_consultants AS
 BEGIN
  DBMS_OUTPUT.PUT_LINE('=== CONSULTANTS ===');
  FOR rec IN (SELECT cons_id, nom, tarif_jour, disponible FROM consultants ORDER BY cons_id) LOOP
    DBMS_OUTPUT.PUT_LINE(
      rec.nom || ' | ' || rec.tarif_jour || ' MAD | ' || 
      tarif_niveau(rec.cons_id) || ' | Dispo: ' || rec.disponible
    );
  END LOOP;
 END afficher_consultants;

END pkg_consultants;
/

-- ============================================
-- TEST SEQUENCE (6 mandatory tests)
-- ============================================

-- Test 1: Refresh stats and display g_tarif_moyen
BEGIN
 pkg_consultants.rafraichir_stats;
END;
/

-- Test 2: Add new consultant
BEGIN
 pkg_consultants.ajouter_consultant('Test Nouvel', 'Cloud', 1700);
END;
/

-- Test 3: Try to add with invalid tariff (should fail)
BEGIN
 pkg_consultants.ajouter_consultant('Erreur', 'X', -500);
END;
/

-- Test 4: Display all consultants
BEGIN
 pkg_consultants.afficher_consultants;
END;
/

-- Test 5: Use tarif_niveau function in SELECT
SELECT pkg_consultants.tarif_niveau(2) AS niveau FROM DUAL;
/

-- Test 6: Refresh stats again - did average change?
BEGIN
 pkg_consultants.rafraichir_stats;
END;
/
