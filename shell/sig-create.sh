#!/usr/bin/env bash

# Prompt for user input
read -p "What is the script name? " scriptname
read -p "What is the purpose of the script? " purpose

# Define additional variables
author="Joshua Ross"
githubUrl="https://github.com/ColoredBytes"
license="MIT License (if applicable)"
currentDateTime=$(date +"%m/%d/%Y")

# Create the output string
outputString=$(cat <<EOF
# =============================================================================
# Script Name: $scriptname
# Author: $author
# GitHub: $githubUrl
# Purpose: $purpose
# Date: $currentDateTime
# License: $license
# =============================================================================
EOF
)

# Output the final string
echo "$outputString"

# Copy the final string to the clipboard (requires xclip or pbcopy depending on the OS)
# Uncomment the appropriate line based on your OS:
# echo "$outputString" | xclip -selection clipboard   # For Linux with xclip
# echo "$outputString" | pbcopy                       # For macOS with pbcopy


