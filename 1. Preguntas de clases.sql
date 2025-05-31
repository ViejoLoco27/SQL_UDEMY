# Práctica de la clase día 3
#---------------------------------------------------------------------------------------¿Quién es el actor o actríz que ha participado en la mayor cantidad de series?

SELECT 
    actores.actor_id, actores.nombre, series.titulo
FROM
    actores
        JOIN
    actuaciones ON actores.actor_id = actuaciones.actor_id
		JOIN
    series ON actuaciones.serie_id = series.serie_id
ORDER BY actores.nombre;

#---------------------------------------------------------------------------------------------------------------------------------------------------- Código de COPILOT

SELECT 
    actores.actor_id,
    actores.nombre,
    COUNT(series.serie_id) AS total_series
FROM
    actores
        JOIN
    actuaciones ON actores.actor_id = actuaciones.actor_id
        JOIN
    series ON actuaciones.serie_id = series.serie_id
# En la Cláusula group by se nombran dos criterios para garantizar
# que cada actor se considere como una única entidad, evitando posibles 
# errores si existieran registros con nombres similares pero diferentes IDs.

GROUP BY actores.actor_id , actores.nombre
ORDER BY total_series DESC;

#------------------------------------------------------------------------------------------------------------------¿Cuál es la serie con rating IMDB promedio más alto?
SELECT 
    series.serie_id, series.titulo, AVG(rating_imdb) AS Rating_Promedio
FROM
    episodios
        JOIN
    series ON series.serie_id = episodios.serie_id
GROUP BY serie_id , series.titulo
limit 5;

#---------------------------------------------------------------------------------------------------------------------------------------¿Cuál es el episodio más largo?
SELECT 
    titulo, SUM(duracion) AS Duración_total
FROM
    episodios
GROUP BY titulo;

# Práctica de la clase del día 4
#-----------------------------------------------------------------------------------------------------------------¿Qué generos son más prevalentes en la tabla series?
# Pista: Genera una lista de los diferentes géneros, junto con la cantidad de series de cada uno
SELECT 
    genero, COUNT(titulo) AS conteo_titulos
FROM
    series
GROUP BY genero
ORDER BY conteo_titulos DESC;
# --------------------------------------------------------------------------------------------¿Cuáles son las tres series con IMDB y cuántos episodios tiene cada una?
# Pistas: Considera utilizar un Join  para combinar los datos de la tabla de series con la de episodios
SELECT 
    series.titulo,
    COUNT(episodios.episodio_id) AS conteo_de_episodios,
    ROUND(AVG(episodios.rating_imdb), 2) AS promedio_rating_IMDB
FROM
    series
        JOIN
    episodios ON series.serie_id = episodios.serie_id
GROUP BY series.titulo
ORDER BY promedio_rating_IMDB DESC
LIMIT 3;


#---------------------------------------------------------------------------------------¿Cuál es la duración total de todos los episodios de la serie Stranger Things?
# Pistas:Utiliza funciones de agregación como COUNT(), junto con la claúsula GROUP BY para contar series
SELECT 
    SUM(episodios.duracion) AS duración_total_episodios,
    series.titulo
FROM
    episodios
        JOIN
    series ON episodios.serie_id = series.serie_id
GROUP BY series.titulo
ORDER BY duración_total_episodios DESC;


# Práctica de la clase del día 5
# -------------------------------------------------------------------------------------------------------------------------------------------Corre una subconsulta de SQL
SELECT 
    *
FROM
    episodios
WHERE
    serie_id = (SELECT 
            serie_id
        FROM
            series
        WHERE
            titulo = 'The Office');
# -----------------------------------------------------------Utilza una subconsulta para identificar los tres géneros más populares (en función de la cantidad de series)
# -----------------------------------------------------------------------------------Para cada género, identifica titulo de la serie, año de lanzamiento y rating de IMDB

SELECT 
    series.titulo AS 'Titulo de la serie',
    series.año_lanzamiento AS 'Año de Lanzamiento',
    series.genero AS 'género',
    AVG(episodios.rating_imdb) AS 'rating promedio IMDB'
FROM
    series
        JOIN
    episodios ON series.serie_id = episodios.serie_id
WHERE
    series.genero IN (SELECT 
            genero
        FROM
            (SELECT 
                genero, COUNT(*) AS cantidad_de_series
            FROM
                series
            GROUP BY genero
            ORDER BY cantidad_de_series DESC
            LIMIT 3) AS top3)
group by
series.serie_id
order by 
'rating promedio IMDB'
