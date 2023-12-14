#!/usr/bin/env bash

# Steps, run these commands on a working Ubuntu instance (tested 22.04)

sudo apt install -y postgresql pgloader sqlite3
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/14/main/postgresql.conf
sudo sed -i "s/host    all             all             127.0.0.1\/32/host    all             all             0.0.0.0\/0/g" /etc/postgresql/14/main/pg_hba.conf

sudo ufw allow 5432/tcp
sudo service postgresql restart

sudo usermod -a -G $USER postgres

