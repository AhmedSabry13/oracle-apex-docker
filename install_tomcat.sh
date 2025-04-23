#!/bin/bash

MAIN_DIR="/opt/oracle/extention/"   # Path where zip is located
ORDS_HOME="/opt/oracle/extention/ORDS" # Will extract here
TOMCAT_HOME="/opt/oracle/extention/tomcat"
CATALINA_HOME="/opt/oracle/extention/tomcat"
TARBALL="/opt/oracle/extention/jdk-21.tar.gz"  # Replace with the actual path to your JDK tarball
INSTALL_DIR="/opt/oracle/extention/java"           # Directory where Java will be installed
JDK_DIR="jdk-21.0.6"                  # Extracted JDK directory name, replace with the actual name   /opt/oracle/extention/java/jdk-21.0.6
JDK_PATH="$INSTALL_DIR/$JDK_DIR"
ORDS_CONFIG="/opt/oracle/ords_config"
PROFILE_FILE="$HOME/.bash_profile"
if [ ! -f "$PROFILE_FILE" ]; then
    echo "$PROFILE_FILE not found, creating new one."
    touch "$PROFILE_FILE"
fi


# Add JAVA_HOME and PATH to the profile
echo "export JAVA_HOME=$JDK_PATH" >> "$PROFILE_FILE"
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> "$PROFILE_FILE"

# Apply the changes
echo "Applying the environment variable changes..."
source "$PROFILE_FILE"

# Verify Java installation
echo "Verifying Java installation..."
java -version


mkdir -p $TOMCAT_HOME
tar xvf /opt/oracle/extention/tomcat.tar.gz --strip-components=1 -C $TOMCAT_HOME


# Copy ORDS WAR file into Tomcat webapps   /opt/oracle/extention/tomcat/webapps/ords_config

cp  /opt/oracle/extention/ORDS/ords.war $TOMCAT_HOME/webapps/ords.war
# Copy APEX images to /i/ folder
#cp  /opt/oracle/extention/apex/images $TOMCAT_HOME/webapps/i
mkdir -p  $TOMCAT_HOME/webapps/i

cp -r /opt/oracle/extention/apex/images/*  $TOMCAT_HOME/webapps/i


#chmod 777 -R /opt/oracle/
export JAVA_OPTS="-Dconfig.url=${ORDS_CONFIG} -Xms1024M -Xmx1024M"

echo "Starting Tomcat..."
$CATALINA_HOME/bin/catalina.sh run 
