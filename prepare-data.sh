#!/usr/bin/env bash

# Make sure this is only run from within the directory.
if [[ ! -f .in-root ]] ; then
    echo 'You must run this command from within the repository root. Escaping.'
    exit
fi

# Pull repositories with useful data.
rm -rf remote
rm -rf data
git clone https://github.com/OHDSI/CommonDataModel remote/CommonDataModel
git clone https://github.com/OHDSI/Eunomia remote/Eunomia

# Untar the CDM from Eunomia
tar -xvf remote/Eunomia/inst/sqlite/cdm.tar.xz

# Get and prepare the schema for CDM 5.3
mkdir -p sql/schema
mkdir -p data/eunomia

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
# Requires a patch for data integirity
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
# cat patches/concept.csv >> data/eunomia/CONCEPT.csv

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
# Requires a patch for data integirity
sqlite3 -header -csv cdm.sqlite "select
  DOMAIN_ID,
  DOMAIN_NAME,
  cast(DOMAIN_CONCEPT_ID as integer) as DOMAIN_CONCEPT_ID
from DOMAIN;" > data/eunomia/DOMAIN.csv
# cat patches/domain.csv >> data/eunomia/DOMAIN.csv

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
#   Eunomia has duplicates so group on DRUG_EXPOSURE_ID
sqlite3 -header -csv cdm.sqlite "select
  cast(min(DRUG_EXPOSURE_ID) as integer) as DRUG_EXPOSURE_ID,
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
from DRUG_EXPOSURE group by DRUG_EXPOSURE_ID;" > data/eunomia/DRUG_EXPOSURE.csv

# MEASUREMENT
#   Eunomia has duplicates so group on MEASUREMENT_ID
sqlite3 -header -csv cdm.sqlite "select
  cast(min(MEASUREMENT_ID) as integer) as MEASUREMENT_ID,
  cast(PERSON_ID as integer) as PERSON_ID,
  cast(MEASUREMENT_CONCEPT_ID as integer) as MEASUREMENT_CONCEPT_ID,
  cast(MEASUREMENT_DATE as integer) as MEASUREMENT_DATE,
  cast(MEASUREMENT_DATETIME as integer) as MEASUREMENT_DATETIME,
  cast(MEASUREMENT_TIME as integer) as MEASUREMENT_TIME,
  cast(MEASUREMENT_TYPE_CONCEPT_ID as integer) as MEASUREMENT_TYPE_CONCEPT_ID,
  cast(OPERATOR_CONCEPT_ID as integer) as OPERATOR_CONCEPT_ID,
  VALUE_AS_NUMBER,
  cast(VALUE_AS_CONCEPT_ID as integer) as VALUE_AS_CONCEPT_ID,
  cast(UNIT_CONCEPT_ID as integer) as UNIT_CONCEPT_ID,
  RANGE_LOW,
  RANGE_HIGH,
  cast(PROVIDER_ID as integer) as PROVIDER_ID,
  cast(VISIT_OCCURRENCE_ID as integer) as VISIT_OCCURRENCE_ID,
  cast(VISIT_DETAIL_ID as integer) as VISIT_DETAIL_ID,
  MEASUREMENT_SOURCE_VALUE,
  cast(MEASUREMENT_SOURCE_CONCEPT_ID as integer) as MEASUREMENT_SOURCE_CONCEPT_ID,
  UNIT_SOURCE_VALUE,
  VALUE_SOURCE_VALUE
from MEASUREMENT group by MEASUREMENT_ID;" > data/eunomia/MEASUREMENT.csv

