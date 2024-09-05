#!/bin/bash
# =============================================================================
# Script Name: OVA Import Tool
# Author: Joshua Ross
# Purpose: Import OVA's into Proxmox
# Date: 09/05/2024
# =============================================================================

# Create a temporary directory
TMP=$(mktemp -d)

# Function to handle cleanup on failure
cleanup() {
    echo "An error occurred. Cleaning up..."
    rm -rf "$TMP"
    exit 1
}

# Trap any errors and call the cleanup function
trap cleanup ERR

# Prompt the user for the URL
read -rp "What is the URL? " URL

# Extract the filename from the URL
FILENAME=$(basename "$URL")

# Download the file into the temporary directory
echo "Downloading the file..."
wget -P "$TMP" "$URL" || cleanup

# Path to the downloaded file
FILEPATH="$TMP/$FILENAME"

# Extract the OVA file (which is a tar archive)
echo "Extracting the OVA file..."
tar -xvf "$FILEPATH" -C "$TMP" || cleanup

# Find the .ovf file in the extracted contents
OVF_FILE=$(find "$TMP" -name "*.ovf")

# Check if the .ovf file was found
if [ -n "$OVF_FILE" ]; then
    echo "OVF file found: $OVF_FILE"
    
    # Prompt for VM ID and storage name for Proxmox import
    read -rp "Enter the VM ID (e.g., 300): " VM_ID
    read -rp "Enter the storage name (e.g., HDD_500GB): " STORAGE_NAME

    # Import the OVF into Proxmox using qm importovf
    echo "Importing the OVF into Proxmox..."
    qm importovf "$VM_ID" "$OVF_FILE" "$STORAGE_NAME" --format qcow2 || cleanup

    echo "Import completed successfully."

    # Clean up the temporary directory
    echo "Cleaning up..."
    rm -rf "$TMP"
else
    echo "No OVF file found in the extracted contents."
    cleanup
fi

