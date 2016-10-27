# All the votes that did not count

Make sure you have read the [documentation regarding installing and setting up a PostGIS-enabled database](http://github.com/fwelections/databrowser/blob/gh-pages/setup.md#data-management-and-maps) before proceeding any further.

Two datasets power this map:

- [full 2011 election results]() available as individual `.json` files, parsed and provided as a single district-level CSV. 
- geometry for the 27 districts derived from the [delegation shapefiles](https://github.com/fwelections/tunisia-election-data/tree/master/shapes).

### 1. Import data to PostGIS

To set up the a table with appropriate columns, run the following SQL: 

<pre>
create table wasted (
	cir_id int,
	circ_name text,
	total_votes numeric,
	votes_ennahdha numeric,
	votes_cpr numeric,
	votes_fdtl numeric,
	other_winning numeric,
	Wasted numeric,
	Blank_ballots numeric,
	cancelled_ballots numeric
);
</pre>

Now run the following from your command line to populate the table: 

<pre>
wasted-votes.csv | psql -d tunisia -c "COPY wasted FROM STDIN WITH DELIMITER ',' CSV HEADER"
</pre>

### 2. Update table

We want to map the total number of votes that did not count, so we need to aggregate wasted votes (those votes for parties that did not win mandates, leaving voters un-represented) with cancelled ballots, and blank ballots. 

To create and populate this new column, run the following SQL: 

<pre>
alter table wasted add column map numeric;
update wasted set map = wasted + blank_ballots + cancelled_ballots;
</pre>

### 3. Dissolving Delegations into Districts

*Note: If you have already performed this step for the Political parties map, you can skip to step 4.*

Since this data has a district-level resolution, we need to create district polygons out of [delegation polygons that we already imported](https://github.com/fwelections/tunisia-election-data/tree/master/shapes).

To do this you'll need to load the `filter_rings()` function explained in [this post](http://www.spatialdbadvisor.com/postgis_tips_tricks/92/filtering-rings-in-polygon-postgis). This  functions removes artifacts left by unioning each district's member delegations. Once you've loaded [the function](https://gist.github.com/ian29/5091516) into your database, run the following query. 

<pre>
create table districts as (
select
	circo_id,
	filter_rings(st_union(the_geom),2) as the_geom
from delegations
group by circo_id
);
</pre>

### 4. Joining to geometry 

You should now be able to open the [wasted votes tilemill project](http://github.com/fwelections/databrowser/tree/gh-pages/map-src/wasted)

We're joining the tabular data to geometry in TileMill's PostGIS plugin. The query is here for your reference, but you should need to perform any further steps. 

<pre>
( select
    the_geom,
    cir_id,
    circ_name,
    blank_ballots,
    cancelled_ballots,
    wasted,
    map,
    total_votes,
    round((map / total_votes * 100)) as pct_n,
    cast(round((map / total_votes * 100)) as text)||'%' as pct_s,
    cast(round((map / total_votes * 100)) as text)||'%'||E' \n'||circ_name as display
  from districts a join wasted b 
  on circo_id = cir_id 
) as data
</pre> 