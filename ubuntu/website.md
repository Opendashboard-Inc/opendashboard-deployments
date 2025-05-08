
# Setting Up a Website and Node.js Application

This guide provides detailed instructions for setting up a website and deploying a Node.js application using the provided scripts.

---

## Prerequisites

Before proceeding, ensure that all the steps in the [README.md](readme.md) file have been executed. This includes:
1. Logging into the server.
2. Navigating to `/opt/`.
3. Creating the `deployments` directory and cloning the repository.
4. Navigating to the `ubuntu` folder.
5. Making the scripts executable.

Additionally, **the server must have been initialized** using the `init_server.sh` script. If this has not been done, run the following command first:
```bash
./init_server.sh
```

Once the prerequisites are complete, navigate to the `ubuntu` folder:
```bash
cd /opt/deployments/ubuntu
```

---

## Setting Up a Website

1. **Run the `setup_domain.sh` script**:
   Use the `setup_domain.sh` script to configure a domain and set up SSL.
   ```bash
   ./setup_domain.sh -d yourdomain.com
   ```
   Replace `yourdomain.com` with your actual domain name.

2. **Verify the Domain**:
   Ensure that your domain is pointing to the server's IP address before running the script. The script will check this automatically.

3. **Access the Website**:
   After the script completes, visit `https://yourdomain.com` in a browser. You should see a default "It works" page.

---

## Deploying a Node.js Application

1. **Run the `setup_nodejs_app.sh` script**:
   Use the `setup_nodejs_app.sh` script to deploy your Node.js application.
   ```bash
   ./setup_nodejs_app.sh -d yourdomain.com -g your-repo-url -b branch-name -p port-number [-t deploy-token] [-e /repo-name/contents/path/to/env-file]
   ```
   Replace the placeholders with the following:
   - `yourdomain.com`: The domain name for your application.
   - `your-repo-url`: The URL of your Git repository.
   - `branch-name`: The branch to deploy (e.g., `main`).
   - `port-number`: The port number your application will run on (e.g., `3000`).
   - `deploy-token` (optional): The deploy token for accessing private repositories.
   - `/repo-name/contents/path/to/env-file` (optional): The path to the `.env` file in a GitHub repository. If provided, it will be fetched automatically.

2. **Verify the Deployment**:
   - Ensure the application is running by visiting `https://yourdomain.com` in a browser.
   - The script will append or update the `proxy_pass` configuration in the existing Nginx server block.

3. **Environment File**:
   - If the `.env` file is required, ensure it is hosted in a repository accessible with the provided deploy token (if applicable).
   - Use the format `/repo-name/contents/path/to/env-file` for the `-e` option.

4. **Application Logs**:
   - Use PM2 to manage and view application logs:
     ```bash
     pm2 logs
     ```

---

## Example: End-to-End Setup and Deployment

### Scenario
You want to set up a website and deploy a Node.js application for the domain `example.com`. The application is hosted in a private GitHub repository, and you have a deploy token to access it.

### Steps

1. **Ensure Prerequisites Are Complete**:
   Make sure all the steps in the [README.md](readme.md) file have been executed, and the server has been initialized. Then navigate to the `ubuntu` folder:
   ```bash
   cd /opt/deployments/ubuntu
   ```

2. **Set Up the Domain**:
   Run the `setup_domain.sh` script to configure the domain and set up SSL:
   ```bash
   ./setup_domain.sh -d example.com
   ```
   This will:
   - Create a directory for the domain at `/var/www/example.com/html`.
   - Configure an Nginx server block for the domain.
   - Obtain an SSL certificate for `example.com`.

3. **Deploy the Node.js Application**:
   Run the `setup_nodejs_app.sh` script to deploy the application:
   ```bash
   ./setup_nodejs_app.sh -d example.com -g github.com/your-org/your-repo -b main -t your-deploy-token -p 3000 -e /your-repo/contents/env/api.prod.env
   ```
   This will:
   - Clone the repository `github.com/your-org/your-repo` into `/var/www/example.com/node_root`.
   - Switch to the `main` branch.
   - Fetch the `.env` file from the repository path `/your-repo/contents/env/api.prod.env` (if provided).
   - Install dependencies, run migrations, and build the application.
   - Start the application on port `3000` using PM2.
   - Update the Nginx server block to proxy requests to the application running on port `3000`.

4. **Verify the Setup**:
   - Visit `https://example.com` in a browser to ensure the application is running.
   - Check the application logs using PM2:
     ```bash
     pm2 logs
     ```

---

## Notes

- Ensure that all required secrets (e.g., deploy token) are valid and accessible.
- The scripts handle SSL setup, Nginx configuration, and application deployment automatically.
- If you encounter any issues, refer to the logs or test individual components (e.g., Nginx, Node.js).

For further assistance, refer to the main [README.md](readme.md) file.
