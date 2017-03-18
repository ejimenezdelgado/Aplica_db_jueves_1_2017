CREATE DATABASE db_banco;


CREATE TABLE cuenta_corriente(id_cliente serial NOT NULL,
                                                nombre_cliente varchar(30) NOT NULL,
                                                                           monto numeric NOT NULL,
                                                                                         CONSTRAINT pk_cuenta_corriente PRIMARY KEY (id_cliente));


CREATE TABLE cuenta_ahorros(id_cliente serial NOT NULL,
                                              nombre_cliente varchar(30) NOT NULL,
                                                                         monto numeric NOT NULL,
                                                                                       CONSTRAINT pk_cuenta_ahorros PRIMARY KEY (id_cliente));


CREATE TABLE bitacora(id_bitacora serial NOT NULL,
                                         tiempo TIME WITH TIME ZONE,
                                                               descripcion varchar(150),
                                                                           CONSTRAINT pk_log PRIMARY KEY (id_bitacora));


-------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION transaccion() RETURNS TRIGGER
AS
$$
  DECLARE nombre_tabla VARCHAR(20);
BEGIN
  nombre_tabla := TG_TABLE_NAME;
  RAISE NOTICE 'Trigger llamado en % antes de un %',TG_TABLE_NAME, TG_OP;
  IF (TG_OP = 'INSERT') THEN
	INSERT INTO bitacora(tiempo,descripcion)
	VALUES (NOW(),'Nuevo cliente agregado a la tabla: '||nombre_tabla);
	RETURN NEW;
  END IF;

  IF (TG_OP = 'UPDATE') THEN
     IF (NEW.monto <0) THEN 
         RAISE NOTICE 'Monto invalido,no se aceptan negativos';
     END IF;
     IF (NEW.monto !=OLD.monto) THEN
         INSERT INTO bitacora(tiempo,descripcion)
	 VALUES (NOW(),'Monto de la cuenta actulizado tabla:'|| 
                 nombre_tabla ||' '||'Cliente: '||OLD.nombre_cliente ||
                 'Monto anterior: '|| OLD.monto || 'Monto nuevo: ' ||
                 NEW.monto);
	 RETURN NEW;
     END IF;		 
  END IF;
END
$$
LANGUAGE 'plpgsql'

CREATE TRIGGER tr_cuenta_corriente
BEFORE INSERT OR UPDATE OR DELETE 
ON cuenta_corriente
FOR EACH ROW
EXECUTE PROCEDURE transaccion();

--Prueba 1
INSERT INTO cuenta_corriente VALUES ('2','Maria Jose Salas', 1000);
