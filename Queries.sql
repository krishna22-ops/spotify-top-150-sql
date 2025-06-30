-- All tracks by Taylor Swift -- 
select t.track_id, t.track_name, a.artist_name
from artists as a
join tracks as t 
on a.artist_id = t.artist_id
where artist_name = 'Taylor Swift'
group by t.track_id, t.track_name, a.artist_name;

-- Tracks longer than 4 mins (240000 ms) --
select t.track_name, a.artist_name, t.duration_ms
from artists as a
join tracks as t 
on a.artist_id = t.artist_id
where t.duration_ms > 240000
group by t.track_name, a.artist_name, t.duration_ms;

-- Every genre Dua Lipa is in --
select g.genre_name, a.artist_name, a.artist_id
from genres as g
join track_genres as tg
join tracks as t 
join artists as a
on t.artist_id = a.artist_id
where a.artist_id = 108
group by g.genre_name, a.artist_name, artist_id;

-- Artists with 2 or more songs --
select a.artist_name, count(*) as total_count
from artists as a
join tracks as t
on a.artist_id = t.artist_id
group by a.artist_name
having count(*) >= 2;

-- Total 2024 streams per artist --
select a.artist_name, sum(t.total_streams_2024) as total_count
from artists as a
join tracks as t
on a.artist_id = t.artist_id
group by a.artist_name;

-- Average track length in seconds for each genre --
select g.genre_name, avg(t.duration_ms) as avg_ms
from tracks as t
join track_genres as tg on tg.track_id = t.track_id
join genres as g 
on g.genre_id = tg.genre_id
group by g.genre_name;

-- Tracks released before 2020 with more than 200M streams -- 
select t.track_name, a.artist_name, t.total_streams_2024
from tracks as t
join artists as a
    on t.artist_id = a.artist_id
where t.release_date < '2020-01-01'
     and t.total_streams_2024 >= 200000000;

-- First track released by an artist -- 
select a.artist_name, t.track_name , t.release_date 
from artists as a
join tracks as t
    on a.artist_id = t.artist_id
where t.release_date = ( select min(t2.release_date) as oldest_song
                         from tracks as t2
                         where t2.artist_id = t.artist_id);
                         
--  A progression table of 2024 streams for every artist --
select a.artist_name, t.track_name, t.release_date, t.total_streams_2024,
sum(t.total_streams_2024) over(
    partition by a.artist_id
    order by t.release_date
    rows between unbounded preceding
    and current row) as running_total
from tracks as t
join artists as a 
    on t.artist_id = a.artist_id
order by a.artist_name, t.release_date;

-- Rank each artists tracks by 2024 -- 
select t.track_name,a.artist_name, t.total_streams_2024,
dense_rank() over( partition by t.artist_id
             order by t.total_streams_2024 desc) 
             as song_rank
from tracks as t
join artists as a 
on t.artist_id = a.artist_id
order by a.artist_name, song_rank;

-- Top 3 genres by total streams --
with genre_totals as (
        select g.genre_id, g.genre_name, sum(t.total_streams_2024) as total_streams_2024
        from genres as g
        join track_genres as tg 
             on g.genre_id = tg.genre_id
		join tracks as t
             on tg.track_id = t.track_id
		group by g.genre_id, g.genre_name
        )
select *
from genre_totals
order by total_streams_2024 desc
limit 3;

-- Artists whose single biggest-streaming track is also longer than three minutes --
with biggest_track as (
		select a.artist_name, t.total_streams_2024, t.duration_ms,
        row_number() over( partition by a.artist_name
                     order by t.total_streams_2024 desc) as song_rank
        from tracks as t
        join artists as a
            on t.artist_id = a.artist_id)
select *
from biggest_track
where song_rank = 1
     and duration_ms > 180000;
		
        
        
        
        
        
        
        
        
        
        
        
        
        
        