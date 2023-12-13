GRANT CONNECT ON DATABASE postgres TO ohdsi, postgres;
GRANT USAGE ON SCHEMA cdm, scratch TO ohdsi, postgres;
GRANT ALL ON SCHEMA cdm, scratch TO ohdsi, postgres;
SET search_path TO cdm, public;
ALTER ROLE ohdsi SET search_path TO cdm, public;
ALTER DEFAULT PRIVILEGES FOR ROLE ohdsi IN SCHEMA cdm GRANT ALL ON TABLES TO ohdsi;
