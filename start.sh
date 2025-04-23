#!/bin/bash

echo "Starting Oracle Database..."
/bin/bash -c "$ORACLE_BASE/$RUN_FILE" &

# Optional: Wait for DB to be ready
# Initialize counter
countl=0

# Wait until the listener is up and running
echo "Waiting for Oracle Listener to start..."
until lsnrctl status | grep -q '"FREE", status READY'; do
  countl=$((countl + 1))
  echo "[$countl] Listener not ready yet, sleeping..."
  sleep 5
  
done
count=0
while true; do
    ((count++))
    echo "Checking database status... Attempt $count"

    STATUS=$(echo "SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF;
                  SELECT status FROM v\$instance;
                  EXIT;" | sqlplus -s / as sysdba)

    if [[ "$STATUS" == "OPEN" ]]; then
        echo "✅ Database is OPEN after $count attempts."
        break
    else
        echo "⏳ Database not open yet (current status: $STATUS). Retrying in 5 seconds..."
        sleep 5
    fi
done

countpdb=0
pdb_name="FREEPDB1"

while true; do
    ((countpdb++))
    echo "Checking PDB '$pdb_name' status... Attempt $countpdb"

    STATUS=$(echo "SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF;
                  SELECT open_mode FROM v\$pdbs WHERE name = UPPER('$pdb_name');
                  EXIT;" | sqlplus -s / as sysdba)

    if [[ "$STATUS" == "READ WRITE" ]]; then
        echo "✅ PDB '$pdb_name' is OPEN after $countpdb attempts."
        break
    else
        echo "⏳ PDB not open yet (current mode: $STATUS). Retrying in 5 seconds..."
        sleep 5
    fi
done

# Now run the post-start script
echo "Running password change script..."
/home/oracle/setPassword.sh Oracle123
echo "Password change script executed."

# Keep the container alive (optional)

/opt/oracle/install_jave.sh

echo "end java"
/opt/oracle/installapex.sh
echo "end apex"
/opt/oracle/install_ords.sh
echo "end ords"
/opt/oracle/install_tomcat.sh
echo "end tomcat"





wait
