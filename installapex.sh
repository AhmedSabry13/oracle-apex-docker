#!/bin/bash

# CONFIGURABLE VARIABLES
APEX_ZIP="apex.zip"  # Change to your actual APEX zip
APEX_SRC_DIR="/opt/oracle/extention/"   # Path where zip is located
APEX_HOME="/opt/oracle/extention/apex" # Will extract here
PDB_NAME="FREEPDB1"
APEX_PASS="Oracle123"  # Change to your desired APEX admin password
APEX_PASS_WEB="Oracle_1234"
APEX_ADMIN="ADMIN"
APEX_MAIL="ahmednaruto13@gmail.com"

# Check if APEX zip exists
if [ ! -f "$APEX_SRC_DIR/$APEX_ZIP" ]; then
  echo "APEX zip not found in $APEX_SRC_DIR"
  exit 1
fi

echo "Extracting APEX..."
unzip -q "$APEX_SRC_DIR/$APEX_ZIP" -d "$APEX_SRC_DIR"

echo "Switching to Oracle user..."


echo "Setting ORACLE environment..."
export ORACLE_SID=FREE
export ORAENV_ASK=NO
. oraenv

cd /opt/oracle/extention/apex
echo "Connecting to the container database..."
sqlplus / as sysdba <<EOSQL
ALTER SESSION SET CONTAINER=$PDB_NAME;
@apexins.sql SYSAUX SYSAUX TEMP /i/
EOSQL

echo "Creating APEX Admin user..."
sqlplus / as sysdba <<EOSQL
ALTER SESSION SET CONTAINER=$PDB_NAME;
@apex_rest_config.sql $APEX_PASS $APEX_PASS

BEGIN
    APEX_UTIL.set_security_group_id(10);
    APEX_UTIL.create_user(
        p_user_name => 'ADMIN',
        p_email_address => 'admin@example.com',
        p_web_password => '$APEX_PASS',
        p_developer_privs => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:SQL',
        p_change_password_on_first_use => 'N'
    );
    COMMIT;
END;
/
EOSQL


echo "Connecting to the container database..."
sqlplus / as sysdba <<EOSQL
ALTER SESSION SET CONTAINER=$PDB_NAME;


@apxchpwd.sql 
$APEX_ADMIN
$APEX_MAIL
$APEX_PASS_WEB
$APEX_PASS_WEB

ALTER USER APEX_PUBLIC_USER ACCOUNT UNLOCK;
ALTER USER APEX_240200 ACCOUNT UNLOCK;

EOSQL


sqlplus / as sysdba <<EOSQL
ALTER SESSION SET CONTAINER=$PDB_NAME;
@apxchpwd.sql
EOSQL < /opt/oracle/apex_pass_input.txt


sqlplus / as sysdba <<EOSQL
ALTER SESSION SET CONTAINER=$PDB_NAME;
ALTER USER APEX_PUBLIC_USER ACCOUNT UNLOCK;
ALTER USER APEX_240200 ACCOUNT UNLOCK;
EOSQL

echo "✅ APEX installation completed."
