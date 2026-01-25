--OBTENER LOS 5 PRIMEROS ESTUDIANTES
SELECT TOP 5 * 
FROM platzi_alumnos

--OBTENER LA SEGUNDA COLEGIATURA AMS CARA
SELECT * FROM platzi_alumnos 
WHERE colegiatura =(
    --salta los duplicados en mi ejemplo seria  5000
    SELECT DISTINCT colegiatura
    FROM platzi_alumnos
    ORDER BY colegiatura DESC
    OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY
)

--segundo modo de hacerlo 
SELECT  * 
FROM (
    SELECT *,
           DENSE_RANK() OVER (ORDER BY colegiatura DESC) AS rk
    FROM platzi_alumnos
) t
WHERE rk = 2;


--OBTENER LA MITAD DE TODOS LOS DATOS 
SELECT TOP (50) PERCENT *
FROM platzi_alumnos
ORDER BY id;

--segundo metodo
WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY id) AS rn,
           COUNT(*) OVER () AS total
    FROM platzi_alumnos
)
SELECT *
FROM cte
WHERE rn <= total / 2;


--OBTENER ID ESPECIFICOS
SELECT * FROM platzi_alumnos 
WHERE id IN (1,2)