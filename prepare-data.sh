#!/usr/bin/env bash

# Pull repositories with useful data.
git clone https://github.com/OHDSI/CommonDataModel remote/CommonDataModel
git clone https://github.com/OHDSI/Eunomia remote/Eunomia

# Untar the CDM from Eunomia
tar -xvf remote/Eunomia/inst/sqlite/cdm.tar.xz

# Get and prepare the schema for CDM 5.3
mkdir -p sql/schema

cp remote/CommonDataModel/inst/ddl/5.3/postgresql/OMOPCDM_postgresql_5.3_ddl.sql sql/schema/ddl.sql
sed -i "s/@cdmDatabaseSchema/cdm/g" sql/schema/ddl.sql

# Start with DDL only; add keys after import
# cp remote/CommonDataModel/inst/ddl/5.3/postgresql/OMOPCDM_postgresql_5.3_primary_keys.sql sql/schema/keys.sql
# sed -i "s/@cdmDatabaseSchema/cdm/g" sql/schema/keys.sql

# cp remote/CommonDataModel/inst/ddl/5.3/postgresql/OMOPCDM_postgresql_5.3_constraints.sql sql/schema/constraints.sql
# sed -i "s/@cdmDatabaseSchema/cdm/g" sql/schema/constraints.sql

# cp remote/CommonDataModel/inst/ddl/5.3/postgresql/OMOPCDM_postgresql_5.3_indices.sql sql/schema/indices.sql
# sed -i "s/@cdmDatabaseSchema/cdm/g" sql/schema/indices.sql

# Save data to csv. Automating this is problematic as there are casting issues between the SQLite source data
# and the correct types for the Postgres schema. Since there are only a small number of tables, the easiest
# and most reliable thing to do is to manually select and handle the casts.

# CDM_SOURCE
sqlite3 -header -csv cdm.sqlite "select
  CDM_SOURCE_NAME,
  CDM_SOURCE_ABBREVIATION,
  CDM_HOLDER,
  SOURCE_DESCRIPTION,
  SOURCE_DOCUMENTATION_REFERENCE,
  CDM_ETL_REFERENCE,
  cast(SOURCE_RELEASE_DATE as integer) as SOURCE_RELEASE_DATE,
  cast(CDM_RELEASE_DATE as integer) as CDM_RELEASE_DATE,
  CDM_VERSION,
  VOCABULARY_VERSION
from CDM_SOURCE;" > data/eunomia/CDM_SOURCE.csv

# CONCEPT
sqlite3 -header -csv cdm.sqlite "select
  cast(CONCEPT_ID as integer) as CONCEPT_ID,
  CONCEPT_NAME,
  DOMAIN_ID,
  VOCABULARY_ID,
  CONCEPT_CLASS_ID,
  STANDARD_CONCEPT,
  CONCEPT_CODE,
  cast(VALID_START_DATE as integer) as VALID_START_DATE,
  cast(VALID_END_DATE as integer) as VALID_END_DATE,
  INVALID_REASON
from CONCEPT;" > data/eunomia/CONCEPT.csv

# CONCEPT_ANCESTOR
sqlite3 -header -csv cdm.sqlite "select
  cast(ANCESTOR_CONCEPT_ID as integer) as ANCESTOR_CONCEPT_ID,
  cast(DESCENDANT_CONCEPT_ID as integer) as DESCENDANT_CONCEPT_ID,
  cast(MIN_LEVELS_OF_SEPARATION  as integer) as MIN_LEVELS_OF_SEPARATION,
  cast(MAX_LEVELS_OF_SEPARATION as integer) as MAX_LEVELS_OF_SEPARATION
from CONCEPT_ANCESTOR;" > data/eunomia/CONCEPT_ANCESTOR.csv

# CONCEPT_RELATIONSHIP
sqlite3 -header -csv cdm.sqlite "select
  cast(CONCEPT_ID_1 as integer) as CONCEPT_ID_1,
  cast(CONCEPT_ID_2 as integer)  as CONCEPT_ID_2,
  RELATIONSHIP_ID,
  cast(VALID_START_DATE as integer) as VALID_START_DATE,
  cast(VALID_END_DATE as integer) as VALID_END_DATE,
  INVALID_REASON
from CONCEPT_RELATIONSHIP;" > data/eunomia/CONCEPT_RELATIONSHIP.csv

# CONCEPT_SYNONYM
  sqlite3 -header -csv cdm.sqlite "select
  cast(CONCEPT_ID as integer) as CONCEPT_ID,
  CONCEPT_SYNONYM_NAME,
  cast(LANGUAGE_CONCEPT_ID as integer) as LANGUAGE_CONCEPT_ID
from CONCEPT_SYNONYM;" > data/eunomia/CONCEPT_SYNONYM.csv

# CONDITION_ERA
sqlite3 -header -csv cdm.sqlite "select
  cast(CONDITION_ERA_ID as integer) as CONDITION_ERA_ID,
  cast(PERSON_ID as integer) as PERSON_ID,
  cast(CONDITION_CONCEPT_ID as integer) as CONDITION_CONCEPT_ID,
  cast(CONDITION_ERA_START_DATE as integer) as CONDITION_ERA_START_DATE,
  cast(CONDITION_ERA_END_DATE as integer) as CONDITION_ERA_END_DATE,
  cast(CONDITION_OCCURRENCE_COUNT as integer) as CONDITION_OCCURRENCE_COUNT
from CONDITION_ERA;" > data/eunomia/CONDITION_ERA.csv

