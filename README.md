# Set Up a Dispoable PostgreSQL Database with OMOP CDM Test Data  🚀🧨🚀🧨🚀

Requirements: An Ubuntu server. (Tested with 22.04, should work with past releases.)

## Clone the repository

Switch to home directory and clone repository.

```
cd
git clone https://github.com/erikwestlund/ohdsi-test-data
```

## Set up an SQLite databse

1. cd to repo `cd $HOME/ohdsi-test-data`
2. Fetch the DDLs and fixture data: `bash fetch-data.sh`

The Eunomia data will now be located at `$HOME/ohdsi-test-data/cdm.sqlite` where `$HOME`
is the user's home directory.

## Set up a PostgreSQL database.

1. cd to repo `cd $HOME/ohdsi-test-data`
2. Configure PostgreSQL instance and install other necessary tooling by running the code in `configure-env.sh`. For now, I recommend doing this in chunks by hand as it hasn't been fully fleshed out to work non-interactively.
3. Fetch the DDLs and fixture data and prepare for loading by running `bash prepare-data.sh`
4. Load the data `bash load-data.sh`

