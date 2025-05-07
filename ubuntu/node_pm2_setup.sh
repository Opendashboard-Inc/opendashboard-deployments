#!/bin/bash

set -e

echo "Installing Node.js v18 using NodeSource..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "Installing PM2 globally..."
sudo npm install -g pm2

echo "Checking Node.js version..."
node -v

echo "Checking PM2 version..."
pm2 -v

echo "Node.js and PM2 setup completed successfully."
