# Bash
SERVER="tcp:sql-server-nebo-ne.database.windows.net,1433"   
ADMIN=$TF_VAR_admin_username
Echo "Connecting to SQL Server as $ADMIN"
PASS=$TF_VAR_admin_password
Echo "Using password: $PASS"
DB="Bike Stores"

echo "Connecting to $SERVER as $ADMIN (db: $DB)"
sqlcmd -S "$SERVER" -d "$DB" -U "$ADMIN" -P "$PASS" -l 30 -b -i "./sql_scripts/create_app_user.sql"
