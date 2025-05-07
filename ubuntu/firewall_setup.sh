#!/bin/bash

set -e

echo "Allowing SSH traffic..."
sudo ufw allow ssh

echo "Allowing Nginx Full traffic..."
sudo ufw allow 'Nginx Full'

echo "Denying all other incoming connections..."
sudo ufw default deny incoming

echo "Enabling firewall..."
sudo ufw enable

echo "Displaying firewall status..."
sudo ufw status

echo "Firewall setup completed successfully."
