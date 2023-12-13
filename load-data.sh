#!/usr/bin/env bash

sudo -u postgres psql -f sql/create-ohdsi-role.sql
sudo -u postgres psql -f sql/set-ohdsi-role-permissions.sql
sudo -u postgres psql -f sql/schema/ddl.sql;
sudo -u postgres psql -f sql/schema/keys.sql;
sudo -u postgres psql -f sql/schema/constraints.sql;
sudo -u postgres psql -f sql/schema/indices.sql;
sudo -u postgres psql -f sql/set-ohdsi-role-permissions.sql # Must reset permissions now that tables are created.

# \ir data/schema/ddl.sql;
# \ir data/schema/keys.sql;
# \ir data/schema/constraints.sql;
# \ir data/schema/indices.sql;


# Now load the Eunomia data, which we have copied into CSV files, following
# guidance by Chris Knoll, here:
# https://forums.ohdsi.org/t/standard-cdm-database-for-testing-demonstrating/6031/23

pgloader sqlite:///home/$USER/cdm.sqlite pgsql://ohdsi:ohdsi@localhost/cdm


sudo -u postgres psql -f load-data.sql

sudo -u postgres psql -c "COPY cdm.CDM_SOURCE FROM '$HOME/ohdsi-test-data/data/eunomia/CDM_SOURCE.csv' DELIMITER ',' CSV HEADER NULL AS '';"
COPY cdm.CDM_SOURCE FROM 'data/eunomia/CDM_SOURCE.csv' DELIMITER ',' CSV HEADER NULL AS '';