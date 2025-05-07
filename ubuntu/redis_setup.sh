#!/bin/bash

set -e

echo "Installing Redis..."
sudo apt install redis-server -y

echo "Starting Redis..."
sudo systemctl start redis-server

echo "Enabling Redis to start on boot..."
sudo systemctl enable redis-server

echo "Checking Redis status..."
sudo systemctl status redis-server

echo "Redis setup completed successfully."
