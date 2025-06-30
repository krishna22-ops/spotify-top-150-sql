create table artists (artist_id int primary key,
                      artist_name varchar(50),
                      country varchar(50));
                      
create table tracks (track_id int primary key, 
                     track_name varchar(50),
                     artist_id int,
                     album varchar(50),
                     release_date date,
                     duration_ms int,
                     total_streams_2024 int,
                     foreign key (artist_id) references artists(artist_id));
                     
create table genres (genre_id int primary key,
                     genre_name varchar(50));
                     
drop table if exists track_genres;

create table track_genres (
    track_id  int,
    genre_id  int,
    primary key(track_id, genre_id),
    foreign key (track_id) references tracks(track_id),
    foreign key (genre_id) references genres(genre_id)
);

                            