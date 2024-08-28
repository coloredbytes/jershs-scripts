#!/bin/bash
# @Author: Joshua Ross
# @Email: contact@rossjm.dev
# @Date: 2024-08-28 10:47:46
# @Last Modified by: Joshua Ross
# @Last Modified time: 2024-08-28 10:47:46
# @Description: Script to push local repos to GitHub.

# Variables
read -rp "What is the commit message? " COMMIT_MESSAGE
read -rp "What is the GitHub repo URL? " GIT_URL

# Functions
check_git() {
    if [ -d ".git" ]; then
        echo "This folder is already a Git repository."
    else
        echo "This folder is not a Git repository. Initializing..."
        git init
        echo "Git repository initialized."
    fi
}

check_remote() {
    if git remote | grep -q 'origin'; then
        echo "Remote 'origin' is already set."
    else
        git remote add origin "$GIT_URL"
        echo "Remote 'origin' added."
    fi
}

### Main Script ###
check_git
git add .
git commit -m "$COMMIT_MESSAGE"
git branch -M main
check_remote
git push -u origin main

# Job's Done
echo "Git repository has been pushed to GitHub."
