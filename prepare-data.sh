#!/usr/bin/env bash

# Pull repositories with useful data.
git clone https://github.com/OHDSI/CommonDataModel remote/CommonDataModel
git clone https://github.com/OHDSI/Eunomia remote/Eunomia

# Untar the CDM from Eunomia
tar -xvf remote/Eunomia/inst/sqlite/cdm.tar.xz
