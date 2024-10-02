#! /usr/bin/env bash

# =============================================================================
# Script Name: docker-lxc
# Author: Joshua Ross
# Purpose: Install Docker on Proxmox LXC.
# Date: 10/02/2024
# =============================================================================

### Functions ###
docker_install() {
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
}

add_user() {
  read -rp "What is the user?" CREATED_USER
  adduser "$CREATED_USER"
}

### Main Script ###
add_user
docker_install

### Add User to Docker Group ###
usermod -aG docker "CREATED_USER"
newgrp docker


