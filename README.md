CREATE TABLE IF NOT EXISTS Genre(
    id serial PRIMARY KEY,
    name varchar(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS Singer(
    id serial PRIMARY KEY,
    name varchar(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS SingerGenre(
    genre_id integer REFERENCES Genre(id),
    singer_id integer REFERENCES Singer(id),
    CONSTRAINT Genre_Singer_pk PRIMARY KEY(genre_id, singer_id)
);

CREATE TABLE IF NOT EXISTS Album(
    id serial PRIMARY KEY,
    name varchar(128) NOT NULL,
    date_create date
);

CREATE TABLE IF NOT EXISTS SingerAlbum(
    album_id integer REFERENCES Album(id),
    singer_id integer REFERENCES Singer(id),
    CONSTRAINT Album_Singer_pk PRIMARY KEY(album_id, singer_id)
);

CREATE TABLE IF NOT EXISTS Track(
    id serial PRIMARY KEY,
    album_id integer NOT NULL REFERENCES Album(id),
    title varchar(255) NOT NULL,
    duration time
);

CREATE TABLE IF NOT EXISTS Compilation(
    id serial PRIMARY KEY,
    name varchar(128) NOT NULL,
    date_create date
);

CREATE TABLE IF NOT EXISTS TrackCompilation(
    track_id integer REFERENCES Track(id),
    compilation_id integer REFERENCES Compilation(id),
    CONSTRAINT Track_Compilation_pk PRIMARY KEY (track_id, compilation_id)
);
