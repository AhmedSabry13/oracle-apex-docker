#!/bin/bash

echo "example ORDS "
# CONFIGURABLE VARIABLES
ORDS_ZIP="ords.zip"  # Change to your actual APEX zip
ORDS_SRC_DIR="/opt/oracle/extention/"   # Path where zip is located
ORDS_HOME="/opt/oracle/extention/ORDS" # Will extract here
PDB_NAME="FREEPDB1"
ORDS_PASS="Oracle123"  # Change to your desired APEX admin password
ORDS_PASS_WEB="Oracle_1234"
ORDS_ADMIN="ADMIN"
ORDS_MAIL="ahmednaruto13@gmail.com"


unzip -q "$ORDS_SRC_DIR/$ORDS_ZIP" -d "$ORDS_HOME"

cd $ORDS_HOME

export PATH="$PATH:/opt/oracle/extention/ORDS/bin"
echo 'export PATH="$PATH:/opt/oracle/extention/ORDS/bin"' >> ~/.bash_profile
source ~/.bash_profile

#ords --config /opt/oracle/ords_config install --admin-user SYS --db-hostname localhost --db-port 1521 --db-servicename $PDB_NAME --feature-rest-enabled-sql true --feature-db-api true 
#$ORDS_PASS
#ords --config /opt/oracle/ords_config serve 
ords --config /opt/oracle/ords_config install --admin-user SYS --db-hostname localhost --db-port 1521 --db-servicename $PDB_NAME --feature-rest-enabled-sql true --feature-db-api true --password-stdin < /opt/oracle/opass.txt



echo "Done expose"