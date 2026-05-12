-- Setup: Create tables and insert test data
DROP TABLE employes;
CREATE TABLE employes (
   emp_id     NUMBER(6)       PRIMARY KEY,
   nom        VARCHAR2(50)    NOT NULL,
   salaire    NUMBER(10,2)    DEFAULT 0,
   dept_id    NUMBER(4),
   date_emb   DATE            DEFAULT SYSDATE
);

-- Création via PL/SQL (EXECUTE IMMEDIATE)
BEGIN
   EXECUTE IMMEDIATE
      'CREATE TABLE departements (
             dept_id   NUMBER(4)     PRIMARY KEY,
         nom_dept  VARCHAR2(30)  NOT NULL
       )';
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
);

-- Insertion de données de test
INSERT INTO clients (nom, email, solde, statut) VALUES ('Ali Benali',    'ali@mail.ma',   1500, 'ACTIF');
INSERT INTO clients (nom, email, solde, statut) VALUES ('Sara Idrissi',  'sara@mail.ma',  250,  'ACTIF');
INSERT INTO clients (nom, email, solde, statut) VALUES ('Omar Tazi',     'omar@mail.ma',  0,    'INACTIF');
INSERT INTO clients (nom, email, solde, statut) VALUES ('Nadia Haddad', 'nadia@mail.ma', 3200, 'PREMIUM');

INSERT INTO produits (libelle, prix, stock, categorie) VALUES ('Laptop HP', 8500, 15, 'INFORMATIQUE');
INSERT INTO produits (libelle, prix, stock, categorie) VALUES ('Souris sans fil', 120, 80, 'INFORMATIQUE');
INSERT INTO produits (libelle, prix, stock, categorie) VALUES ('Clavier mécanique', 350, 45, 'INFORMATIQUE');
INSERT INTO produits (libelle, prix, stock, categorie) VALUES ('Écran 24 pouces', 2200, 10, 'INFORMATIQUE');
INSERT INTO produits (libelle, prix, stock, categorie) VALUES ('Livre Oracle PL/SQL', 180, 30, 'LIVRE');

COMMIT;
/
