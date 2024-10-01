-- Database: TP4_Grupo06

-- DROP DATABASE IF EXISTS "TP4_Grupo06";

CREATE DATABASE "TP4_Grupo06"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Argentina.1252'
    LC_CTYPE = 'Spanish_Argentina.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
CREATE TABLE Deporte(
	id_deporte INT PRIMARY KEY,
	nombre_deporte VARCHAR(15)
)

CREATE TABLE Zona(
	codigo_zona VARCHAR(2) PRIMARY KEY,
	nombre_zona VARCHAR(15)
)

CREATE TABLE Region(
	id_region INT PRIMARY KEY,
	nombre_region VARCHAR(10)
)

CREATE TABLE Ciudad(
	codigo_ciudad INT PRIMARY KEY,
	nombre_ciudad VARCHAR(12),
	id_region INT
)

CREATE TABLE Equipo(
	codigo_equipo INT PRIMARY KEY,
	nombre_equipo VARCHAR(20),
	codigo_zona VARCHAR(2),
	id_deporte INT,
	FOREIGN KEY (id_deporte) REFERENCES Deporte(id_deporte)
)

CREATE TABLE Campeonato(
	codigo_equipo INT,
	codigo_ciudad INT,
	fecha DATE,
	entradas_vendidas INT,
	precio_entrada NUMERIC(12,2),
	PRIMARY KEY(codigo_equipo, codigo_ciudad),
	FOREIGN KEY (codigo_equipo) REFERENCES Equipo(codigo_equipo),
	FOREIGN KEY (codigo_ciudad) REFERENCES Ciudad(codigo_ciudad)
)

INSERT INTO Deporte(id_deporte, nombre_deporte) VALUES
	(1010,'Futbol'),
	(2020,'Voley'),
	(3030,'Basquet'),
	(4040,'Voley')
SELECT * FROM Deporte

INSERT INTO Zona(codigo_zona, nombre_zona) VALUES
	('AA','Zona A'),
	('BB','Zona B'),
	('CC','Zona C')
SELECT * FROM Zona


INSERT INTO Equipo(codigo_equipo, nombre_equipo,codigo_zona,id_deporte) VALUES
	(1,'Equipo1','AA',1010),
	(2,'Equipo2','BB',2020),
	(3,'Equipo3','CC',1010),
	(4,'Equipo4','AA',2020),
	(5,'Equipo5','BB',3030)
SELECT * FROM Equipo

INSERT INTO Region VALUES 
	(10,'Valle'),
	(11,'Yunga'),
	(12,'Puna')
SELECT * FROM REGION

INSERT INTO Ciudad (codigo_ciudad,nombre_ciudad,id_region) VALUES
	(100,'S.S. Jujuy',10),
	(200,'Palpalá',10),
	(300,'Ledesma',11),
	(400,'Yavi',12);
SELECT * FROM Ciudad


INSERT INTO Campeonato(codigo_equipo,codigo_ciudad,fecha,entradas_vendidas,precio_entrada) VALUES
	(1,100,'03-03-2023',500,30000.00),
	(1,200,'07-03-2023',800,20000.00),
	(2,200,'04-03-2023',200,10000.00),
	(3,100,'03-03-2023',600,15000.00),
	(4,300,'05-03-2023',400,20000.00),
	(2,400,'10-03-2023',250,5000.00),
	(5,300,'08-03-2023',350,30000.00),
	(3,400,'07-03-2023',700,15000.00)
	
SELECT * FROM Campeonato

--En la tabla ciudad agregue el campo “cp” correspondiente a Código Postal como entero de
--4. En la tabla equipo agregue el campo “categoria” como carácter de 1 y la restricción en
--la cual sólo puede tomar los valores “A” y “B”.

ALTER TABLE Ciudad ADD codigo_postal INT;

--agregué la columna categoria
ALTER TABLE Equipo
ADD COLUMN categoria CHAR(1)
--agregué la restriccion
ALTER TABLE Equipo
ADD CONSTRAINT check_categoria CHECK (categoria IN ('A', 'B'));

--MODIFICACIÓN DE TAMAÑO
ALTER TABLE Ciudad 
ALTER COLUMN nombre_ciudad TYPE VARCHAR (20)

--Visualización tabla equipo ordenada por el campo categoria
SELECT * FROM Equipo
ORDER BY categoria

--9) Eliminación de un registro referenciado en otra tabla y otro que no
DELETE FROM Deporte WHERE id_deporte = 4040
--Se eliminó con exito
DELETE FROM Deporte WHERE id_deporte = 3030
--Salta el siguiente error:
/*ERROR:  La llave (id_deporte)=(3030) todavía es referida desde la tabla «equipo».update o delete en «deporte» 
viola la llave foránea «equipo_id_deporte_fkey» en la tabla «equipo» 
ERROR:  update o delete en «deporte» viola la llave foránea «equipo_id_deporte_fkey» en la tabla «equipo»
Estado SQL: 23503
Detalle: La llave (id_deporte)=(3030) todavía es referida desde la tabla «equipo».*/