# OBSERVATION
#   Eunomia has duplicates so group on OBSERVATION_ID
sqlite3 -header -csv cdm.sqlite "select
  cast(min(OBSERVATION_ID) as integer) as OBSERVATION_ID,
  cast(PERSON_ID as integer) as PERSON_ID,
  cast(OBSERVATION_CONCEPT_ID as integer) as OBSERVATION_CONCEPT_ID,
  cast(OBSERVATION_DATE as integer) as OBSERVATION_DATE,
  cast(OBSERVATION_DATETIME as integer) as OBSERVATION_DATETIME,
  cast(OBSERVATION_TYPE_CONCEPT_ID as integer) as OBSERVATION_TYPE_CONCEPT_ID,
  VALUE_AS_NUMBER,
  VALUE_AS_STRING,
  cast(VALUE_AS_CONCEPT_ID as integer) as VALUE_AS_CONCEPT_ID,
  cast(QUALIFIER_CONCEPT_ID as integer) as QUALIFIER_CONCEPT_ID,
  cast(UNIT_CONCEPT_ID as integer) as UNIT_CONCEPT_ID,
  cast(PROVIDER_ID as integer) as PROVIDER_ID,
  cast(VISIT_OCCURRENCE_ID as integer) as VISIT_OCCURRENCE_ID,
  cast(VISIT_DETAIL_ID as integer) as VISIT_DETAIL_ID,
  OBSERVATION_SOURCE_VALUE,
  cast(OBSERVATION_SOURCE_CONCEPT_ID as integer) as OBSERVATION_SOURCE_CONCEPT_ID,
  UNIT_SOURCE_VALUE,
  QUALIFIER_SOURCE_VALUE
from OBSERVATION group by OBSERVATION_ID;" > data/eunomia/OBSERVATION.csv

# OBSERVATION_PERIOD
sqlite3 -header -csv cdm.sqlite "select
  cast(OBSERVATION_PERIOD_ID as integer) as OBSERVATION_PERIOD_ID,
  cast(PERSON_ID as integer) as PERSON_ID,
  cast(OBSERVATION_PERIOD_START_DATE as integer) as OBSERVATION_PERIOD_START_DATE,
  cast(OBSERVATION_PERIOD_END_DATE as integer) as OBSERVATION_PERIOD_END_DATE,
  cast(PERIOD_TYPE_CONCEPT_ID as integer) as PERIOD_TYPE_CONCEPT_ID
from OBSERVATION_PERIOD;" > data/eunomia/OBSERVATION_PERIOD.csv

# PERSON
# Requires a patch for data integirity
sqlite3 -header -csv cdm.sqlite "select
  cast(PERSON_ID as integer) as PERSON_ID,
  cast(GENDER_CONCEPT_ID as integer) as GENDER_CONCEPT_ID,
  cast(YEAR_OF_BIRTH as integer) as YEAR_OF_BIRTH,
  cast(MONTH_OF_BIRTH as integer) as MONTH_OF_BIRTH,
  cast(DAY_OF_BIRTH as integer) as DAY_OF_BIRTH,
  cast(BIRTH_DATETIME as integer) as BIRTH_DATETIME,
  cast(RACE_CONCEPT_ID as integer) as RACE_CONCEPT_ID,
  cast(ETHNICITY_CONCEPT_ID as integer) as ETHNICITY_CONCEPT_ID,
  cast(LOCATION_ID as integer) as LOCATION_ID,
  cast(PROVIDER_ID as integer) as PROVIDER_ID,
  cast(CARE_SITE_ID as integer) as CARE_SITE_ID,
  PERSON_SOURCE_VALUE,
  GENDER_SOURCE_VALUE,
  cast(GENDER_SOURCE_CONCEPT_ID as integer) as GENDER_SOURCE_CONCEPT_ID,
  RACE_SOURCE_VALUE,
  cast(RACE_SOURCE_CONCEPT_ID as integer) as RACE_SOURCE_CONCEPT_ID,
  ETHNICITY_SOURCE_VALUE,
  cast(ETHNICITY_SOURCE_CONCEPT_ID as integer) as ETHNICITY_SOURCE_CONCEPT_ID
from PERSON;" > data/eunomia/PERSON.csv
# cat patches/person.csv >> data/eunomia/PERSON.csv

