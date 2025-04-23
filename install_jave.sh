#!/bin/bash

# Define Java tarball location and installation directory

TARBALL="/opt/oracle/extention/jdk-21.tar.gz"  # Replace with the actual path to your JDK tarball
INSTALL_DIR="/opt/oracle/extention/java"           # Directory where Java will be installed
JDK_DIR="jdk-21.0.6"                  # Extracted JDK directory name, replace with the actual name   /opt/oracle/extention/java/jdk-21.0.6

# Check if the tarball exists
if [ ! -f "$TARBALL" ]; then
    echo "Error: Java tarball ($TARBALL) not found!"
    exit 1
fi

# Create the installation directory
echo "Creating directory $INSTALL_DIR..."
 mkdir -p "$INSTALL_DIR"

# Extract the tarball to the installation directory
echo "Extracting $TARBALL to $INSTALL_DIR..."
 tar -xzvf "$TARBALL" -C "$INSTALL_DIR"

# Set the extracted JDK directory
JDK_PATH="$INSTALL_DIR/$JDK_DIR"

# Check if the extraction was successful
if [ ! -d "$JDK_PATH" ]; then
    echo "Error: Failed to extract Java. Directory $JDK_PATH does not exist."
    exit 1
fi

# Set Java environment variables
echo "Setting Java environment variables..."

# Backup the profile file
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

if [ $? -eq 0 ]; then
    echo "Java installation successful."
else
    echo "Error: Java installation failed."
    exit 1
fi

echo "Java installation script completed successfully."

