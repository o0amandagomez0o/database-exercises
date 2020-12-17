use albums_db;

describe albums;

select *
from albums
where artist = 'Pink Floyd';

select release_date
from albums
where name = 'Sgt. Pepper''s lonely Hearts Club Band';

select genre
from albums
where name = 'Nevermind';

select *
from albums
where release_date between '1990-01-01' and '1999-12-31';

select *
from albums
where sales < 20;

# Does not incld Hard Rock or progressive rock bc I specifically asked for Rock only.
select *
from albums
where genre = 'Rock';