# CONDITION_OCCURENCE
sqlite3 -header -csv cdm.sqlite "select
  cast(CONDITION_OCCURRENCE_ID as integer) as CONDITION_OCCURRENCE_ID,
  cast(PERSON_ID as integer) as PERSON_ID,
  cast(CONDITION_CONCEPT_ID as integer) as CONDITION_CONCEPT_ID,
  cast(CONDITION_START_DATE as integer) as CONDITION_START_DATE,
  cast(CONDITION_START_DATETIME as integer) as CONDITION_START_DATETIME,
  cast(CONDITION_END_DATE as integer) as CONDITION_END_DATE,
  cast(CONDITION_END_DATETIME as integer) as CONDITION_END_DATETIME,
  cast(CONDITION_TYPE_CONCEPT_ID as integer) as CONDITION_TYPE_CONCEPT_ID,
  STOP_REASON,
  cast(PROVIDER_ID as integer) as PROVIDER_ID,
  cast(VISIT_OCCURRENCE_ID as integer) as VISIT_OCCURRENCE_ID,
  cast(VISIT_DETAIL_ID as integer) as VISIT_DETAIL_ID,
  CONDITION_SOURCE_VALUE,
  cast(CONDITION_SOURCE_CONCEPT_ID as integer) as CONDITION_SOURCE_CONCEPT_ID,
  CONDITION_STATUS_SOURCE_VALUE,
  cast(CONDITION_STATUS_CONCEPT_ID as integer) as CONDITION_STATUS_CONCEPT_ID
from CONDITION_OCCURRENCE;" > data/eunomia/CONDITION_OCCURRENCE.csv

# DOMAIN
sqlite3 -header -csv cdm.sqlite "select
  DOMAIN_ID,
  DOMAIN_NAME,
  cast(DOMAIN_CONCEPT_ID as integer) as DOMAIN_CONCEPT_ID
from DOMAIN;" > data/eunomia/DOMAIN.csv

# DRUG_ERA
sqlite3 -header -csv cdm.sqlite "select
  cast(DRUG_ERA_ID as integer) as DRUG_ERA_ID,
  cast(PERSON_ID as integer) as PERSON_ID,
  cast(DRUG_CONCEPT_ID as integer) as DRUG_CONCEPT_ID,
  cast(DRUG_ERA_START_DATE as integer) as DRUG_ERA_START_DATE,
  cast(DRUG_ERA_END_DATE as integer) as DRUG_ERA_END_DATE,
  cast(DRUG_EXPOSURE_COUNT as integer) as DRUG_EXPOSURE_COUNT,
  cast(GAP_DAYS as integer) as GAP_DAYS
from DRUG_ERA;" > data/eunomia/DRUG_ERA.csv

# DRUG_EXPOSURE
sqlite3 -header -csv cdm.sqlite "select
  cast(DRUG_EXPOSURE_ID as integer) as DRUG_EXPOSURE_ID,
  cast(PERSON_ID as integer) as PERSON_ID,
  cast(DRUG_CONCEPT_ID as integer) as DRUG_CONCEPT_ID,
  cast(DRUG_EXPOSURE_START_DATE as integer) as DRUG_EXPOSURE_START_DATE,
  cast(DRUG_EXPOSURE_START_DATETIME as integer) as DRUG_EXPOSURE_START_DATETIME,
  cast(DRUG_EXPOSURE_END_DATE as integer) as DRUG_EXPOSURE_END_DATE,
  cast(DRUG_EXPOSURE_END_DATETIME as integer) as DRUG_EXPOSURE_END_DATETIME,
  cast(VERBATIM_END_DATE as integer) as VERBATIM_END_DATE,
  cast(DRUG_TYPE_CONCEPT_ID as integer) as DRUG_TYPE_CONCEPT_ID,
  STOP_REASON,
  cast(REFILLS as integer) as REFILLS,
  QUANTITY,
  cast(DAYS_SUPPLY as integer) as DAYS_SUPPLY,
  SIG,
  cast(ROUTE_CONCEPT_ID as integer) as ROUTE_CONCEPT_ID,
  LOT_NUMBER,
  cast(PROVIDER_ID as integer) as PROVIDER_ID,
  cast(VISIT_OCCURRENCE_ID as integer) as VISIT_OCCURRENCE_ID,
  cast(VISIT_DETAIL_ID as integer) as VISIT_DETAIL_ID,
  DRUG_SOURCE_VALUE,
  cast(DRUG_SOURCE_CONCEPT_ID as integer) as DRUG_SOURCE_CONCEPT_ID,
  ROUTE_SOURCE_VALUE,
  DOSE_UNIT_SOURCE_VALUE
from DRUG_EXPOSURE;" > data/eunomia/DRUG_EXPOSURE.csv

# MEASUREMENT
sqlite3 -header -csv cdm.sqlite "select

from TABLE;" > data/eunomia/TABLE.csv

# OBSERVATION
sqlite3 -header -csv cdm.sqlite "select

from TABLE;" > data/eunomia/TABLE.csv

# OBSERVATION_PERIOD
sqlite3 -header -csv cdm.sqlite "select

from TABLE;" > data/eunomia/TABLE.csv

# PERSON
sqlite3 -header -csv cdm.sqlite "select

from TABLE;" > data/eunomia/TABLE.csv

# PROCEDURE_OCCURENCE
sqlite3 -header -csv cdm.sqlite "select

from TABLE;" > data/eunomia/TABLE.csv

# RELATIONSHIP
sqlite3 -header -csv cdm.sqlite "select

from TABLE;" > data/eunomia/TABLE.csv

# VISIT_OCCURENCE
sqlite3 -header -csv cdm.sqlite "select

from TABLE;" > data/eunomia/TABLE.csv

# VOCABULARY



