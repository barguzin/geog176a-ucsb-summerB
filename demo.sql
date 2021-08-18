-- check SRID (projection) 
select st_srid(geom) from nyc_neighborhoods nn limit 1;
-- this returns https://epsg.io/26918
-- not supported for on-the-fly rendering 

-- demo of the Spatial View in DBeaver
select name, st_transform(geom, 3857)  from nyc_subway_stations nss ;

-- simple SQL example 
SELECT name
  FROM nyc_neighborhoods
  WHERE boroname = 'Brooklyn';
 
-- another filtering funcs 
 select * 
 from nyc_neighborhoods nn 
 where boroname ilike 'bro%';

-- use wildcard string search 
-- ilike (case insensitive search)
select * 
 from nyc_neighborhoods nn 
 where boroname ilike '%kly%';

-- count the number of characters in name variable 
SELECT char_length(name)
  FROM nyc_neighborhoods
  WHERE boroname = 'Brooklyn';
  
-- count average and standard deviatiof of number of characters 
SELECT avg(char_length(name)), stddev(char_length(name))
  FROM nyc_neighborhoods
  WHERE boroname = 'Brooklyn';
  
-- let's check how geometry is handled in GIS 
 SELECT name, ST_AsText(geom)
  FROM nyc_subway_stations
  LIMIT 3;
 
 -- you can also see the geometry type in the 'geom' column
 select * 
 from nyc_streets ns 
 limit 3; 

------------------------------------
/* BASIC OPERATIONS with GEOMETRY */
------------------------------------
-- get area and perimeter of NYC ! NEIGHBORHOODS ! 
select 
	"name", st_area(geom) as n_area
from nyc_neighborhoods nn 
order by st_area(geom) desc; -- sort in descending order 

select 
	"name", st_perimeter(geom) as perim
from nyc_neighborhoods nn 
order by st_area(geom) desc; -- sort in descending order 

-- get area and perimeter of nyc ! BOROUGHS ! 
select 
	boroname, sum(st_area(geom)) as n_area
from nyc_neighborhoods nn 
group by boroname 
order by sum(st_area(geom)) desc; -- sort in descending order 

select 
	boroname, sum(st_perimeter(geom)) as perim
from nyc_neighborhoods nn 
group by boroname 
order by sum(st_perimeter(geom)) desc; -- sort in descending order

-- most geom objects are represented in WKT format 
-- https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry