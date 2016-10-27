# Votes Canceled at Counting

The map of [where cancelled votes came from](http://fwelections.github.com/databrowser/en/canceled-during-counting/) relies on polling center data available as [individual `.json` files](https://github.com/fwelections/tunisia-election-data/tree/master/fulldatasets/results) that were provided as a two CSV tables 

- one containing latitude + longitude coordinates and 
- one containing detailed election data. 

NOTE: only 588 out of the 4,800 or so polling centers are currently visualized on the map. While election data has been collected for virtually all polling centers, location data (lat/lon coordinates) has only been collected for 588 polling centers. 

Make sure you have read the [documentation regarding installing and setting up a PostGIS-enabled database](http://github.com/fwelections/databrowser/blob/gh-pages/setup.md#data-management-and-maps) before proceeding any further.

## 1. Import data to PostGIS 

To set up the election data table run the following SQL: 

<pre>
create table results (
	circonscription_name text,
	circonscription_isieid int,
	delegation_name text,
	delegation_isieid int,
	centre_name text,
	centre_isieid int,
	bureau_name text,
	bureau_isieid numeric,
	registred_voters numeric,
	total_voters numeric,
	extracted_ballots numeric,
	delivered_ballots numeric,
	white_ballots numeric,
	not_used_ballots numeric,
	cancelled_ballots numeric,
	damaged_ballots numeric,
	valid_ballots numeric,
	list_name text,
	list_rank numeric,
	votes numeric,
	percentage numeric
);
</pre>

If you've parsed the `.json` files into a CSV you can import that CSV data by running the command 

<pre>
cat eligible_voters 2011data/election-results.csv | psql -d tunisia -c "COPY results FROM STDIN WITH DELIMITER ',' CSV HEADER"
</pre>

We set up a separate table for the geometry with the following schema:

<pre>
create table pc (
	district_name_ar text,
	delegation_name_ar text,
	polling_center_name_ar text,
	latitude numeric,
	longitude numeric,
	contact text
	);
</pre>

<pre>
cat shapes/polling_centers_tunisia.csv | psql -d tunisia -c "COPY pc FROM STDIN WITH DELIMITER ',' CSV HEADER"
</pre>

### 2. Aggregate Polling Center data + join to geometry 

The data is structured so that each record (row) represents a party on the ballot at each polling center. To effectively show how many ballots were cancelled at each polling center, we need to

- aggregate this data into statistics for each polling center. In addition to aggregating this data
- join to lat/lon data
- create a unique polling center id

This can be accomplished with the following query.

<pre>
create table pc_results as (
	select 
		a.district_name_ar,
 		a.delegation_name_ar,
 		a.polling_center_name_ar,
 		a.latitude,
 		a.longitude,
 		a.contact,
		b.circonscription_name,
		b.circonscription_isieid,
		b.delegation_name,
		b.delegation_isieid,
		b.centre_name,
		b.centre_isieid,
		b.id,
		b.registred_voters,
		b.total_voters,
		b.extracted_ballots,
		b.delivered_ballots,
		b.white_ballots,
		b.not_used_ballots,
		b.cancelled_ballots,
		b.damaged_ballots,
		b.valid_ballots,
		b.votes
	from pc a left join (
		select
			circonscription_name,
			circonscription_isieid,
			delegation_name,
			delegation_isieid,
			cast(cast(circonscription_isieid as text)||cast(delegation_isieid as text)||cast(centre_isieid as text) as int) as id,
			centre_name,
			centre_isieid,
			sum(registred_voters) as registred_voters,
			sum(total_voters) as total_voters,
			sum(extracted_ballots) as extracted_ballots,
			sum(delivered_ballots) as delivered_ballots,
			sum(white_ballots) as white_ballots,
			sum(not_used_ballots) as not_used_ballots,
			sum(cancelled_ballots) as cancelled_ballots,
			sum(damaged_ballots) as damaged_ballots,
			sum(valid_ballots) as valid_ballots,
			sum(votes) as votes
		from results 
		group by circonscription_name,circonscription_isieid,delegation_name,delegation_isieid,centre_name,centre_isieid
	) b
	on polling_center_name_ar = centre_name
);
</pre>

You can now use the `pc_results` table in the [canceled-votes tilemill project](http://github.com/fwelections/databrowser/tree/gh-pages/map-src/canceled) to style your data.
