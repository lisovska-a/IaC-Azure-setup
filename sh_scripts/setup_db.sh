#!/usr/bin/env bash
set -euo pipefail

SERVER="tcp:sql-server-nebo-ne.database.windows.net,1433"
ADMIN="${TF_VAR_admin_username}"
PASS="${TF_VAR_admin_password}"
DB="Bike Stores"

FILE_TO_CREATE_OBJ="./sql_scripts/BikeStores Sample Database - create objects.sql"
FILE_TO_LOAD_DATA="./sql_scripts/BikeStores Sample Database - load data.sql"

echo "Connecting to $SERVER as $ADMIN (db: $DB)"

# 1) Create schema/objects
sqlcmd -S "$SERVER" -d "$DB" -U "$ADMIN" -P "$PASS" -b -l 60  -i "$FILE_TO_CREATE_OBJ"

# 2) Load data
sqlcmd -S "$SERVER" -d "$DB" -U "$ADMIN" -P "$PASS" -b -l 120 -i "$FILE_TO_LOAD_DATA"

echo "Done."
