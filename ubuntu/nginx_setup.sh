#!/bin/bash

set -e

echo "Updating package index..."
sudo apt update

echo "Installing Nginx..."
sudo apt install nginx -y

echo "Starting Nginx..."
sudo systemctl start nginx

echo "Enabling Nginx to start on boot..."
sudo systemctl enable nginx

echo "Checking Nginx status..."
sudo systemctl status nginx

echo "Nginx setup completed successfully."
