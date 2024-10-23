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

--5) En la tabla ciudad agregue el campo “cp” correspondiente a Código Postal como entero de 4. 
--En la tabla equipo agregue el campo “categoria” como carácter de 1 y la restricción en
--la cual sólo puede tomar los valores “A” y “B”.
ALTER TABLE Ciudad ADD codigo_postal INT;
--agregué la columna categoria
ALTER TABLE Equipo
ADD COLUMN categoria CHAR(1)
--agregué la restriccion
ALTER TABLE Equipo
ADD CONSTRAINT check_categoria CHECK (categoria IN ('A', 'B'));

--6) actualizando Registros
UPDATE Ciudad SET codigo_postal = 4512 WHERE codigo_ciudad=300 
UPDATE Ciudad SET codigo_postal = 4600 WHERE codigo_ciudad=100 
UPDATE Ciudad SET codigo_postal = 4612 WHERE codigo_ciudad=200 
UPDATE Ciudad SET codigo_postal = 4644 WHERE codigo_ciudad=400 

UPDATE Equipo SET categoria = 'A' WHERE codigo_equipo=1 
UPDATE Equipo SET categoria = 'B' WHERE codigo_equipo=2 
UPDATE Equipo SET categoria = 'A' WHERE codigo_equipo=3 
UPDATE Equipo SET categoria = 'B' WHERE codigo_equipo=4 
UPDATE Equipo SET categoria = 'A' WHERE codigo_equipo=5 

--7) Modifique el tamaño del campo “nombre_ciudad” de carácter de 12 a carácter de 20.
ALTER TABLE Ciudad 
ALTER COLUMN nombre_ciudad TYPE VARCHAR (20)

--8) Visualice la tabla de equipo con sus correspondientes registros ordenada por el campo “categoria”
SELECT * FROM Equipo
ORDER BY categoria

--9) Borre un registro de la tabla deporte que no esté referenciado en otra tabla y borre un
--registro de la tabla deporte que si esté referenciado en otra tabla. ¿Cuáles fueron los
--resultados? Justifique su respuesta

DELETE FROM Deporte WHERE id_deporte = 4040
--Se eliminó con exito

DELETE FROM Deporte WHERE id_deporte = 3030
--Salta el siguiente error:
/*ERROR:  La llave (id_deporte)=(3030) todavía es referida desde la tabla «equipo».update o delete en «deporte» 
viola la llave foránea «equipo_id_deporte_fkey» en la tabla «equipo» 
ERROR:  update o delete en «deporte» viola la llave foránea «equipo_id_deporte_fkey» en la tabla «equipo»
Detalle: La llave (id_deporte)=(3030) todavía es referida desde la tabla «equipo».
Para que se elimine tendriamos que elminar desde la tabla Equipo donde se ubique ese id_deporte en especifico*/

--10)  Muestre los registros de campeonato cuya cantidad de entradas vendidas sea superior a 600.
SELECT * FROM Campeonato WHERE entradas_vendidas >600

--11) Muestre los campeonatos realizados entre el 03/03/2023 y el 07/03/2023 inclusive, 
--ordenadas por el código_equipo en orden descendente.
SELECT * 
FROM Campeonato 
WHERE fecha BETWEEN '03-03-2023' AND '07-03-2023'
ORDER BY codigo_equipo DESC


/*12. Muestre todos los campos de zona y equipo en una sola consulta relacionada. Realice una
segunda consulta donde no se presente repetición de campos.*/
--Primera consulta
SELECT * 
FROM Zona, Equipo;
--Segunda consulta
SELECT *
FROM Zona
JOIN Equipo ON Equipo.codigo_zona=Zona.codigo_zona

/*13. Muestre todos los campos de zona, equipo y campeonato en una sola consulta
relacionada. En el resultado de la consulta no deben existir campos repetidos.*/
SELECT *
FROM Zona
INNER JOIN Equipo ON Equipo.codigo_zona=Zona.codigo_zona
INNER JOIN Campeonato ON Equipo.codigo_equipo = Campeonato.codigo_equipo

/*14. Muestre el “codigo_zona” y el “codigo_ ciudad” con fecha 07/03/2023.*/
SELECT
	Z.codigo_zona,
	CTO.codigo_ciudad,
	CTO.fecha
