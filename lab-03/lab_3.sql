-- Création directe (SQL, pas PL/SQL)

DROP tABLE employes;
CREATE TABLE employes (
   emp_id     NUMBER(6)       PRIMARY KEY,
   nom        VARCHAR2(50)    NOT NULL,
   salaire    NUMBER(10,2)    DEFAULT 0,
   dept_id    NUMBER(4),
   date_emb   DATE            DEFAULT SYSDATE
);-- Création via PL/SQL (EXECUTE IMMEDIATE)
BEGIN
   EXECUTE IMMEDIATE
      'CREATE TABLE departements (
             dept_id   NUMBER(4)     PRIMARY KEY,
         nom_dept  VARCHAR2(30)  NOT NULL
       )';
   --DBMS_OUTPUT.PUT_LINE('Table créée avec succès.');
END;
/

DROP TABLE commandes CASCADE CONSTRAINTS;
DROP TABLE produits    CASCADE CONSTRAINTS;
DROP TABLE clients     CASCADE CONSTRAINTS;


CREATE TABLE clients (
   client_id   NUMBER(6)      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   nom         VARCHAR2(50)   NOT NULL,
   email       VARCHAR2(100),
   solde       NUMBER(10,2)   DEFAULT 0,
   statut      VARCHAR2(10)   DEFAULT 'ACTIF'
);
CREATE TABLE produits (
   prod_id     NUMBER(6)      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   libelle     VARCHAR2(100)  NOT NULL,
   prix        NUMBER(10,2)   NOT NULL,
   stock       NUMBER(6)      DEFAULT 0,
   categorie   VARCHAR2(30)
);

CREATE TABLE commandes (
   cmd_id      NUMBER(8)      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   client_id   NUMBER(6)      REFERENCES clients(client_id),
   prod_id     NUMBER(6)      REFERENCES produits(prod_id),
   quantite    NUMBER(4)      NOT NULL,
   date_cmd    DATE           DEFAULT SYSDATE,
   statut      VARCHAR2(20)   DEFAULT 'EN ATTENTE'
);-- Insertion de données de test
INSERT INTO clients (nom, email, solde, statut) VALUES ('Ali Benali',    'ali@mail.ma',   1500, 'ACTIF');
INSERT INTO clients (nom, email, solde, statut) VALUES ('Sara Idrissi',  'sara@mail.ma',  250,  'ACTIF');
INSERT INTO clients (nom, email, solde, statut) VALUES ('Omar Tazi',     'omar@mail.ma',  0,    'INACTIF');
INSERT INTO clients (nom, email, solde, statut) VALUES ('Nadia Haddad', 'nadia@mail.ma', 3200, 'PREMIUM');

