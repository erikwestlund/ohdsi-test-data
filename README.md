# Set up a PostgreSQL database with OHDSI test data.

Requirements for PostgreSQL:

An Ubuntu 22.04 instance.

## Clone the repository

Switch to home directory and clone repository.

```
cd
git clone https://github.com/erikwestlund/ohdsi-test-data`
```

## Set up an SQLite databse

1. cd to repo `cd $HOME/ohdsi-test-data`
2. Fetch the DDLs and fixture data: `bash fetch-data.sh`

The data will now be located at `$HOME/ohdsi-test-data/cdm.sqlite` where `$HOME`
is the user's home directory.

## Set up a PostgreSQL database.

1. cd to repo `cd $HOME/ohdsi-test-data`
2. Configure Postgres instance by running `bash configure-postgres.sh`
3. Fetch the DDLs and fixture data: `bash fetch-data.sh`
4. load the data `bash load-data.sh`