FROM Zona AS Z
INNER JOIN Equipo AS E ON E.codigo_zona= Z.codigo_zona
INNER JOIN Campeonato AS CTO ON CTO.codigo_equipo = E.codigo_equipo
WHERE fecha = '07-03-2023'

--15) Utilizando subconsulta muestre el ”nombre_deporte” de los equipos con categoría “B”.
SELECT nombre_deporte 
FROM DEPORTE AS D
WHERE id_deporte IN (SELECT id_deporte FROM Equipo WHERE categoria = 'B')


/*16. Utilizando subconsulta muestre los registros de la tabla campeonato correspondiente a la
ciudad de “Ledesma”.*/
SELECT * FROM Campeonato WHERE codigo_ciudad IN (SELECT codigo_ciudad FROM Ciudad WHERE nombre_ciudad = 'Ledesma')


/*17. Utilizando subconsulta muestre los registros de la tabla campeonato correspondiente a la
“ZonaB”.*/
SELECT * FROM Campeonato WHERE codigo_equipo IN (
	SELECT codigo_equipo FROM Equipo WHERE codigo_zona IN(
		SELECT codigo_zona FROM Zona WHERE nombre_zona = 'Zona B'))


/*18. Utilizando subconsulta muestre el “codigo_equipo” y “nombre_equipo” para el deporte
“Voley” correspondiente a la “ZonaA”.*/

SELECT codigo_equipo, nombre_equipo 
FROM Equipo 
WHERE id_deporte IN (
	SELECT id_deporte FROM Deporte WHERE nombre_deporte = 'Voley') AND
	codigo_zona IN (
		SELECT codigo_zona FROM Zona WHERE nombre_zona='Zona A'
	)


19. Realice una vista denominada “v_campeonato” que muestre los datos relacionados de
equipo y ciudad.
CREATE VIEW v_campeonato  AS (
	SELECT 
		Equipo.*,
		Ciudad.*	
	FROM Equipo 
	INNER JOIN Campeonato ON Campeonato.codigo_equipo = Equipo.codigo_equipo
	INNER JOIN Ciudad ON Campeonato.codigo_ciudad = Ciudad.codigo_ciudad
)

SELECT * FROM v_campeonato

20. Cree una vista denominada “v_equipo” que muestre los datos de zona y deporte.
CREATE VIEW v_equipo AS (
	SELECT 
		Z.*,
		D.*
	FROM Equipo AS E
	INNER JOIN Zona AS Z ON Z.codigo_zona = E.codigo_zona
	INNER JOIN Deporte AS D ON D.id_deporte = E.id_deporte
)

SELECT * FROM v_equipo


21. Muestre el número de registros que contiene la tabla campeonato.
SELECT 
	COUNT(*) AS cantidad_registro 
FROM Campeonato

22. Muestre la cantidad máxima de entradas vendidas.
SELECT MAX(entradas_vendidas) AS maxima_entradas_vendidas
FROM Campeonato

23. Muestre el promedio de las entradas vendidas.
SELECT AVG(entradas_vendidas) AS promedio_entradas_vendidas FROM Campeonato


24. Muestre el importe total (Entradas Vendidas * Precio Entrada) de entradas vendidas en
todo el campeonato.
SELECT 
	SUM(entradas_vendidas * precio_entrada) AS importe_total
FROM Campeonato

25. Muestre el importe total (Entradas Vendidas * Precio Entrada) de entradas vendidas para
la ciudad de Yavi y considere aplicar un descuento del 10%.
SELECT 
	SUM(entradas_vendidas * (precio_entrada*0.90)) AS importe_total
FROM Campeonato
INNER JOIN Ciudad AS C ON C.codigo_ciudad = Campeonato.codigo_ciudad
WHERE C.nombre_ciudad = 'Yavi'


26. Muestre el importe total (Entradas Vendidas * Precio Entrada) para cada “codigo_ciudad”
ordenado de forma ascendente.
SELECT
	codigo_ciudad,
	SUM(entradas_vendidas * precio_entrada) AS importe_total
FROM Campeonato
GROUP BY codigo_ciudad
ORDER BY importe_total ASC


