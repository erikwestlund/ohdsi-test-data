#!/usr/bin/env bash

mkdir -p schema

# Fetch and load the schema
cp CommonDataModel/inst/ddl/5.4/postgresql/OMOPCDM_postgresql_5.4_ddl.sql schema/ddl.sql
sed -i "s/@cdmDatabaseSchema/cdm/g" schema/ddl.sql
sudo -u postgres psql -f schema/ddl.sql

cp CommonDataModel/inst/ddl/5.4/postgresql/OMOPCDM_postgresql_5.4_primary_keys.sql schema/keys.sql
sed -i "s/@cdmDatabaseSchema/cdm/g" schema/keys.sql
sudo -u postgres psql -f schema/keys.sql

cp CommonDataModel/inst/ddl/5.4/postgresql/OMOPCDM_postgresql_5.4_constraints.sql schema/constraints.sql
sed -i "s/@cdmDatabaseSchema/cdm/g" schema/constraints.sql
sudo -u postgres psql -f schema/constraints.sql

cp CommonDataModel/inst/ddl/5.4/postgresql/OMOPCDM_postgresql_5.4_indices.sql schema/indices.sql
sed -i "s/@cdmDatabaseSchema/cdm/g" schema/indices.sql
sudo -u postgres psql -f schema/indices.sql

# Now load the Eunomia data, which we have copied into CSV files, following
# guidance by Chris Knoll, here:
# https://forums.ohdsi.org/t/standard-cdm-database-for-testing-demonstrating/6031/23

sudo -u postgres -f load-data.sql