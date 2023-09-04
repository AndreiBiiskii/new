-- Название и продолжительность самого длительного трека.
SELECT title, duration  FROM track t 
WHERE duration = (SELECT max(duration) FROM track t2 );

-- Название треков, продолжительность которых не менее 3,5 минут.
SELECT title FROM track t 
WHERE duration / 60 > 3.5;

-- Названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT name FROM compilation c 
WHERE date_create BETWEEN '2018-01-01' AND '2020-12-31';

-- Исполнители, чьё имя состоит из одного слова.
SELECT name FROM singer s 
WHERE POSITION (' ' IN s.name) = 0;

-- Название треков, которые содержат слово «мой» или «my».
SELECT title FROM track t 
WHERE upper(title) LIKE '%MY%' OR upper(title) LIKE '%МОЙ%';

--Количество исполнителей в каждом жанре.
SELECT g.name, count(*) FROM singergenre s
LEFT JOIN genre g ON g.genre_id = s.genre_id 
GROUP BY g.name ; 

-- Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT a.date_create, count(*) FROM track t 
LEFT JOIN album a ON a.album_id = t.album_id 
WHERE a.date_create BETWEEN '2019-01-01' AND '2020-12-31'
GROUP BY a.date_create;

-- Средняя продолжительность треков по каждому альбому.
SELECT a.album_id , count(*) FROM track t 
LEFT JOIN album a ON a.album_id = t.album_id 
GROUP BY a.album_id;
 
-- Средняя продолжительность треков по каждому альбому.
SELECT a.album_id , avg(duration) FROM track t 
LEFT JOIN album a ON a.album_id = t.album_id 
GROUP BY a.album_id;

-- Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT name FROM singer s 
WHERE name NOT IN 
    (SELECT s2.name FROM singer s2 
    LEFT JOIN singeralbum s3 ON s2.singer_id = s3.singer_id
    LEFT JOIN album a ON a.album_id = s3.album_id
    WHERE a.date_create BETWEEN '2020-01-01' AND '2020-12-31');
    




