27. Muestre el nombre de los deportes que se practican en la “ZonaB”.
SELECT 
	D.nombre_deporte
FROM Equipo AS E
INNER JOIN Zona AS Z ON Z.codigo_zona = E.codigo_zona
INNER JOIN Deporte AS D ON D.id_deporte = E.id_deporte
WHERE Z.nombre_zona =  'Zona B'


28. Muestre la fecha de los campeonatos que se realizan en la región “Valle” y que
corresponden a la “ZonaA”.
SELECT 
	CTO.fecha
FROM Campeonato AS CTO
INNER JOIN Equipo AS E ON E.codigo_equipo = CTO.codigo_equipo
INNER JOIN Zona AS Z ON Z.codigo_zona = E.codigo_zona
INNER JOIN Ciudad AS C ON C.codigo_ciudad = CTO.codigo_ciudad
INNER JOIN Region AS R ON R.id_region = C.id_region
WHERE Z.nombre_zona =  'Zona A' AND R.nombre_region = 'Valle'

29. Utilizando subconsultas muestre el “nombre_region” en donde se practica “Voley”.
SELECT nombre_region 
FROM Region AS R
INNER JOIN Ciudad AS C ON R.id_region = C.id_region
INNER JOIN Campeonato AS CTO ON CTO.codigo_ciudad = C.codigo_ciudad
INNER JOIN Equipo AS E ON E.codigo_equipo = CTO.codigo_equipo
WHERE id_deporte IN (
	SELECT id_deporte FROM Deporte WHERE nombre_deporte = 'Voley')



30. Utilice subconsultas y muestre el nombre de los equipos que practican el deporte “Futbol”
en la ciudad de “S.S.Jujuy”.
SELECT 
	E.nombre_equipo
FROM Equipo AS E
INNER JOIN Campeonato AS CTO ON CTO.codigo_equipo = E.codigo_equipo
WHERE id_deporte IN (
	SELECT id_deporte FROM Deporte WHERE nombre_deporte='Futbol') AND 
	codigo_ciudad IN (SELECT codigo_ciudad FROM Ciudad WHERE nombre_ciudad = 'S.S. Jujuy')

31. Muestre la cantidad de entradas vendidas en la ciudad de “Yavi”.
SELECT SUM(entradas_vendidas) AS cantidad_entradas_vendidas
FROM Campeonato AS CTO
INNER JOIN Ciudad AS C ON C.codigo_ciudad = CTO.codigo_ciudad
WHERE C.nombre_ciudad = 'Yavi'

32. Muestre el total recaudado por el "Equipo1” durante todo el campeonato.
SELECT 
	SUM(entradas_vendidas * precio_entrada) AS total_recaudado
FROM Campeonato
INNER JOIN Equipo AS E ON E.codigo_equipo = Campeonato.codigo_equipo
WHERE E.nombre_equipo = 'Equipo1'

33. Muestre el nombre de la zona junto con la cantidad de deportes que se realizan en la
misma.
SELECT 
	Z.nombre_zona AS Zona,
	COUNT(D.id_deporte) AS cantidad_deportes
FROM Equipo AS E
INNER JOIN Zona AS Z ON Z.codigo_zona = E.codigo_zona
INNER JOIN Deporte AS D ON D.id_deporte = E.id_deporte
GROUP BY Z.nombre_zona
ORDER BY Z.nombre_zona ASC

34. Muestre el nombre de la ciudad junto con el importe total recaudado en el campeonato.
SELECT 
	C.nombre_ciudad,
	SUM(entradas_vendidas * precio_entrada) AS total_importe
FROM Campeonato
INNER JOIN Ciudad AS C ON C.codigo_ciudad = Campeonato.codigo_ciudad
GROUP BY C.nombre_ciudad
ORDER BY total_importe DESC

35. Muestre el nombre de la ciudad junto con la cantidad de equipos que compitieron en la
misma.
SELECT 
	C.nombre_ciudad,
	COUNT(CTO.codigo_equipo) AS cantidad_equipo
FROM Campeonato AS CTO
INNER JOIN Ciudad AS C ON C.codigo_ciudad = CTO.codigo_ciudad
GROUP BY C.nombre_ciudad