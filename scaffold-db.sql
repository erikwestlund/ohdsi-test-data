CREATE USER ohdsi WITH PASSWORD 'ohdsi';
CREATE SCHEMA IF NOT EXISTS cdm;
CREATE SCHEMA IF NOT EXISTS scratch;

GRANT ALL PRIVILEGES ON SCHEMA cdm TO ohdsi;
GRANT ALL PRIVILEGES ON SCHEMA scratch TO ohdsi;