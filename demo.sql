-- check SRID (projection) 
select st_srid(geom) from nyc_neighborhoods nn limit 1;

select st_srid(geom) from nyc_neighborhoods nn; 
-- this returns https://epsg.io/26918
-- not supported for on-the-fly rendering 

select 
	gid, blkid, popn_black, st_transform(geom, 4326)
from nyc_census_blocks ncb;

select 
	gid, blkid, popn_black, st_transform(geom, 4326) as geom_transformed
from nyc_census_blocks ncb ; 

select * from nyc_census_blocks ncb ;


-- demo of the Spatial View in DBeaver
select *, st_transform(geom, 3857)  from nyc_subway_stations nss ;

SELECT 
	gid, objectid, id, "name", alt_name, cross_st, long_name, "label", borough, nghbhd, routes, transfers, color, express, closed, st_transform(geom, 3857) as geom 
FROM public.nyc_subway_stations;


-- simple SQL example 
SELECT 
	*
FROM nyc_neighborhoods
WHERE boroname = 'Brooklyn';

-- 
select distinct boroname 
from nyc_neighborhoods nn ;
 
-- another filtering funcs 
 select * 
 from nyc_neighborhoods nn 
 where boroname like '%Bro%';

-- use wildcard string search 
-- ilike (case insensitive search)
select * 
 from nyc_neighborhoods nn 
 where boroname ilike '%kly%';

select name, st_transform(geom, 4326) 
from nyc_neighborhoods nn 
where name='Great Kills';

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

-- select all subway stations in Queens 
select 
	*
from nyc_subway_stations nss, (select * from nyc_neighborhoods where boroname = 'Queens') nn 
where st_within(nss.geom, nn.geom); 

-- count the number of subway stations in Queens 
select 
	count(*)
from nyc_subway_stations nss, (select * from nyc_neighborhoods where boroname = 'Queens') nn 
where st_within(nss.geom, nn.geom); --71

-- calculate distance between Union Tpke and Jamaica stations 
select 
	round(st_distance(t1.geom, t2.geom)::NUMERIC,2) as dist
	--st_distance(t1.geom, t2.geom) as dist
from (select * from nyc_subway_stations where name = 'Union Tpke') t1, (select * from nyc_subway_stations where name = 'Jamaica') t2 ; --2452.31


/* SPATIAL RELATIONS AND SPATIAL OPERATIONS */

-- create a view with buffers of subway stations in Queens 
create or replace view sub_queen_buff as 
select 
	nss.gid, nss.objectid , nss.id, nss.name, nss.alt_name, nss.long_name, st_buffer(st_transform(nss.geom, 3857),1000)  as geom
from nyc_subway_stations nss, (select * from nyc_neighborhoods where boroname = 'Queens') nn 
where st_within(nss.geom, nn.geom);  

-- create a union of buffers 
drop view buff_union ;
create or replace view buff_union as 
select 
	1 as gid, st_union(geom) as geom
from sub_queen_buff; 

-- another union example 
-- Create a nyc_census_counties table by merging census blocks
drop table if exists nyc_census_counties;
CREATE TABLE nyc_census_counties AS
SELECT
  ST_Union(geom)::Geometry(MultiPolygon,26918) AS geom,
  SubStr(blkid,1,5) AS countyid
FROM nyc_census_blocks
GROUP BY countyid;

-- select homicides in the buffered unions 
create or replace view queen_crime as 
select 
	nh.gid, incident_d, boroname , weapon , light_dark , nh.year, st_transform(nh.geom, 3857) as geom 
from nyc_homicides nh, buff_union bu
where st_within(st_transform(nh.geom, 3857), bu.geom);

select * from queen_crime qc ; 

-- calculate the number of crimes total 
select count(gid) from queen_crime qc; 

-- calculate the number of crimes per year 
select 
	year, count(gid) 
from queen_crime qc 
group by year; 

-- calculate the number of light/dark crimes 

-- calculate the number of crimes per weapon type 