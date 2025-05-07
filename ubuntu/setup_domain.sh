#!/bin/bash

set -e

# Function to display usage instructions
usage() {
    echo "Usage: $0 -d domainname" >&2
    exit 1
}

# Function to check if domain points to server's IP
check_domain() {
    local domain="$1"
    local server_ip="$2"

    local domain_ip=$(dig +short "$domain")

    if [ "$domain_ip" != "$server_ip" ]; then
        echo "Error: Domain $domain is not pointing to this server's IP address." >&2
        exit 1
    fi
}

# Get server's IP address
server_ip=$(hostname -I | cut -d' ' -f1)

# Parse command line options
while getopts ":d:" opt; do
    case $opt in
        d)
            domainname="$OPTARG"
            ;;
        *)
            usage
            ;;
    esac
done

# Check if domainname is provided
if [ -z "$domainname" ]; then
    usage
fi

# Check if the domain points to the server's IP address
check_domain "$domainname" "$server_ip"

# Log when the script is started
echo "Setting up domain $domainname..."

# Create directory for the domain
sudo mkdir -p /var/www/$domainname/html

# Navigate to the directory where the domain's HTML will be hosted
cd /var/www/$domainname/html

# Create index.html file with "it works" content
echo "It works" > index.html

# Go to nginx configuration directory
cd /etc/nginx/sites-available

# Create server block configuration file
sudo tee $domainname.conf > /dev/null <<EOF
server {
    listen 80;
    listen [::]:80;

    server_name $domainname;

    root /var/www/$domainname/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Create symlink to sites-enabled directory
sudo ln -s /etc/nginx/sites-available/$domainname.conf /etc/nginx/sites-enabled/

# Test nginx configuration
echo "Testing Nginx configuration..."
sudo nginx -t || { echo "Error: Nginx configuration test failed."; exit 1; }

# Reload nginx to apply changes
echo "Reloading Nginx..."
sudo systemctl reload nginx

# Install Certbot and obtain SSL certificate
echo "Obtaining SSL certificate for $domainname..."
sudo certbot --nginx -d "$domainname" --non-interactive --agree-tos -m your_email@example.com || { echo "Error: Failed to obtain SSL certificate."; exit 1; }

# Log completion
echo "Domain $domainname setup completed successfully."

