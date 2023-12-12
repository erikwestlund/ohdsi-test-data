#!/usr/bin/env bash

git clone https://github.com/OHDSI/CommonDataModel remote/CommonDataModel

git clone https://github.com/OHDSI/Eunomia remote/Eunomia
tar -xvf remote/Eunomia/inst/sqlite/cdm.tar.xz
