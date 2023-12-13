#!/usr/bin/env bash

sudo -u postgres psql -f sql/create-ohdsi-role.sql
sudo -u postgres psql -f sql/create-schema.sql
sudo -u postgres psql -f sql/set-ohdsi-role-permissions.sql
sudo -u postgres psql -f sql/schema/ddl.sql;

# Start with DDL Only;
# sudo -u postgres psql -f sql/schema/keys.sql;
# sudo -u postgres psql -f sql/schema/constraints.sql;
# sudo -u postgres psql -f sql/schema/indices.sql;
sudo -u postgres psql -f sql/set-ohdsi-role-permissions.sql # Must reset permissions now that tables are created.


# Load in data
pgloader csv.load