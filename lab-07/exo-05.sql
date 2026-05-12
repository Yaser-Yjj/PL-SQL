-- Materialized View with fast refresh (using MV LOG)
CREATE MATERIALIZED VIEW LOG ON lignes_commande
WITH ROWID, SEQUENCE (qte, prix_unit, prod_id)
INCLUDING NEW VALUES;

-- Créer la vue matérialisée avec rafraîchissement rapide
CREATE MATERIALIZED VIEW mv_stock_vendu
BUILD IMMEDIATE
REFRESH FAST ON COMMIT
AS
SELECT 
    lc.prod_id,
    COUNT(*)                    AS nb_lignes,
    SUM(lc.qte)                 AS qte_vendue,
    SUM(lc.qte * lc.prix_unit)  AS ca_produit
FROM lignes_commande lc
GROUP BY lc.prod_id;

-- Voir l'état initial
SELECT prod_id, qte_vendue, ca_produit 
FROM mv_stock_vendu 
ORDER BY prod_id;

-- Ajouter une vente et valider
INSERT INTO lignes_commande VALUES(10, 1004, 1, 1, 8500);
COMMIT;

-- Vérifier la MV mise à jour automatiquement
SELECT prod_id, qte_vendue, ca_produit 
FROM mv_stock_vendu 
WHERE prod_id = 1;

-- Dictionnaire
SELECT log_table, master FROM user_mview_logs;
/
