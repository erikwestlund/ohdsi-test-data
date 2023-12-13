GRANT CONNECT ON DATABASE postgres TO ohdsi;
GRANT USAGE ON SCHEMA cdm, scratch TO ohdsi;
GRANT ALL ON SCHEMA cdm, scratch TO ohdsi;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA cdm, scratch TO ohdsi;

SET search_path TO cdm, public;
ALTER ROLE ohdsi SET search_path TO cdm, public;
ALTER DEFAULT PRIVILEGES FOR ROLE ohdsi IN SCHEMA cdm GRANT ALL ON TABLES TO ohdsi;
