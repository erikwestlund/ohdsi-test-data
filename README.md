# Set up a PostgreSQL database with OHDSI test data.

Requirements:

* For SQLite, simply use the "cdm.sqlite" file generated from the fetch-data
command
* For PostgreSQL, need a PGSQL instance and pgloader on the machine running
this code, a database, and credentials to connect to that database.

## Clone the repository

Switch to home directory and clone repository.

```
cd
git clone https://github.com/erikwestlund/ohdsi-test-data`
```

## Set up an SQLite databse

1. cd to repo `cd $HOME/ohdsi-test-data`
2. Fetch the sqlite data: `bash fetch-data.sh`

The data will now be located at `$HOME/ohdsi-test-data/cdm.sqlite` where `$HOME`
is the user's home directory.

Steps:

1. cd to repo `cd $HOME/ohdsi-test-data`
2. Configure Postgres instance by running `bash configure-postgres.sh`
3. Fetch the sqlite data: `bash fetch-data.sh`
4. load the data `bash load-sqlite-to-postgres.sh`

