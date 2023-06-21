#!/bin/sh

# Install Powershell
# Update the list of packages
sudo apt-get update
# Install pre-requisite packages.
sudo apt-get install -y wget apt-transport-https software-properties-common ca-certificates curl gnupg build-essential unzip
# Download the Microsoft repository GPG keys
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb
# Delete the the Microsoft repository GPG keys file
rm packages-microsoft-prod.deb
# Update the list of packages after we added packages.microsoft.com
sudo curl -fsSL https://test.docker.com -o test-docker.sh
sudo sh test-docker.sh
# Install Docker
#sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Install PowerShell
sudo apt-get install -y powershell
# Install Modules
sudo pwsh -NoProfile -Command "Install-Module -Name Az -Scope AllUsers -Repository PSGallery -Force"
sudo pwsh -NoProfile -Command "Install-Module -Name Az.Accounts -Scope AllUsers -Force"
sudo pwsh -NoProfile -Command "Install-Module -Name Az.DataFactory -Scope AllUsers -Force"
# Start PowerShell
pwsh

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install Python 
sudo apt-get update
sudo apt-get install -y python3 python3-pip
sudo pip install databricks-cli

# Install JDK 
sudo apt-get update
sudo apt-get install -y openjdk-11-jdk
