#!/bin/bash

echo "Preparing pluggable DB..."

sqlplus / as sysdba <<EOF
ALTER PLUGGABLE DATABASE freepdb1 SAVE STATE;
exit;
EOF
