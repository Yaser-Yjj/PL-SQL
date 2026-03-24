DECLARE
 
BEGIN
  INSERT INTO produits (libelle, prix, stock, categorie)
  VALUES ('Casque audio', 450, 25, 'INFORMATIQUE');
  
  IF SQL%FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Casque audio inséré. Lignes : ' || SQL%ROWCOUNT);
  END IF;

  INSERT INTO produits (libelle, prix, stock, categorie)
  VALUES ('Webcam HD', 280, 40, 'INFORMATIQUE');
  DBMS_OUTPUT.PUT_LINE('Webcam insérée. Lignes : ' || SQL%ROWCOUNT);

  INSERT INTO produits (libelle, prix, stock, categorie)
  VALUES ('Hub USB 4 ports', 95, 60, 'INFORMATIQUE');
  DBMS_OUTPUT.PUT_LINE('Hub inséré. Lignes : ' || SQL%ROWCOUNT);

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('==> 3 produits insérés avec succès.');
END;
/