INSERT INTO produits (libelle, prix, stock, categorie) VALUES ('Laptop HP',     
8500, 15, 'INFORMATIQUE');
INSERT INTO produits (libelle, prix, stock, categorie) VALUES ('Souris sans fil', 
120, 80, 'INFORMATIQUE');
INSERT INTO produits (libelle, prix, stock, categorie) VALUES ('Clavier 
mécanique', 350, 45, 'INFORMATIQUE');
INSERT INTO produits (libelle, prix, stock, categorie) VALUES ('Écran 24 pouces', 
2200, 10, 'INFORMATIQUE');
INSERT INTO produits (libelle, prix, stock, categorie) VALUES ('Livre Oracle 
PL/SQL', 180, 30, 'LIVRE');
COMMIT;
--DBMS_OUTPUT.PUT_LINE('Tables créées et données insérées.');

--exercice 2
DECLARE
   v_nom     clients.nom%TYPE;
   v_email   clients.email%TYPE;
   v_solde   clients.solde%TYPE;
   v_statut  clients.statut%TYPE;
BEGIN
   SELECT nom, email, solde, statut
     INTO v_nom, v_email, v_solde, v_statut
     FROM clients
    WHERE client_id = 100;
   DBMS_OUTPUT.PUT_LINE('=== Informations Client ===');
   DBMS_OUTPUT.PUT_LINE('Nom    : ' || v_nom);
      DBMS_OUTPUT.PUT_LINE('Email  : ' || v_email);
   DBMS_OUTPUT.PUT_LINE('Solde  : ' || TO_CHAR(v_solde, '9999.99') || ' MAD');
   DBMS_OUTPUT.PUT_LINE('Statut : ' || v_statut);

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Client introuvable !');
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
END;
/


DECLARE
   v_libelle  produits.libelle%TYPE;
   v_prix     produits.prix%TYPE;
   v_stock    produits.stock%TYPE;

BeGIN
SelECT libelle, prix, stock INTO v_libelle, v_prix, v_stock FROM produits WHERE prod_id = 1;
   DBMS_OUTPUT.PUT_LINE('Produit : ' || v_libelle ||' | Prix : ' || v_prix || ' MAD' || ' | Stock : ' || v_stock || ' unités');
END;
/


DECLARE
   v_prod   produits%ROWTYPE;
   v_tva    NUMBER := 0.20;  -- TVA 20%
   v_ttc    NUMBER;
BEGIN
   SELECT *
     INTO v_prod
     FROM produits
    WHERE prod_id = 1;  -- Laptop HP
   v_ttc := v_prod.prix * (1 + v_tva);
   DBMS_OUTPUT.PUT_LINE('=== Fiche Produit ===');
   DBMS_OUTPUT.PUT_LINE('Libellé   : ' || v_prod.libelle);
   DBMS_OUTPUT.PUT_LINE('Catégorie : ' || v_prod.categorie);
   DBMS_OUTPUT.PUT_LINE('Prix HT   : ' || v_prod.prix || ' MAD');
   DBMS_OUTPUT.PUT_LINE('Prix TTC  : ' || ROUND(v_ttc, 2) || ' MAD');
   DBMS_OUTPUT.PUT_LINE('Stock     : ' || v_prod.stock || ' unités');
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Produit introuvable !');
END;
/


DECLARE
   v_client    clients%ROWTYPE;
   v_solde_ttc NUMBER;
BEGIN
   SELECT *  INTO v_client FROM clients WHERE nom = 'Nadia Haddad';
   v_solde_ttc := v_client.solde * 1.20;
   DBMS_OUTPUT.PUT_LINE('=== Informations Client ===');
   DBMS_OUTPUT.PUT_LINE('Nom       : ' || v_client.nom);
   DBMS_OUTPUT.PUT_LINE('Statut    : ' || v_client.statut);
   DBMS_OUTPUT.PUT_LINE('Solde TTC : ' || ROUND(v_solde_ttc,2) || ' MAD');


END;
/


BEGIN
   INSERT INTO clients (nom, email, solde, statut)
   VALUES ('Karim Mansouri', 'karim@mail.ma', 800, 'ACTIF');
   DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' ligne(s) insérée(s).');
   COMMIT;
END;
/
DECLARE
   v_client_id   NUMBER := 1;
   v_prod_id     NUMBER := 2;   -- Souris sans fil
   v_quantite    NUMBER := 3;
   v_stock       NUMBER;
   v_prix        NUMBER;
BEGIN
   -- Vérifier le stock disponible
   SELECT stock, prix
     INTO v_stock, v_prix
     FROM produits
    WHERE prod_id = v_prod_id;
   IF v_stock >= v_quantite THEN
      -- Insérer la commande
      INSERT INTO commandes (client_id, prod_id, quantite, statut)
      VALUES (v_client_id, v_prod_id, v_quantite, 'CONFIRMÉE');
      -- Mettre à jour le stock
      UPDATE produits
         SET stock = stock - v_quantite
       WHERE prod_id = v_prod_id;
      DBMS_OUTPUT.PUT_LINE('Commande créée. Total : '
         || (v_quantite * v_prix) || ' MAD');
      COMMIT;
   ELSE
         DBMS_OUTPUT.PUT_LINE('Stock insuffisant ! Disponible : ' || v_stock);
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
END;
/


DECLARE
BEGIN
   INSERT INTO clients (nom, email, solde, statut)
   VALUES ('Youssef El Amrani', 'youssef@mail.ma', 1200, 'ACTIF');

   IF SQL%ROWCOUNT > 0 THEN
      DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' ligne(s) insérée(s) avec succès.');
   ELSE
      DBMS_OUTPUT.PUT_LINE('Aucune insertion effectuée.');
   END IF;

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
END;
/








VARIABLE rows_deleted VARCHAR2(30)
DECLARE
v_client_id clients.client_id%TYPE := 2;
BEGIN
DELETE FROM clients WHERE client_id = v_client_id;
:rows_deleted := SQL%ROWCOUNT;
END;
/
PRINT rows_deleted


DECLARE
v_stock produits.stock%TYPE;
v_libelle produits.libelle%TYPE;
CURSOR c_produits IS SELECT stock, libelle FROM produits;
BEGIN
   OPEN c_produits;
   LOOP
      FETCH c_produits INTO v_stock, v_libelle;
      EXIT WHEN c_produits%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('Stock de ' || v_libelle || ' : ' || v_stock);
   END LOOP;
   CLOSE c_produits;
END;
/