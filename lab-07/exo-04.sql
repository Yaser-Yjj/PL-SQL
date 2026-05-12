-- Materialized View with scheduled refresh
CREATE MATERIALIZED VIEW mv_ventes_cat
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
  SELECT
    cat.cat_id,
    cat.libelle          AS categorie,
    COUNT(lc.ligne_id)   AS nb_lignes,
    SUM(lc.qte * lc.prix_unit) AS ca_total
  FROM categories cat
  JOIN produits p          ON p.cat_id  = cat.cat_id
  JOIN lignes_commande lc  ON lc.prod_id = p.prod_id
  GROUP BY cat.cat_id, cat.libelle;

-- Interroger la MV (résultat pré-calculé)
SELECT * FROM mv_ventes_cat ORDER BY ca_total DESC;

-- Ajouter une nouvelle ligne de commande
INSERT INTO lignes_commande VALUES(9, 1003, 2, 5, 350);
COMMIT;

-- La MV n'est PAS encore à jour (ON DEMAND)
SELECT * FROM mv_ventes_cat WHERE cat_id = 1;

-- Rafraîchir manuellement
EXEC DBMS_MVIEW.REFRESH('MV_VENTES_CAT', 'C');  -- C = COMPLETE

-- Maintenant la MV est à jour
SELECT * FROM mv_ventes_cat WHERE cat_id = 1;

-- Consulter le dictionnaire
SELECT mview_name, refresh_mode, refresh_method, last_refresh_date
FROM user_mviews WHERE mview_name = 'MV_VENTES_CAT';
/
