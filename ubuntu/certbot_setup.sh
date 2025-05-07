#!/bin/bash

set -e

echo "Updating package index..."
sudo apt update

echo "Installing Certbot and Nginx plugin..."
sudo apt install certbot python3-certbot-nginx -y

echo "Obtaining SSL certificate for Nginx configuration..."
sudo certbot --nginx || { echo "Error: Failed to obtain SSL certificate."; exit 1; }

echo "Enabling automatic certificate renewal..."
sudo systemctl enable certbot.timer

echo "Certbot setup completed successfully."
