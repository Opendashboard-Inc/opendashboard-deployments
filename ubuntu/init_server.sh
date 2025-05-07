#!/bin/bash

set -e

echo "Running Nginx setup..."
./nginx_setup.sh

echo "Running Certbot setup..."
./certbot_setup.sh

echo "Running Node.js and PM2 setup..."
./node_pm2_setup.sh

# echo "Running Redis setup..."
# ./redis_setup.sh

echo "Running Firewall setup..."
./firewall_setup.sh

echo "Server provisioning completed successfully!"
