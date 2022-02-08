#!/bin/sh -x

# $1 :   Url de backup

bundle _1.17.3_ exec rake db:drop
bundle _1.17.3_ exec rake db:create
mkdir tmp/bkp
cd tmp/bkp/

wget $1
tar -xf agc.tar
cd agc/databases/
gunzip PostgreSQL.sql.gz
psql -a -d agc_development -f PostgreSQL.sql -U agc
psql -a -d agc_development -U agc -c 'CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;'
cd ../../../../
rm -rf tmp/bkp/


