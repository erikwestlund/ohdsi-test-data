#!/usr/bin/env bash

# Configure database and load schema
sudo -u postgres psql -f sql/create-ohdsi-role.sql
sudo -u postgres psql -f sql/create-schema.sql
sudo -u postgres psql -f sql/set-ohdsi-role-permissions.sql

# Load DDL only, first.
sudo -u postgres psql -f sql/schema/ddl.sql;

# Must reset permissions for ohdsi role now that tables are created.
sudo -u postgres psql -f sql/set-ohdsi-role-permissions.sql

# Load in data using CSV files created in the data preparation script.
pgloader csv-load-files/cdm_source.load
pgloader csv-load-files/concept.load
pgloader csv-load-files/concept_ancestor.load
pgloader csv-load-files/concept_relationship.load
pgloader csv-load-files/concept_synonym.load
pgloader csv-load-files/condition_era.load
pgloader csv-load-files/condition_occurence.load
pgloader csv-load-files/domain.load
pgloader csv-load-files/drug_era.load
pgloader csv-load-files/drug_exposure.load
pgloader csv-load-files/measurement.load
pgloader csv-load-files/observation.load
pgloader csv-load-files/observation_period.load
pgloader csv-load-files/person.load
pgloader csv-load-files/procedure_occurence.load
pgloader csv-load-files/relationship.load
pgloader csv-load-files/visit_occurence.load
pgloader csv-load-files/vocabulary.load

# Add constraints and indices
sudo -u postgres psql -f sql/schema/keys.sql;

# Not all data are provided to sufficiently fix constraints.
# So we will not enforce in test data. For now.
# sudo -u postgres psql -f sql/schema/constraints.sql;
sudo -u postgres psql -f sql/schema/indices.sql;