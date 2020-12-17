# 2
use albums_db;

# 3 
describe albums;

# 4
# a: inclds AS(alias) to rename column
select name AS "Pink Floyd's Albums"
from albums
where artist = 'Pink Floyd';

# b
select release_date
from albums
where name = 'Sgt. Pepper''s lonely Hearts Club Band';

#  c 
select genre
from albums
where name = 'Nevermind';

# d 
select *
from albums
where release_date between '1990-01-01' and '1999-12-31';

select artist,
       name
from albums
where release_date between '1990' and '1999';

select *
from albums
where release_date LIKE '199%';

select name
from albums
where release_date >= '1990' and release_date <= '1999';

# e 
select *
from albums
where sales < 20;

select name
from albums
where sales < 20;


# f: Does not incld Hard Rock or progressive rock bc I specifically asked for Rock only.
select *
from albums
where genre = 'Rock';

select name, 
       genre
from albums
where genre LIKE '%Rock%';




select *
from albums
LIMIT 5;

SELECT DISTINCT release_date
from albums;

SELECT artist
FROM albums
WHERE artist LIKE 'a%';