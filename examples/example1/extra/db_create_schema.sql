/* 
	creates schema of the DB for CogStack

Uses schema specified by:
    https://github.com/synthetichealth/synthea/wiki/CSV-File-Data-Dictionary

*/
create domain key_type as uuid not null;
create domain text_type as varchar(256); 

create table patients (
ID key_type primary key,
BIRTHDATE date not null, 
DEATHDATE date, 
SSN varchar(64) not null, 
DRIVERS varchar(64),
PASSPORT varchar(64),
PREFIX varchar(8),
FIRST varchar(64) not null,
LAST varchar(64) not null,
SUFFIX varchar(8),
MAIDEN varchar(64),
MARITAL char(1),
RACE varchar(64) not null, 
ETHNICITY varchar(64) not null,
GENDER char(1) not null,
BIRTHPLACE varchar(64) not null,
ADDRESS varchar(64) not null,
CITY varchar(64) not null,
STATE varchar(64) not null,
ZIP varchar(64)
) ;

create table encounters (
ID key_type primary key not null,
START timestamp not null,
STOP timestamp,
PATIENT key_type references patients,
CODE varchar(64) not null,
DESCRIPTION text_type not null,
COST real not null,
REASONCODE varchar(64),
REASONDESCRIPTION text_type
) ;

create table observations (
CID serial primary key,							-- for CogStack compatibility
DCT timestamp default current_timestamp,		-- (*)
DATE date not null, 
PATIENT key_type references patients,
ENCOUNTER key_type references encounters,
CODE varchar(64) not null,
DESCRIPTION text_type not null,
VALUE varchar(64) not null,
UNITS varchar(64),
TYPE varchar(64) not null
) ;


/*

Create view for CogStack

*/
create view observations_view as
	 select
		p.ID as patient_id, 
		p.BIRTHDATE as patient_birth_date,
		p.DEATHDATE as death_date,
		p.SSN as patient_SSN,
		p.DRIVERS as patient_drivers,
		p.PASSPORT as patient_passport,
		p.PREFIX as patient_prefix,
		p.FIRST as patient_first_name,
		p.LAST as patient_last_name,
		p.SUFFIX as patient_suffix,
		p.MAIDEN as patient_maiden,
		p.MARITAL as patient_marital,
		p.RACE as patient_race,
		p.ETHNICITY as patient_ethnicity,
		p.GENDER as patient_gender,
		p.BIRTHPLACE as patient_birthplace,
		p.ADDRESS as patient_addr,
		p.CITY as patient_city,
		p.STATE as patient_state,
		p.ZIP as patient_zip,
		
		enc.ID as encounter_id,
		enc.START as encounter_start,
		enc.STOP as encounter_stop,
		enc.CODE as encounter_code,
		enc.DESCRIPTION as encounter_desc,
		enc.COST as encounter_cost,
		enc.REASONCODE as encounter_reason_code,
		enc.REASONDESCRIPTION as encounter_reason_desc,

		obs.DATE as observation_date,
		obs.CODE as observation_code,
		obs.DESCRIPTION as observation_desc,
		obs.VALUE as observation_value,
		obs.UNITS as observation_units,
		obs.TYPE as observation_type,

		-- for CogStack compatibility
		'src_field_name'::text as cog_src_field_name,     -- (a)
		'observations_view'::text as cog_src_table_name,  -- (b)
		obs.CID as cog_pk,                                -- (c)
		'cog_pk'::text as cog_pk_field_name,              -- (d)
		obs.DCT as cog_update_time                 -- (e)
	from 
		patients p, 
		encounters enc,
		observations obs
	where 
		enc.PATIENT = p.ID and
		obs.PATIENT = p.ID and 
    	obs.ENCOUNTER = enc.ID
	;