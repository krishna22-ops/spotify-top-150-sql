-- Artists appearing multiple times in artists table (same name) --
select artist_name, count(*)
from artists
group by artist_name
having count(*) > 1;

-- Tracks with duplicate (artist_id, track_name) -- 
select artist_id, track_name, count(*)
from tracks
group by artist_id, track_name
having count(*) > 1;

-- Verify ‘Taylor Swift’ query returns only her tracks --
select distinct a.artist_name
from tracks t
join artists a on t.artist_id = a.artist_id
where a.artist_name = 'Taylor Swift';

-- Every genre Dua Lipa appears in --
select distinct artist_id
from track_genres tg
join tracks t on tg.track_id = t.track_id
where t.artist_id = 108;

-- Tracks longer than 4 min really exceed 240000 ms--
select track_id, duration_ms
from tracks
where duration_ms <= 240000
  and track_id in (
        select track_id
        from tracks
        where duration_ms > 240000);