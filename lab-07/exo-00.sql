-- Setup: Create tables and insert test data
DROP TABLE lignes_commande  CASCADE CONSTRAINTS;
DROP TABLE commandes        CASCADE CONSTRAINTS;
DROP TABLE produits         CASCADE CONSTRAINTS;
DROP TABLE CATEGORIES       CASCADE CONSTRAINTS;
DROP TABLE clients          CASCADE CONSTRAINTS;
DROP TABLE fournisseurs     CASCADE CONSTRAINTS;
DROP MATERIALIZED VIEW mv_ventes_cat;

-- CATEGORIES
CREATE TABLE categories (
  cat_id    NUMBER(4)    PRIMARY KEY,
  libelle   VARCHAR2(40) NOT NULL,
  rayon     VARCHAR2(30)
);

-- FOURNISSEURS
CREATE TABLE fournisseurs (
  fourn_id  NUMBER(6)    PRIMARY KEY,
  nom       VARCHAR2(60) NOT NULL,
  pays      VARCHAR2(30) DEFAULT 'Maroc',
   actif     CHAR(1)      DEFAULT 'O'
);

-- PRODUITS
CREATE TABLE produits (
  prod_id   NUMBER(8)    PRIMARY KEY,
  libelle   VARCHAR2(100) NOT NULL,
  cat_id    NUMBER(4)    REFERENCES categories(cat_id),
  fourn_id  NUMBER(6)    REFERENCES fournisseurs(fourn_id),
  prix_ht   NUMBER(10,2) NOT NULL,
  stock     NUMBER(6)    DEFAULT 0
);

-- CLIENTS
CREATE TABLE clients (
  client_id NUMBER(8)    PRIMARY KEY,
  nom       VARCHAR2(60) NOT NULL,
  ville     VARCHAR2(40),
  email     VARCHAR2(80) UNIQUE,
  segment   VARCHAR2(20) DEFAULT 'STANDARD'
);

-- COMMANDES
CREATE TABLE commandes (
  cmd_id    NUMBER(10)   PRIMARY KEY,
  client_id NUMBER(8)    REFERENCES clients(client_id),
  date_cmd  DATE         DEFAULT SYSDATE,
  statut    VARCHAR2(20) DEFAULT 'OUVERTE'
);

-- LIGNES DE COMMANDE
CREATE TABLE lignes_commande (
  ligne_id  NUMBER(12)   PRIMARY KEY,
  cmd_id    NUMBER(10)   REFERENCES commandes(cmd_id),
  prod_id   NUMBER(8)    REFERENCES produits(prod_id),
  qte       NUMBER(6)    NOT NULL,
  prix_unit NUMBER(10,2) NOT NULL
);

-- Données
INSERT INTO categories VALUES(1,'Informatique','High-Tech');
INSERT INTO categories VALUES(2,'Bureautique','Bureau');
INSERT INTO categories VALUES(3,'Réseau','High-Tech');
INSERT INTO categories VALUES(4,'Mobilier','Bureau');

INSERT INTO fournisseurs VALUES(1,'TechMaroc SA','Maroc','O');
INSERT INTO fournisseurs VALUES(2,'ElecroSupply','France','O');
INSERT INTO fournisseurs VALUES(3,'OfficeGlobal','Espagne','N');

INSERT INTO produits VALUES(1,'Laptop HP 15',1,1,8500,20);
INSERT INTO produits VALUES(2,'Clavier mécanique',1,1,350,80);
INSERT INTO produits VALUES(3,'Souris sans fil',1,2,120,150);
INSERT INTO produits VALUES(4,'Switch 24 ports',3,2,2200,15);
INSERT INTO produits VALUES(5,'Câble RJ45 (lot)',3,1,45,500);
INSERT INTO produits VALUES(6,'Bureau ergonomique',4,3,3200,10);
INSERT INTO produits VALUES(7,'Chaise de bureau',4,3,1800,25);
INSERT INTO produits VALUES(8,'Imprimante laser',2,2,1600,30);

INSERT INTO clients VALUES(1,'Karim Alaoui','Casablanca','k.alaoui@mail.ma','PREMIUM');
INSERT INTO clients VALUES(2,'Sara Idrissi','Rabat','s.idrissi@mail.ma','STANDARD');
INSERT INTO clients VALUES(3,'OCP Achats','Khouribga','achat@ocp.ma','ENTREPRISE');
INSERT INTO clients VALUES(4,'Leila Mansouri','Marrakech','l.mansouri@mail.ma','STANDARD');

INSERT INTO commandes VALUES(1001,1,SYSDATE-10,'LIVREE');
INSERT INTO commandes VALUES(1002,2,SYSDATE-5,'OUVERTE');
INSERT INTO commandes VALUES(1003,3,SYSDATE-2,'OUVERTE');
INSERT INTO commandes VALUES(1004,1,SYSDATE,'OUVERTE');

INSERT INTO lignes_commande VALUES(1,1001,1,2,8500);
INSERT INTO lignes_commande VALUES(2,1001,3,5,120);
INSERT INTO lignes_commande VALUES(3,1002,2,3,350);
INSERT INTO lignes_commande VALUES(4,1002,8,1,1600);
INSERT INTO lignes_commande VALUES(5,1003,4,2,2200);
INSERT INTO lignes_commande VALUES(6,1003,6,1,3200);
INSERT INTO lignes_commande VALUES(7,1004,5,10,45);
INSERT INTO lignes_commande VALUES(8,1004,3,2,120);

COMMIT;
/
