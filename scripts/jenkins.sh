#!/bin/bash

until ping -c1 8.8.8.8 &>/dev/null; do
  echo "Waiting for internet..."
  sleep 5
done

set -e


echo ">>> Installing patches for Jenkins"
sudo apt-get update -y

sudo apt update
sudo apt install fontconfig openjdk-17-jre -y

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
  sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null


echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null


sudo apt-get update -y
sudo apt-get install -y jenkins 
sudo systemctl enable jenkins
sudo systemctl start jenkins
echo ">>> Jenkins installation completed!"
echo "Jenkins is up and running on port 8080"
echo "You can access it using http://<your_server_ip>:8080"
echo "To get the initial admin password, run:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword" 
echo ">>> Jenkins setup script completed!"
