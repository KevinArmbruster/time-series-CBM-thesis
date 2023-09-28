#!/bin/bash
set -e

# Download DB
DB_FILES_DIR='/opt/workdir/physionet.org/files/mimiciii/1.4/'

if [ ! -d "$DB_FILES_DIR" ]; then
    cd "/opt/workdir"
    PHYSIO_PW='AhMDfqVO{k8[/u}D_A~|=RP\+5++a.aN@C+&.9;w;mV1%[!5msebtYF~u}jd'
    wget -r -N -c -np --user kevinarmbruster --password ${PHYSIO_PW} "https://physionet.org/files/mimiciii/1.4/"
fi


# Init DB
# export PGPASSWORD='mypassword'
SQL_FILES_DIR='/opt/workdir/mimic-code/mimic-iii/buildmimic/postgres'
cd $SQL_FILES_DIR

psql 'dbname=mimic user=karmbruster' -f postgres_create_tables.sql
psql 'dbname=mimic user=karmbruster' -f postgres_load_data_gz.sql -v mimic_data_dir=$DB_FILES_DIR
psql 'dbname=mimic user=karmbruster' -f postgres_add_indexes.sql
psql 'dbname=mimic user=karmbruster' -f postgres_checks.sql
