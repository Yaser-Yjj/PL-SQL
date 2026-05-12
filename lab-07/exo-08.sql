-- Indexes: Creation and EXPLAIN PLAN analysis
-- ÉTAPE 1 : Plan SANS index (observation du TABLE ACCESS FULL)
EXPLAIN PLAN FOR
  SELECT * FROM produits WHERE cat_id = 1 AND prix_ht < 5000;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- ÉTAPE 2 : Créer des index
-- Index B-TREE sur cat_id
CREATE INDEX idx_prod_cat ON produits(cat_id);

-- Index composite : cat_id + prix_ht
CREATE INDEX idx_prod_cat_prix ON produits(cat_id, prix_ht);

-- Index BITMAP sur statut des commandes
CREATE BITMAP INDEX idx_cmd_statut ON commandes(statut);

-- Index sur fonction : recherche insensible à la casse
CREATE INDEX idx_client_nom_up ON clients(UPPER(nom));

-- ÉTAPE 3 : Plan AVEC index (observer INDEX RANGE SCAN)
EXPLAIN PLAN FOR
  SELECT * FROM produits WHERE cat_id = 1 AND prix_ht < 5000;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- ÉTAPE 4 : Requête utilisant l'index sur fonction
EXPLAIN PLAN FOR
  SELECT * FROM clients WHERE UPPER(nom) = 'KARIM ALAOUI';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- ÉTAPE 5 : Consulter les index créés
SELECT index_name, index_type, table_name, uniqueness, status
FROM user_indexes
WHERE table_name IN ('PRODUITS','COMMANDES','CLIENTS')
ORDER BY table_name, index_name;

-- ÉTAPE 6 : Voir les colonnes indexées
SELECT index_name, column_name, column_position
FROM user_ind_columns
WHERE table_name IN ('PRODUITS','COMMANDES','CLIENTS')
ORDER BY index_name, column_position;
/
