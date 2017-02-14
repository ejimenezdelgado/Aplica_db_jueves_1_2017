CREATE DATABASE clase3;

CREATE SCHEMA empleado;
CREATE SCHEMA inventario;
CREATE SCHEMA facturacion;
CREATE SCHEMA recursos_humanos;
--SET search_path TO public;
CREATE TABLE empleado.clientes
(
  id serial NOT NULL,
  cc character varying(10) NOT NULL,
  nombre character varying(50) NOT NULL,
  CONSTRAINT clientes_pkey PRIMARY KEY (id)
);
CREATE TABLE inventario.clientes
(
  id serial NOT NULL,
  cc character varying(10) NOT NULL,
  nombre character varying(50) NOT NULL,
  CONSTRAINT clientes_pkey PRIMARY KEY (id)
);



