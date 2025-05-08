#!/bin/bash

set -e

# Function to display usage instructions
usage() {
    echo "Usage: $0 -d domainname -g repoUrl -b branchname -t deploy_token -p portNumber [-e envfile_path]" >&2
    exit 1
}

# Function to backup nginx configuration file
backup_conf() {
    local conf_file="$1"
    local backup_file="$2"
    sudo cp "$conf_file" "$backup_file"
}

# Function to append or update proxy_pass in the existing server block
append_or_update_proxy_pass() {
    local conf_file="$1"
    local port="$2"
    if sudo grep -q "location / {" "$conf_file"; then
        echo "Updating existing location / block with proxy_pass..."
        sudo sed -i "/location \/ {/!b;n;c\\
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;\\
        proxy_set_header Host \$host;\\
        proxy_pass http://localhost:$port;\\
        proxy_http_version 1.1;\\
        proxy_set_header Upgrade \$http_upgrade;\\
        proxy_set_header Connection 'upgrade';" "$conf_file"
    else
        echo "Appending new location / block with proxy_pass..."
        sudo sed -i "/server_name $domainname;/a \\
        location / {\\
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;\\
            proxy_set_header Host \$host;\\
            proxy_pass http://localhost:$port;\\
            proxy_http_version 1.1;\\
            proxy_set_header Upgrade \$http_upgrade;\\
            proxy_set_header Connection 'upgrade';\\
        }" "$conf_file"
    fi
}

# Parse command line options
while getopts ":d:e:g:b:t:p:" opt; do
    case $opt in
        d)
            domainname="$OPTARG"
            ;;
        e)
            envfile_path="$OPTARG"
            ;;
        g)
            repoUrl="$OPTARG"
            ;;
        b)
            branchname="$OPTARG"
            ;;
        t)
            deploy_token="$OPTARG"
            ;;
        p)
            portNumber="$OPTARG"
            ;;
        *)
            usage
            ;;
    esac
done

# Check if required options are provided
if [ -z "$domainname" ]; then
    echo "Error: Missing domainname parameter." >&2
    usage
fi
if [ -z "$repoUrl" ]; then
    echo "Error: Missing repoUrl parameter." >&2
    usage
fi
if [ -z "$branchname" ]; then
    echo "Error: Missing branchname parameter." >&2
    usage
fi
if [ -z "$deploy_token" ]; then
    echo "Error: Missing deploy_token parameter." >&2
    usage
fi
if [ -z "$portNumber" ]; then
    echo "Error: Missing portNumber parameter." >&2
    usage
fi

# Check if nginx configuration file exists
nginx_conf="/etc/nginx/sites-available/$domainname.conf"
if [ ! -f "$nginx_conf" ]; then
    echo "Error: Nginx configuration file $nginx_conf not found." >&2
    exit 1
fi

# Backup nginx configuration file
backup_file="/etc/nginx/sites-available/$domainname-$(date +"%Y-%m-%d-%H-%M-%S").conf.bk"
backup_conf "$nginx_conf" "$backup_file"

# Create directory for the domain
sudo mkdir -p /var/www/$domainname/node_root

# Navigate to the created directory
cd /var/www/$domainname/node_root || exit

# Add deploy token to repo URL
if [[ "$repoUrl" != *"@"* ]]; then
    repoUrl="https://$deploy_token@$repoUrl"
fi

# Add ".git" to repo URL if it doesn't end with it
if [[ "$repoUrl" != *".git" ]]; then
    repoUrl="$repoUrl.git"
fi

# Clone the repo
git clone "$repoUrl" .

# Switch to specified branch
git checkout "$branchname" || { echo "Error: Branch $branchname not found." >&2; exit 1; }

# If env file is provided, copy it to the directory
if [ -n "$envfile_path" ]; then
    if [[ "$envfile_path" == /* ]]; then
        echo "Fetching .env file from repository..."
        curl -H "Authorization: token $deploy_token" -L "https://api.github.com/repos${envfile_path}" -o .env || { echo "Error: Failed to fetch .env file."; exit 1; }
    else
        echo "Error: Invalid envfile_path format. It must start with '/'."
        exit 1
    fi
fi

echo "Installing dependencies..."
npm install || { echo "Error: Failed to install dependencies."; exit 1; }

echo "Running migrations..."
npm run migrate:run || { echo "Error: Failed to run migrations."; exit 1; }

echo "Building the application..."
npm run build || { echo "Error: Failed to build the application."; exit 1; }

echo "Starting the application..."
npm run deploy || { echo "Error: Failed to start the application."; exit 1; }

# Append or update proxy_pass in nginx configuration
append_or_update_proxy_pass "$nginx_conf" "$portNumber"

# Test nginx configuration
sudo nginx -t || { echo "Error: Nginx configuration test failed. Rolling back changes..." >&2; sudo mv "$backup_file" "$nginx_conf"; exit 1; }

echo "Restarting Nginx..."
sudo systemctl restart nginx || { echo "Error: Failed to restart Nginx."; exit 1; }

echo "Node.js application setup completed successfully."
