#!/bin/bash

# Apply patches
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible

# Install Ansible
sudo apt-get install -y ansible

