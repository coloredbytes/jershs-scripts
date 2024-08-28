#!/usr/bin/env bash

# Prompt for user input
read -rp "What is the script name? " scriptname
read -rp "What is your name?" author_name
read -rp "What is your GitHub profile URL?" profile_url
read -rp "What is the purpose of the script? " purpose


# Define additional variables
currentDateTime=$(date +"%m/%d/%Y")

# Create the output string
outputString=$(cat <<EOF
# =============================================================================
# Script Name: $scriptname
# Author: $author_name
# GitHub: $profile_url
# Purpose: $purpose
# Date: $currentDateTime
# =============================================================================
EOF
)

# Output the final string
echo "$outputString"



