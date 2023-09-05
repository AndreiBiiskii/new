-- Название и продолжительность самого длительного трека.
SELECT title трек, duration продолжительность  FROM track t 
WHERE duration = (SELECT max(duration) FROM track t2 );

-- Название треков, продолжительность которых не менее 3,5 минут.
SELECT title трек FROM track t 
WHERE duration / 60 > 3.5;

-- Названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT name сборник FROM compilation c 
WHERE date_create BETWEEN '2018-01-01' AND '2020-12-31';

-- Исполнители, чьё имя состоит из одного слова.
SELECT name исполнитель FROM singer s 
WHERE POSITION (' ' IN s.name) = 0;

-- Название треков, которые содержат слово «мой» или «me».
SELECT title трек FROM track t 
WHERE upper(title) LIKE '%ME%' OR upper(title) LIKE '%МОЙ%';

--Количество исполнителей в каждом жанре.
SELECT g.name жанр, count(*) количество_исполнителей FROM singergenre s
LEFT JOIN genre g ON g.genre_id = s.genre_id 
GROUP BY g.name ; 

-- Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT a.date_create дата_выпуска, count(*) количество FROM track t 
LEFT JOIN album a ON a.album_id = t.album_id 
WHERE a.date_create BETWEEN '2019-01-01' AND '2020-12-31'
GROUP BY a.date_create;
 
-- Средняя продолжительность треков по каждому альбому.
SELECT a.album_id альбом, avg(duration) средняя_продолжительность FROM track t 
LEFT JOIN album a ON a.album_id = t.album_id 
GROUP BY a.album_id;

-- Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT name исполнители FROM singer s 
WHERE name NOT IN 
    (SELECT s2.name FROM singer s2 
    LEFT JOIN singeralbum s3 ON s2.singer_id = s3.singer_id
    LEFT JOIN album a ON a.album_id = s3.album_id
    WHERE a.date_create BETWEEN '2020-01-01' AND '2020-12-31');
    
-- Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами)
-- Есть подозрения, что этот подход не очень, но вроде работает, вручную подсчитал))
SELECT DISTINCT s2.name исполнитель, c.name сборник FROM compilation c 
LEFT JOIN trackcompilation t ON t.compilation_id = c.compilation_id 
LEFT JOIN track t2 ON t2.track_id = t.track_id
LEFT JOIN album a ON a.album_id = t2.album_id 
LEFT JOIN singeralbum s ON s.album_id = a.album_id 
LEFT JOIN singer s2 ON s2.singer_id = s.singer_id
WHERE s2.name = 'Rihanna';

-- Названия альбомов, в которых присутствуют исполнители более чем одного жанра.
SELECT DISTINCT a.name альбом FROM album a 
LEFT JOIN singeralbum s2 ON a.album_id = s2.album_id 
LEFT JOIN singer s3 ON s2.singer_id = s3.singer_id 
WHERE s3.singer_id IN 
(SELECT  s.singer_id   FROM singergenre s 
GROUP BY s.singer_id, s3.name 
having  count(s.genre_id) > 1); 

-- Наименования треков, которые не входят в сборники
SELECT t.title трек  FROM track t
LEFT JOIN trackcompilation t2 ON t2.track_id = t.track_id
WHERE  t2.track_id IS NULL ;

-- Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
-- Здесь чутка не понял, у меня нет привязки треков к исполнителям
SELECT DISTINCT s.name Певец, t.duration продолжительность FROM singer s 
LEFT JOIN singeralbum s2 ON s.singer_id = s2.singer_id 
LEFT JOIN track t ON s2.album_id = t.album_id 
WHERE t.duration = 
(SELECT min(duration) FROM track);

-- Названия альбомов, содержащих наименьшее количество треков
SELECT a.name альбом FROM track t
LEFT JOIN album a ON t.album_id = a.album_id 
GROUP BY a.name, t.album_id 
HAVING count(*) = (SELECT min(t.c) FROM 
(SELECT count(*) c FROM track t
GROUP BY t.album_id) t ) ; 



