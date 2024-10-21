#!/bin/bash

#change on your path to PostgreSQL
#pathA=/c/Program\ Files/PostgreSQL/13/bin
#export PATH=$PATH:$pathA

#write your password
PGPASSWORD=password
export PGPASSWORD

#change the path to the file from which will be made restore
pathB=/app/
#write this on the command line as the first parameter
filename=data.dump
#write your user
dbUser=postgres
#write your database
database=postgres_db
#write your host
host=postgres
#write your port
port=5432

psql -U $dbUser -h $host -p $port -d $database -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
psql --set ON_ERROR_STOP=off -U $dbUser -h $host -p $port -d $database -1 -f $pathB$filename

unset PGPASSWORD

# psql -U postgres -d schedule -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
# psql --set ON_ERROR_STOP=off -U postgres -d schedule -1 -f 2023-08-31.dump