CREATE USER ohdsi WITH PASSWORD 'ohdsi';
CREATE SCHEMA IF NOT EXISTS cdm;
CREATE SCHEMA IF NOT EXISTS scratch;


\ir data/schema/ddl.sql;
\ir data/schema/keys.sql;
\ir data/schema/constraints.sql;
\ir data/schema/indices.sql;



