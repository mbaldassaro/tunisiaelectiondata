-- join regis table to delegation shapes, see where joins fail
drop table if exists del_ratio;
create table del_ratio as (
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

-- aggregate to delegations

create table del_results as (
	select
		circonscription_name,
		circonscription_isieid,
		delegation_name,
		delegation_isieid,
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
	group by circonscription_name,circonscription_isieid,delegation_name,delegation_isieid 
);

-- aggregate to pc level

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

-- create geometry

select addgeometrycolumn('public','pc_results','geom',4326,'POINT',2);
update pc_results set geom = st_setsrid(st_makepoint(longitude, latitude),4326);

-- create primary key

alter table pc_results add column 

-- tm query - cancelled

( select 
	*,
	round((cancelled_ballots / total_voters * 100),1) as pct_cancelled,
	cast(round((cancelled_ballots / total_voters * 100), 2) as text)||'%' as pct_cancelled_c
  from pc_results 
  order by pct_cancelled desc
 ) as data

-- create districts table

drop table districts;
create table districts as (
select
	circo_id,
	filter_rings(st_union(the_geom),2) as the_geom
from delegations
group by circo_id
);

-- tilemill query - wasted

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
	 
-- party results 

create table parties1 as (
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
