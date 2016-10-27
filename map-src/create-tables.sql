create table regis (
	district_id int,
	district text,
	delegation text, 
	actively_registred numeric,
	eligible_voters numeric,
	ratio numeric
	);

-- cat path-to/2011data/RegistrationDistributionPerDelegation/RegistDistibutionperDelegation.csv | psql -d tunisia -c "COPY regis FROM STDIN WITH DELIMITER ',' CSV HEADER"

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

-- cat eligible_voters 2011data/election-results.csv | psql -d tunisia -c "COPY results FROM STDIN WITH DELIMITER ',' CSV"

create table pc (
	district_name_ar text,
	delegation_name_ar text,
	polling_center_name_ar text,
	latitude numeric,
	longitude numeric,
	contact text
	);

-- cat shapes/polling_centers_tunisia.csv | psql -d tunisia -c "COPY pc FROM STDIN WITH DELIMITER ',' CSV"

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
	cancelled_ballots numeric,
	map numeric
);

-- cat wasted-votes.csv | psql -d tunisia -c "COPY wasted FROM STDIN WITH DELIMITER ',' CSV"

-- TROIKA TABLES
-- 
-- District ID,
-- Electoral district ,
-- Votes in actively registered PSVoluntarily registered,
-- Ratio of total votes for the list in actively registered PS,
-- Votes in automatically registered PS,
-- Ratio of total votes for the list in automatically registered PS,
-- Total  votes in the district,
-- Ratio of total votes of the district,


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

-- cat 2011data/resultsPerParty/takattoul.csv | psql -d tunisia -c "COPY takattoul FROM STDIN WITH DELIMITER ';' CSV HEADER"

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

-- cat 2011data/resultsPerParty/nadha.csv | psql -d tunisia -c "COPY nadha FROM STDIN WITH DELIMITER ';' CSV HEADER"

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

-- cat 2011data/resultsPerParty/cpr.csv | psql -d tunisia -c "COPY cpr FROM STDIN WITH DELIMITER ';' CSV HEADER"

