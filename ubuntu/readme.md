
# Server Provisioning Scripts

These scripts automate the provisioning of a server, setting up a domain, SSL, and deploying a Node.js application.

## Steps to Provision the Server

1. **Login to the server**.
2. **Navigate to the `/opt/` directory**:
   ```bash
   cd /opt/
   ```
3. **Create a directory for deployment scripts** (you can name it as you prefer, e.g., `deployments`):
   ```bash
   mkdir -p deployments
   cd deployments
   ```
4. **Clone the repository into the current directory**:
   ```bash
   git clone https://github.com/Opendashboard-Inc/opendashboard-deployments .
   ```
5. **Navigate to the `ubuntu` folder**:
   ```bash
   cd ubuntu
   ```
6. **Make the scripts executable**:
   ```bash
   chmod +x *.sh
   ```
7. **Run the initialization script**:
   ```bash
   ./init_server.sh
   ```
8. **Test the server**: Visit the server's IP in a browser. You should see "Welcome to Nginx."

## Setting Up a Website and Node.js Application

For detailed instructions on setting up a website and deploying a Node.js application, refer to the [website.md](website.md) file.

## Script Descriptions

- `nginx_setup.sh`: Installs and configures Nginx.
- `certbot_setup.sh`: Installs Certbot and sets up SSL certificates.
- `node_pm2_setup.sh`: Installs Node.js and PM2 for managing Node.js applications.
- `redis_setup.sh`: Installs and configures Redis.
- `firewall_setup.sh`: Configures the firewall to allow SSH and Nginx traffic.
- `setup_domain.sh`: Configures a domain and sets up SSL.
- `setup_nodejs_app.sh`: Deploys a Node.js application.
- `init_server.sh`: Runs all the above scripts in sequence.

If you encounter issues pulling the repository, reset the repository and re-run the `chmod` command:
```bash
git checkout -- .
chmod +x *.sh
```
