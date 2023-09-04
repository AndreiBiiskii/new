CREATE TABLE IF NOT EXISTS Genre(
    genre_id serial PRIMARY KEY,
    name varchar(20) NOT NULL );

CREATE TABLE IF NOT EXISTS Singer(
    singer_id serial PRIMARY KEY,
    name varchar(128) NOT NULL );

CREATE TABLE IF NOT EXISTS SingerGenre(
    genre_id integer REFERENCES Genre(genre_id),
    singer_id integer REFERENCES Singer(singer_id),
    CONSTRAINT Genre_Singer_pk PRIMARY KEY(genre_id, singer_id) );

CREATE TABLE IF NOT EXISTS Album(
    album_id serial PRIMARY KEY,
    name varchar(128) NOT NULL,
    date_create date );

CREATE TABLE IF NOT EXISTS SingerAlbum(
    album_id integer REFERENCES Album(album_id),
    singer_id integer REFERENCES Singer(singer_id),
    CONSTRAINT Album_Singer_pk PRIMARY KEY(album_id, singer_id) );

CREATE TABLE IF NOT EXISTS Track(
    track_id serial PRIMARY KEY, 
    album_id integer NOT NULL REFERENCES Album(album_id),
    title varchar(255) NOT NULL, duration integer  );

CREATE TABLE IF NOT EXISTS Compilation(
compilation_id serial PRIMARY KEY,
name varchar(128) NOT NULL,
date_create date );

CREATE TABLE IF NOT EXISTS TrackCompilation(
    track_id integer REFERENCES Track(track_id),
    compilation_id integer REFERENCES Compilation(compilation_id),
    CONSTRAINT Track_Compilation_pk PRIMARY KEY (track_id, compilation_id) );
