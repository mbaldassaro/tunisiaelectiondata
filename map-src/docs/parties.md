# Political Party Results

The [textual heat map of political party results](http://fwelections.github.com/databrowser/en/political-parties) relies on two data sets: 

- [tabular data for the 3 major parties](https://github.com/fwelections/tunisia-election-data/tree/master/2011data/resultsPerParty)
- geometry for the 27 districts derived from the [delegtion shapefiles](https://github.com/fwelections/tunisia-election-data/tree/master/shapes). 

Make sure you have read the [documentation regarding installing and setting up a PostGIS-enabled database](http://github.com/fwelections/databrowser/blob/gh-pages/setup.md#data-management-and-maps) before proceeding any further.

## 1. Dissolving Delegations into Districts

Since the party data has a district-level resolution, we need to create district polygons out of [delegation polygons that we already imported](https://github.com/fwelections/tunisia-election-data/tree/master/shapes).

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

## 2. Importing party data to PostGIS

If you have not already, you will need to import the delegation shapefiles. Detailed information for importing shapefiles can be found in the [Data management + mapping section of Setup.md](http://github.com/fwelections/databrowser/blob/gh-pages/setup.md#data-processing-for-making-maps).

To import the tabular data, first set up 3 tables - one for each party (Ennahdha, CPR, and Takattoul). Run the following sql in the `psql` shell.

<pre>
create table takattoul (
	district_id int,
	district text,
	active_votes numeric,
	active_ratio numeric,
	automatic_votes numeric,
	automatic_ratio numeric,
	total_votes numeric,
	total_votes_ratio numeric
);

create table nahdha (
	district_id int,
	district text,
	active_votes numeric,
	active_ratio numeric,
	automatic_votes numeric,
	automatic_ratio numeric,
	total_votes numeric,
	total_votes_ratio numeric
);

create table cpr (
	district_id int,
	district text,
	active_votes numeric,
	active_ratio numeric,
	automatic_votes numeric,
	automatic_ratio numeric,
	total_votes numeric,
	total_votes_ratio numeric
);
</pre>

To populate the tables you just set up, run these commands from your command shell. They are labeled for your reference. 

<pre>
# Ennahdha
cat 2011data/resultsPerParty/nadha.csv | psql -d tunisia -c "COPY nadha FROM STDIN WITH DELIMITER ';' CSV HEADER"


# takattoul
cat 2011data/resultsPerParty/takattoul.csv | psql -d tunisia -c "COPY takattoul FROM STDIN WITH DELIMITER ';' CSV HEADER"

# CPR
cat 2011data/resultsPerParty/cpr.csv | psql -d tunisia -c "COPY cpr FROM STDIN WITH DELIMITER ';' CSV HEADER"
</pre>

## 3. Joining all three parties' tables

In order to see data for all three parties associated in one table, we will need to join two parties' tables together for joining the third. Thankfully the `district_id` key is consistent across tables. To join, run 

<pre>
select
	b.ratio_t,
	b.ratio_c,
	n.total_votes_ratio as ratio_n,
	n.district_id,
	n.district
from nahdha n join 
	( select 
		  t.total_votes_ratio as ratio_t,
		  c.total_votes_ratio as ratio_c,
		  c.district_id
	    from takattoul t join cpr c
	  on t.district_id = c.district_id
	) as b
on n.district_id = b.district_id;
</pre> 

In addition to joining the relevant columns into one table, this query aliases the `total_votes_ratio` column from each table as `ratio_x` where `x` is the first letter of each party's (and table's) name. It will be important to remember the naming conventions implemented now, as they will have implications at various steps downstream.


## 4. Joining spatial data to tabular data

To join the tabular data compiled in the previous to the district polygons we created earlier, run the following SQL:

<pre>
create table parties as (
	select
		g.circo_id,
		g.the_geom,
		d.district_id,
		d.district,
		d.ratio_t,
		d.ratio_n,
		d.ratio_c,
		coalesce(cast(round(d.ratio_t) as text)||'%', 'n/a') as ratio_tc,
		coalesce(cast(round(d.ratio_n) as text)||'%', 'n/a') as ratio_nc,
		coalesce(cast(round(d.ratio_c) as text)||'%', 'n/a') as ratio_cc
	from districts g left join 
	  ( select
		  b.ratio_t,
		  b.ratio_c,
		  n.total_votes_ratio as ratio_n,
		  n.district_id,
		  n.district
	  	from nahdha n join 
		  ( select 
			  t.total_votes_ratio as ratio_t,
			  c.total_votes_ratio as ratio_c,
			  c.district_id
		  	from takattoul t join cpr c
		  	on t.district_id = c.district_id
		  ) as b
		on n.district_id = b.district_id
	  ) as d
	on circo_id = d.district_id
);
</pre>

You are now ready to style your data. See the [Political Parties TileMill project](http://github.com/fwelections/databrowser/tree/gh-pages/map-src/parties) for more details.