--10) Mostrar registros de campeonato donde la cantidad de entradas vendidas sea superior a 600
SELECT * FROM Campeonato WHERE entradas_vendidas >600

--11)
SELECT * 
FROM Campeonato 
WHERE fecha BETWEEN '03-03-2023' AND '07-03-2023'
ORDER BY codigo_equipo DESC



--Mostrar todos los campos de region y ciudad
select 
	ciudad.*,
	nombre_region
	
from region 
inner join ciudad on region.id_region = ciudad.id_region 

--Muestre los campeonatos que se realizaron en la region Valle
SELECT 
	Campeonato.*,
	Region.nombre_region
FROM Campeonato
INNER JOIN Ciudad ON Campeonato.codigo_ciudad = Ciudad.codigo_ciudad
INNER JOIN Region ON Ciudad.id_region = Region.id_region
WHERE Region.nombre_region = 'Valle'

--Muestre el nombre de los equipos que practican futbol y pertenecen a la zonaB
SELECT 
	E.nombre_equipo,
	D.nombre_deporte,
	Z.nombre_zona
FROM Equipo AS E
INNER JOIN Zona AS Z ON E.codigo_zona = Z.codigo_zona
INNER JOIN Deporte AS D ON E.id_deporte = D.id_deporte
WHERE  D.nombre_deporte='Futbol' AND Z.nombre_zona = 'Zona B'
--No hay equipo que cumplan con ambas consignas


--Usando Subconsultas muestre las fechas en donde se vendieron menos cantidad de entradas que el promedio
SELECT
	fecha,
	entradas_vendidas
FROM Campeonato
WHERE 
	entradas_vendidas < (SELECT AVG(entradas_vendidas) FROM Campeonato)
	
-- " 	" 	muestre el nombre de las ciudades en donde se vendieron más entradas que el promedio
SELECT
	nombre_ciudad,
	entradas_vendidas
FROM Ciudad AS C
INNER JOIN Campeonato AS CTO ON CTO.codigo_ciudad = C.codigo_ciudad
WHERE entradas_vendidas > (SELECT AVG(entradas_vendidas) FROM Campeonato)


--2da manera más eficiente
SELECT 	nombre_ciudad FROM Ciudad WHERE codigo_ciudad IN ( --Pongo IN cuando me puede devolver un conjunto de resultados
	SELECT codigo_ciudad FROM Campeonato WHERE entradas_vendidas > (
		SELECT AVG(entradas_vendidas) FROM Campeonato))


--Muestre el nombre de la ciudad  que pertenece a la region valle y donde se haya realizado un campeonato en fecha 07-03-2023
SELECT 
	nombre_ciudad
FROM Ciudad
WHERE id_region = (
	SELECT id_region FROM Region WHERE nombre_region='Valle') --Pongo igual cuando solo me puede devolver un valor
	AND codigo_ciudad IN (
		SELECT codigo_ciudad FROM Campeonato WHERE fecha='07-03-2023')
		
		
--Muestre la cantidad de entradas vendidas en cada ciudad
SELECT 
	C.nombre_ciudad,
	SUM(CTO.entradas_vendidas) AS Entradas_Vendidas
FROM Ciudad AS C
INNER JOIN Campeonato AS CTO ON CTO.codigo_ciudad = C.codigo_ciudad
GROUP BY C.nombre_ciudad 
ORDER BY SUM(CTO.entradas_vendidas) DESC

--Muestre la cantidad de ciudades que tiene la region Valle
SELECT
	COUNT(C.codigo_ciudad) AS cantidad_ciudad_valle	
FROM Ciudad AS C
INNER JOIN Region AS R ON C.id_region = R.id_region
WHERE R.nombre_region = 'Valle'

-- Muestre la cantidad de campeonatos que se jugaron en la zona A
SELECT COUNT(CTO.*) AS cantidad_campeonato
FROM Campeonato AS CTO
INNER JOIN Equipo AS E ON E.codigo_equipo = CTO.codigo_equipo
INNER JOIN Zona AS Z ON E.codigo_zona = Z.codigo_zona
WHERE Z.nombre_zona= 'Zona A'

-- muestre lo recaudado en el dia del 07-03-2023

CREATE VIEW recaudado_dia(
SELECT SUM(precio_entrada*entradas_vendidas) AS Recaudado FROM Campeonato
WHERE fecha = '07-03-2023'

-- Crea una vista, que muestre el nombre de la ciudad junto con la fecha que se realizaron los campeonatos 
CREATE VIEW v_ciudadcampeonato AS(
	SELECT 
		C.nombre_ciudad,
		CTO.fecha
	FROM Campeonato AS CTO
	INNER JOIN Ciudad AS C ON CTO.codigo_ciudad=C.codigo_ciudad
)
--Ejecución
SELECT * FROM v_ciudadcampeonato