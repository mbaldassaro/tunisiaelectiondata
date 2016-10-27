### Actively Registered vs. Eligible Voters

Make sure you have read the [documentation regarding installing and setting up a PostGIS-enabled database](http://github.com/fwelections/databrowser/blob/gh-pages/setup.md#data-management-and-maps).

## 1. Importing data to PostGIS

This map is comprised of two datasets - [delegtion shapefiles](https://github.com/fwelections/tunisia-election-data/tree/master/shapes) and tabular [eligibility + registration data](https://github.com/fwelections/tunisia-election-data/blob/master/2011data/RegistrationDistributionPerDelegation/RegistDistibutionperDelegation.csv). To import the shapefiles see the [setup.md for instructions on importing geographic data](http://github.com/fwelections/databrowser/blob/gh-pages/setup.md#importing-geographic-data-to-postgis).

To import the tabular registration + eligibility data, first set up the table in the tunisia database. Run the following SQL to set up your table. 

<pre>
create table regis (
	district_id int,
	district text,
	delegation text, 
	actively_registred numeric,
	eligible_voters numeric,
	ratio numeric
	);
</pre>

To populate the table, run the following from your command line (not the command shell)

<pre>
	 cat path-to/2011data/RegistrationDistributionPerDelegation/RegistDistibutionperDelegation.csv | psql -d tunisia -c "COPY regis FROM STDIN WITH DELIMITER ',' CSV HEADER"
</pre>

## 2. Joining spatial data to tabular data 

Now that both datasets are in your postgres database, you need join the spatial data (the delegation shapefile) to the tabular data (the RegistDistibutionperDelegation.csv). To do this, run the following SQL.

<pre>
create table eligibility as (
	select
		a.*,
		coalesce(cast(b.actively_registred as text), 'n/a') as actively_registred,
		coalesce(cast(b.eligible_voters as text), 'n/a') as eligible_voters,
		ratio,
		coalesce(cast(round(b.ratio) as text)||'%', 'n/a') as ratio_c
	from delegations a left join regis b
	on replace(replace(lower(cast(circo_id as text)||name_deleg), ' ', ''), '-', '') = replace(replace(replace(lower(cast(district_id as text)||delegation), ' ', ''), '-', ''), '\r', '')
	order by ratio desc
);
</pre>

In addition to performing a `left join` on the geometry to preserve geometry where records from the tabular data do not match, this query reformats the `actively_registered`, `eligible_voters`, and `ratio` columns for cartographic purposes. 

- **Round** each value to the nearest integer
- **Cast** values in each column as text in order to concatenate a `%` sign.
- **Coalesce** each value and then the string 'n/a' so that NULL values are still displayed accurately and aesthetically. 

Note that only about 215 of the 270 or so records (rows) match. To get the rest of the records to match, run manual updates changing the names in only one table. 

<pre>
update regis set delegation = 'Médina' where delegation = 'Medina';
</pre>

You're now ready to style your map in TileMill. Create a new project. In TileMill create a PostGIS layer following the [online documentation](http://mapbox.com/tilemill/docs/guides/postgis-work/), specifying the `eligibility` table.

Paste in the appropriate html for the and [tooltip](http://github.com/fwelections/databrowser/blob/gh-pages/map-src/tooltip-src.html) (labeled 'eligibility')  See the [Eligibility TileMill project](http://github.com/fwelections/databrowser/tree/gh-pages/map-src/eligibility) for CartoCss styles.