# PROCEDURE_OCCURENCE
sqlite3 -header -csv cdm.sqlite "select
  cast(PROCEDURE_OCCURRENCE_ID as integer) as PROCEDURE_OCCURRENCE_ID,
  cast(PERSON_ID as integer) as PERSON_ID,
  cast(PROCEDURE_CONCEPT_ID as integer) as PROCEDURE_CONCEPT_ID,
  cast(PROCEDURE_DATE as integer) as PROCEDURE_DATE,
  cast(PROCEDURE_DATETIME as integer) as PROCEDURE_DATETIME,
  cast(PROCEDURE_TYPE_CONCEPT_ID as integer) as PROCEDURE_TYPE_CONCEPT_ID,
  cast(MODIFIER_CONCEPT_ID as integer) as MODIFIER_CONCEPT_ID,
  cast(QUANTITY as integer) as QUANTITY,
  cast(PROVIDER_ID as integer) as PROVIDER_ID,
  cast(VISIT_OCCURRENCE_ID as integer) as VISIT_OCCURRENCE_ID,
  cast(VISIT_DETAIL_ID as integer) as VISIT_DETAIL_ID,
  PROCEDURE_SOURCE_VALUE,
  cast(PROCEDURE_SOURCE_CONCEPT_ID as integer) as PROCEDURE_SOURCE_CONCEPT_ID,
  MODIFIER_SOURCE_VALUE
from PROCEDURE_OCCURRENCE;" > data/eunomia/PROCEDURE_OCCURRENCE.csv

# RELATIONSHIP
sqlite3 -header -csv cdm.sqlite "select
  RELATIONSHIP_ID,
  RELATIONSHIP_NAME,
  IS_HIERARCHICAL,
  DEFINES_ANCESTRY,
  REVERSE_RELATIONSHIP_ID,
  cast(RELATIONSHIP_CONCEPT_ID as integer) as RELATIONSHIP_CONCEPT_ID
from RELATIONSHIP;" > data/eunomia/RELATIONSHIP.csv

# VISIT_OCCURENCE
sqlite3 -header -csv cdm.sqlite "select
  cast(VISIT_OCCURRENCE_ID as integer) as VISIT_OCCURRENCE_ID,
  cast(PERSON_ID as integer) as PERSON_ID,
  cast(VISIT_CONCEPT_ID as integer) as VISIT_CONCEPT_ID,
  cast(VISIT_START_DATE as integer) as VISIT_START_DATE,
  cast(VISIT_START_DATETIME as integer) as VISIT_START_DATETIME,
  cast(VISIT_END_DATE as integer) as VISIT_END_DATE,
  cast(VISIT_END_DATETIME as integer) as VISIT_END_DATETIME,
  cast(VISIT_TYPE_CONCEPT_ID as integer) as VISIT_TYPE_CONCEPT_ID,
  cast(PROVIDER_ID as integer) as PROVIDER_ID,
  cast(CARE_SITE_ID as integer) as CARE_SITE_ID,
  VISIT_SOURCE_VALUE,
  cast(VISIT_SOURCE_CONCEPT_ID as integer) as VISIT_SOURCE_CONCEPT_ID,
  cast(ADMITTING_SOURCE_CONCEPT_ID as integer) as ADMITTING_SOURCE_CONCEPT_ID,
  ADMITTING_SOURCE_VALUE,
  cast(DISCHARGE_TO_CONCEPT_ID as integer) as DISCHARGE_TO_CONCEPT_ID,
  DISCHARGE_TO_SOURCE_VALUE,
  cast(PRECEDING_VISIT_OCCURRENCE_ID as integer) as PRECEDING_VISIT_OCCURRENCE_ID
from VISIT_OCCURRENCE;" > data/eunomia/VISIT_OCCURRENCE.csv

# VOCABULARY
sqlite3 -header -csv cdm.sqlite "select
  VOCABULARY_ID,
  VOCABULARY_NAME,
  VOCABULARY_REFERENCE,
  VOCABULARY_VERSION,
  cast(VOCABULARY_CONCEPT_ID as integer) as VOCABULARY_CONCEPT_ID
from VOCABULARY;" > data/eunomia/VOCABULARY.csv

# Eunomia's vocabulary_version values in the VOCABULARY table has null values but the production schema do not allow that. Since the table only has empty values for those we can just find/replace ,, with ,"",
sed -i.bak 's/,,/,"",/g' data/eunomia/VOCABULARY.csv
rm data/eunomia/VOCABULARY.csv.bak # For mac portability, need ".bak"


