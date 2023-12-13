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

cp remote/CommonDataModel/inst/ddl/5.3/postgresql/OMOPCDM_postgresql_5.3_primary_keys.sql sql/schema/keys.sql
sed -i "s/@cdmDatabaseSchema/cdm/g" sql/schema/keys.sql

cp remote/CommonDataModel/inst/ddl/5.3/postgresql/OMOPCDM_postgresql_5.3_constraints.sql sql/schema/constraints.sql
sed -i "s/@cdmDatabaseSchema/cdm/g" sql/schema/constraints.sql

cp remote/CommonDataModel/inst/ddl/5.3/postgresql/OMOPCDM_postgresql_5.3_indices.sql sql/schema/indices.sql
sed -i "s/@cdmDatabaseSchema/cdm/g" sql/schema/indices.sql
