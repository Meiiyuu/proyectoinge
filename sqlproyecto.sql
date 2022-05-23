-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.3
-- PostgreSQL version: 13.0
-- Project Site: pgmodeler.io
-- Model Author: ---

-- Database creation must be performed outside a multi lined SQL file. 
-- These commands were put in this file only as a convenience.
-- 
-- object: new_database | type: DATABASE --
-- DROP DATABASE IF EXISTS new_database;
CREATE DATABASE new_database;
-- ddl-end --


-- object: public.caso | type: TABLE --
-- DROP TABLE IF EXISTS public.caso CASCADE;
CREATE TABLE public.caso (
	id integer NOT NULL,
	fecha_reporte date NOT NULL,
	fecha_notificacion date NOT NULL,
	fecha_inicio_sintomas date,
	fecha_muerte date,
	fecha_diagnostico date,
	fecha_recuperacion date,
	edad smallint NOT NULL,
	id_grupo_etnia smallint,
	id_estado smallint,
	codigo_municipio_ubicacion numeric,
	id_medida_edad smallint,
	id_genero smallint,
	CONSTRAINT caso_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.caso OWNER TO postgres;
-- ddl-end --

-- object: public.ubicacion | type: TABLE --
-- DROP TABLE IF EXISTS public.ubicacion CASCADE;
CREATE TABLE public.ubicacion (
	codigo_municipio numeric NOT NULL,
	nombre_municipio varchar(40) NOT NULL,
	CONSTRAINT ubicacion_pk PRIMARY KEY (codigo_municipio)

);
-- ddl-end --
ALTER TABLE public.ubicacion OWNER TO postgres;
-- ddl-end --

-- object: public.estado | type: TABLE --
-- DROP TABLE IF EXISTS public.estado CASCADE;
CREATE TABLE public.estado (
	id smallint NOT NULL,
	id_estado_final smallint,
	id_localizacion smallint,
	id_tipo_contagio smallint,
	id_estado_durante smallint,
	CONSTRAINT estado_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.estado OWNER TO postgres;
-- ddl-end --

-- object: public.etnia | type: TABLE --
-- DROP TABLE IF EXISTS public.etnia CASCADE;
CREATE TABLE public.etnia (
	id_grupo smallint NOT NULL,
	nombre_grupo_etnico varchar(40),
	codigo_pertenencia_etnia smallint,
	CONSTRAINT etnia_pk PRIMARY KEY (id_grupo)

);
-- ddl-end --
ALTER TABLE public.etnia OWNER TO postgres;
-- ddl-end --

-- object: etnia_fk | type: CONSTRAINT --
-- ALTER TABLE public.caso DROP CONSTRAINT IF EXISTS etnia_fk CASCADE;
ALTER TABLE public.caso ADD CONSTRAINT etnia_fk FOREIGN KEY (id_grupo_etnia)
REFERENCES public.etnia (id_grupo) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.estado_durante | type: TABLE --
-- DROP TABLE IF EXISTS public.estado_durante CASCADE;
CREATE TABLE public.estado_durante (
	id smallint NOT NULL,
	estado_durante varchar(20) NOT NULL,
	CONSTRAINT estado_durante_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.estado_durante OWNER TO postgres;
-- ddl-end --

-- object: public.estado_final | type: TABLE --
-- DROP TABLE IF EXISTS public.estado_final CASCADE;
CREATE TABLE public.estado_final (
	id smallint NOT NULL,
	estado_final varchar(20) NOT NULL,
	CONSTRAINT estado_final_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.estado_final OWNER TO postgres;
-- ddl-end --

-- object: public.localizacion | type: TABLE --
-- DROP TABLE IF EXISTS public.localizacion CASCADE;
CREATE TABLE public.localizacion (
	id smallint NOT NULL,
	localizacion varchar(20) NOT NULL,
	CONSTRAINT localizacion_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.localizacion OWNER TO postgres;
-- ddl-end --

-- object: public.tipo_contagio | type: TABLE --
-- DROP TABLE IF EXISTS public.tipo_contagio CASCADE;
CREATE TABLE public.tipo_contagio (
	id smallint NOT NULL,
	tipo_contagio varchar(20) NOT NULL,
	CONSTRAINT tipo_contagio_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.tipo_contagio OWNER TO postgres;
-- ddl-end --

-- object: estado_final_fk | type: CONSTRAINT --
-- ALTER TABLE public.estado DROP CONSTRAINT IF EXISTS estado_final_fk CASCADE;
ALTER TABLE public.estado ADD CONSTRAINT estado_final_fk FOREIGN KEY (id_estado_final)
REFERENCES public.estado_final (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: localizacion_fk | type: CONSTRAINT --
-- ALTER TABLE public.estado DROP CONSTRAINT IF EXISTS localizacion_fk CASCADE;
ALTER TABLE public.estado ADD CONSTRAINT localizacion_fk FOREIGN KEY (id_localizacion)
REFERENCES public.localizacion (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: tipo_contagio_fk | type: CONSTRAINT --
-- ALTER TABLE public.estado DROP CONSTRAINT IF EXISTS tipo_contagio_fk CASCADE;
ALTER TABLE public.estado ADD CONSTRAINT tipo_contagio_fk FOREIGN KEY (id_tipo_contagio)
REFERENCES public.tipo_contagio (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: estado_durante_fk | type: CONSTRAINT --
-- ALTER TABLE public.estado DROP CONSTRAINT IF EXISTS estado_durante_fk CASCADE;
ALTER TABLE public.estado ADD CONSTRAINT estado_durante_fk FOREIGN KEY (id_estado_durante)
REFERENCES public.estado_durante (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: estado_fk | type: CONSTRAINT --
-- ALTER TABLE public.caso DROP CONSTRAINT IF EXISTS estado_fk CASCADE;
ALTER TABLE public.caso ADD CONSTRAINT estado_fk FOREIGN KEY (id_estado)
REFERENCES public.estado (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: ubicacion_fk | type: CONSTRAINT --
-- ALTER TABLE public.caso DROP CONSTRAINT IF EXISTS ubicacion_fk CASCADE;
ALTER TABLE public.caso ADD CONSTRAINT ubicacion_fk FOREIGN KEY (codigo_municipio_ubicacion)
REFERENCES public.ubicacion (codigo_municipio) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.pertenencia_etnia | type: TABLE --
-- DROP TABLE IF EXISTS public.pertenencia_etnia CASCADE;
CREATE TABLE public.pertenencia_etnia (
	codigo smallint NOT NULL,
	nombre_etnia varchar(20) NOT NULL,
	CONSTRAINT pertenencia_etnia_pk PRIMARY KEY (codigo)

);
-- ddl-end --
ALTER TABLE public.pertenencia_etnia OWNER TO postgres;
-- ddl-end --

-- object: pertenencia_etnia_fk | type: CONSTRAINT --
-- ALTER TABLE public.etnia DROP CONSTRAINT IF EXISTS pertenencia_etnia_fk CASCADE;
ALTER TABLE public.etnia ADD CONSTRAINT pertenencia_etnia_fk FOREIGN KEY (codigo_pertenencia_etnia)
REFERENCES public.pertenencia_etnia (codigo) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.genero | type: TABLE --
-- DROP TABLE IF EXISTS public.genero CASCADE;
CREATE TABLE public.genero (
	id smallint NOT NULL,
	sexo varchar(1) NOT NULL,
	CONSTRAINT genero_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.genero OWNER TO postgres;
-- ddl-end --

-- object: public.medida_edad | type: TABLE --
-- DROP TABLE IF EXISTS public.medida_edad CASCADE;
CREATE TABLE public.medida_edad (
	id smallint NOT NULL,
	unidad_medida varchar(15) NOT NULL,
	CONSTRAINT medida_edad_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.medida_edad OWNER TO postgres;
-- ddl-end --

-- object: medida_edad_fk | type: CONSTRAINT --
-- ALTER TABLE public.caso DROP CONSTRAINT IF EXISTS medida_edad_fk CASCADE;
ALTER TABLE public.caso ADD CONSTRAINT medida_edad_fk FOREIGN KEY (id_medida_edad)
REFERENCES public.medida_edad (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: genero_fk | type: CONSTRAINT --
-- ALTER TABLE public.caso DROP CONSTRAINT IF EXISTS genero_fk CASCADE;
ALTER TABLE public.caso ADD CONSTRAINT genero_fk FOREIGN KEY (id_genero)
REFERENCES public.genero (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- carga masiva de los datos
COPY pertenencia_etnia FROM 'C:\csv\pertenencia_etnia.csv' WITH delimiter ';' CSV HEADER;
COPY etnia FROM 'C:\csv\etnia.csv' WITH delimiter ';' CSV HEADER;
COPY localizacion FROM 'C:\csv\localizacion.csv' WITH delimiter ';' CSV HEADER;
COPY tipo_contagio FROM 'C:\csv\tipo_contagio.csv' WITH delimiter ';' CSV HEADER;
COPY estado_final FROM 'C:\csv\estado_final.csv' WITH delimiter ';' CSV HEADER;
COPY estado_durante FROM 'C:\csv\estado_durante.csv' WITH delimiter ';' CSV HEADER;
COPY estado FROM 'C:\csv\estado.csv' WITH delimiter ';' CSV HEADER;
COPY medida_edad FROM 'C:\csv\medida_edad.csv' WITH delimiter ';' CSV HEADER;
COPY genero FROM 'C:\csv\genero.csv' WITH delimiter ';' CSV HEADER;
COPY ubicacion FROM 'C:\csv\ubicacion.csv' WITH delimiter ';' CSV HEADER;
COPY caso FROM 'C:\csv\caso.csv' WITH delimiter ';' CSV HEADER;

