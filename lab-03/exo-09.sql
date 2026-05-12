-- Exercise 9: CURSOR with LOOP and FETCH
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
