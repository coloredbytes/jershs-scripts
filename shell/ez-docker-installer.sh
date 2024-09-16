#!/usr/bin/env bash
# Author: Joshua Ross
# Github: https://github.com/ColoredBytes
# Purpose: Docker Install Script


# Get the IP address of the host machine
host_ip=$(hostname -I | cut -d' ' -f1)

# Functions for type of OS.

install_docker_debian() {
    echo "Installing Docker on Debian..."
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    sudo systemctl enable docker
}

install_docker_ubuntu() {
    echo "Installing Docker on Ubuntu..."
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    sudo systemctl enable docker
}

install_docker_rhel_like() {
    echo "Installing Docker on RHEL-like system..."
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    sudo systemctl enable docker
}

# Detect the Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
elif type lsb_release >/dev/null 2>&1; then
    OS=$(lsb_release -si)
else
    OS=$(uname -s)
fi

case "$OS" in
    "Ubuntu")
        install_docker_ubuntu || echo "Error installing Docker on $OS"
        ;;
    "Debian GNU/Linux")
        install_docker_debian || echo "Error installing Docker on $OS"
        ;;
    "Red Hat Enterprise Linux" | "Fedora" | "Rocky Linux" | "AlmaLinux")
        install_docker_rhel_like || echo "Error installing Docker on $OS"
        ;;
    *)
        echo "Unsupported distribution: $OS"
        exit 1
        ;;
esac

# Check if Docker Installed Correctly
if ! command -v docker &>/dev/null; then
    echo "Docker installation failed. Please check the error messages above."
    exit 1
fi

echo "Docker has been installed successfully."

# Prompt the user for Portainer installation
read -p "Do you want to install Portainer? (yes/no): " verification

if [[ $verification =~ ^[Yy][Ee][Ss]$ ]]; then
    # Check if Docker is running
    if sudo systemctl is-active --quiet docker; then
        # Create Docker volume for Portainer data
        sudo docker volume create portainer_data

        # Run Portainer container
        sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always \
        -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data \
        portainer/portainer-ce:latest

        # Display the message with the IP address and port
        echo "Portainer has been installed and is now running at https://${host_ip}:9443"
    else
        echo "Docker is not running. Portainer installation aborted."
    fi
else
    echo "Portainer will not be installed."
fi
