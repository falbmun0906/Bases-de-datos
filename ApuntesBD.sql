

-- CREAMIS LA TABLA DE DEPARTAMENTOS A NIVEL DE COLUMNA
CREATE TABLE DEPARTAMENTOS (
    ID SERIAL PRIMARY KEY,
    NOMBRE VARCHAR(50) UNIQUE NOT NULL,
    PRESUPUESTO NUMERIC(12,2) CHECK (PRESUPUESTO >0),
    FECHA_CREACION DATE DEFAULT CURRENT_DATE
);

CREATE TABLE empleados (
    ID SERIAL CONSTRAINT PK_EMPLEADOS PRIMARY KEY
    NOMBRE VARCHAR(100) NOT NULL
)

-- CREAMOS TABLA
-- A NIVEL DE TABLA PONEMOS NOMBRE DE RESTRICION

CREATE TABLE departamentos (
    id SERIAL,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT pk_departamentos2 PRIMARY KEY (id)
)

-- CREAMOS TABLA
-- Y A NIVEL DE TABLA PONEMOS NOMBRE DE RESTRICION
-- DE UNA CLAVE COMPUESTA

CREATE TABLE INCRIPCIONES (
    ID_ESTUDIANTE INT,
    ID_CURSO INT,
    FECHA_INSCRIPCION DATE DEEFAULT CURRENT_DATE,
    CONSTRAINT PK_INSCRIPCIONES PRIMARY KEY (ID_ESTUDIANTE, ID_CURSO)
);

-- BORRAR UNA TABLA (SI EXISTE) Y SUS RESTRICCIONES:

DROP TABLE IF EXISTS EMPLEADOS CASCADE;

-- MIRAR EN EL DICCIONARIO DE DATOS: EL CATALOGO DE POSTGRE

SELECT conname AS nombre_restriccion,
conrelid::regclass AS TABLA
FROM pg_constraint
WHERE contype = 'p';

-- Define unua tabla para almacenar empleaods, incluyendo una clave foránea que referencia a departamentos.
-- Este diseño permite ver cómo los empleados están organizados por departamentos.

CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    salario NUMERIC(10,2) CHECK (salario > 0),
    fecha_contratacion DATE DEFAULT CURRENT_DATE,
    departamento_id INT REFERENCES departamentos(idi) ON DELETE SET NULL,
    correo VARCHAR(100) UNIQUE CHECK (correo LIKE '%_@__%.__%'),
    CONSTRAINT salario_min CHECK (salario >= 1000)
)

-- BORRAR TABLA

DROP TABLE IF EXISTS DEPARTAMENTOS CASCADE;

CREATE TABLE DEPARTAMENTOS (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
)

-- CREOO LA TABLA EMPLEADOS A NIVEL DE COLUMNA
-- Y LE PONGO UN NOMBRE A LA RESTRICCION DE CLAVE FORANEA

CREATE TABLE EMPLEADOS (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_departamento INT CONSTRAINT fk_empleados_departamentos REFERENCES departamentos(id)
)

-- CREAMOS LA TABLA DE CURSOS:

CREATE TABLE CURSOS (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
)

-- CREAMOS LA TABLA DE MODULOS
-- CON SU CLAVE AJENA A NIVEL DE TABLA:

CREATE TABLE modulos (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    id_curso INT,
    CONSTRAINT fk_modulos_cursos FOREIGN KEY (id_curso) REFERENCES cursos(id)
)

-- CREAMOSO LA TABLA CURSOS_ESTUDIANTES
-- QUE TIENE CLAVE PRIMARIA COMPUESTA

CREATE TABLE cursos_estudiantes (
    id_estudiante INT,
    id_curso INT,
    PRIMARY KEY (id_estudiante, id_curso)
);

-- VUELVO A CREAR LA TABLA CURSOS_ESTUDIANTES
-- QUE TIENE CLAVE PRIMARIA COMPUESTA
-- PERO PONIENDOLE UN NOMBRE A LA RESTRICCION

CREATE TABLE CURSOS_ESTUDIANTES (
    id_estudiante INT,
    id_curso INT,
    CONSTRAINT PK_CURSOS_ESTUDIANTES PRIMARY KEY (id_estudiante, id_curso)
)

-- CREO AHORA LA TABLA EVALUACIONES
-- QUE TIENEN UNA CLAVE AJENA COMPUESTA APUNTANDO A LA TABLA CURSOS_ESTUDIANTES:

CREATE TABLE evaluaciones (
    id SERIAL PRIMARY KEY,
    id_estudiante INT,
    id_curso INT,
    nota DECIMAL(5,2) CHECK (nota >= 0 AND nota <= 10),
    CONSTRAINT fk_evaluaciones_cursos_estudiantes FOREIGN KEY (id_estudiante, id_curso) REFERENCES cursos_estudiantes(id_estudiante, id_curso)
);


DROP TABLE IF EXISTS DEPARTAMENTOS CASCADE;

CREATE TABLE DEPARTAMENTOS (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
)

-- Y AHORA LA TABLA EMPLEADOS CON CLAVE AJENA A DEPARTAMENTOS
-- Y CON CONFIGURACION ON DELETE Y ON UPDATE

CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_departamento INT,
    CONSTRAINT fk_empleados_departamentos FOREIGN KEY (id_departamento)
    REFERENCES departamentos(id) ON DELETE SET NULL ON UPDATE CASCADE
);

--NIDUFUCAR TABKAS A POSTERIORI

-- PRIMERO LAS CREO

CREATE TABLE CATEGORIAS (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE PRODUCTOS (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_categoria INT
);

ALTER TABLE PRODUCTOS
ADD CONSTRAINT fk_productos_categorias FOREIGN KEY (id_categoria)
REFERENCES categorias(id);

--CODIGO CON ERRORES:

CREATE TABLE ASIGNACIONES (
    empleado_id INT REFERENCES empleados(clave) ON DELETE SET NULL,
    proyeycto_i INT REFERENCES proyectos(identificador) ON DELETE CASCADE,
    horas_semana INT (horas_semana > 0 AND horas_semana <= 40),
    fecha_asignacion DATE CURRENT_DATE,
    PRIMARY KEY (emplpeado_id, proyecto,id)
)

--NUEVA COLUMNA FEC_NACIMIENTO

--ELIMINAR LA COLUMNA CORREO

-- MODIFICAR LA COLUMNA SALARIO (8,3)

-- NUEVA RESTRICCION PARA QUE LA FEC_NACIMIENTO
-- SEA MENOR A LA FEC_CONTRATACION


ALTER TABLE empleados ADD COLUMN FEC_NACIMIENTO DATE;
ALTER TABLE empleados DROP COLUMN CORREO;
ALTER TABLE empleados ALTER COLUMN SALARIO TYPE NUMERIC(8,3);
ALTER TABLE empleados ADD CONSTRAINT FEC_NACIMIENTO CHECK (FEC_NACIMIENTO < FEC_CONTRATACION);




CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_departamento INT,
    CONSTRAINT fk_empleados_departamentos FOREIGN KEY (id_departamento)
    REFERENCES departamentos(id) ON DELETE SET NULL ON UPDATE CASCADE
);

----------------------------------
------------VISTAS----------------
--------------E-------------------
-----------INDICES----------------
----------------------------------

--CREAMOS VISTA

CREATE VIEW vita_empleados_mileuros AS
SELECT salario
FROM empleados
WHERE salario >= 1000

--CREAMOS ÍNDICE

CREATE INDEX idx_nombre_empleado ON empleados(salario);

--------------------------
----- EJERCICIO PUB ------
--------------------------

DROP DATABASE IF EXISTS PUBS_PROVINCIALES_TARDE;
CREATE DATABASE PUBS_PROVINCIALES_TARDE;

DROP TABLE IF EXISTS EMPLEADO CASCADE;
CREATE TABLE EMPLEADO (
    dni_empleado CHAR(9) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    domicilio CHAR(100)
);

DROP TABLE IF EXISTS LOCALIDAD CASCADE;
CREATE TABLE LOCALIDAD (
    cod_localidad NUMERIC(3) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS PUB CASCADE;
CREATE TABLE PUB (
    cod_pub CHAR(25) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    licencia_fiscal CHAR(50) NOT NULL,
    domicilio CHAR(100),
    fecha_apertura DATE NOT NULL,
    horario CHAR(4) CHECK (horario IN ('HOR1', 'HOR2', 'HOR3')),
    cod_localidad NUMERIC(10) NOT NULL,
    CONSTRAINT fk_cod_localidad FOREIGN KEY (cod_localidad)
    REFERENCES localidad(cod_localidad) ON DELETE SET NULL ON UPDATE CASCADE
);

DROP TABLE IF EXISTS TITUTLAR CASCADE;
CREATE TABLE TITULAR (
    dni_titular CHAR(9) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    licencia_fiscal CHAR(50) NOT NULL,
    domicilio CHAR(100),
    cod_pub CHAR(25) NOT NULL,
    CONSTRAINT fk_cod_pub FOREIGN KEY (cod_pub)
    REFERENCES pub(cod_pub) ON DELETE SET NULL ON UPDATE CASCADE
);

DROP TABLE IF EXISTS EXISTENCIAS CASCADE;
CREATE TABLE EXISTENCIAS (
    cod_articulo CHAR(15) PRIMARY KEY,
    cantidad NUMERIC(3) NOT NULL,
    precio NUMERIC(5) NOT NULL,
    cod_pub CHAR(25) NOT NULL,
    CONSTRAINT fk_cod_pub FOREIGN KEY (cod_pub)
    REFERENCES pub(cod_pub) ON DELETE SET NULL ON UPDATE CASCADE
);

DROP TABLE IF EXISTS PUB_EMPLEADO CASCADE;
CREATE TABLE PUB_EMPLEADO (
    cod_pub CHAR(25),
    dni_empleado CHAR(9),
    funcion CHAR(9) CHECK (funcion IN ('CAMARERO', 'SEGURIDAD', 'LIMPIEZA')),
    CONSTRAINT pk_pubempfun PRIMARY KEY (cod_pub, dni_empleado, funcion)
);

