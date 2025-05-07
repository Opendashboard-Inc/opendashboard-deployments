# Deployments

This repository contains scripts and workflows to automate the deployment of Node.js-based applications (e.g., React, Next.js, Vite) and includes instructions for provisioning a server, setting up domains, configuring SSL, and setting up CI/CD pipelines.

---

## Features

1. **Server Provisioning**:
   - Install and configure essential services like Nginx, Node.js, PM2, Redis, and Certbot.
   - Set up a secure firewall to protect the server.

2. **Domain Setup**:
   - Configure domains with Nginx.
   - Obtain and manage SSL certificates using Certbot.

3. **Node.js Application Deployment**:
   - Clone and deploy Node.js applications from Git repositories.
   - Automatically handle environment variables, build processes, and application startup.

4. **GitHub Actions Workflow**:
   - Use the `node-deploy-ssh.yml` workflow to automate deployments via SSH.

---

## Getting Started

To get started, follow the instructions in the [ubuntu/readme.md](ubuntu/readme.md) file. This includes:
1. Provisioning the server.
2. Setting up domains.
3. Deploying Node.js applications.

---

## CI/CD Setup

For detailed instructions on setting up CI/CD pipelines using the `node-deploy-ssh.yml` workflow, refer to the [cicd.md](cicd.md) file.

---

## Detailed Instructions

- For **server provisioning**, refer to the [ubuntu/readme.md](ubuntu/readme.md) file.
- For **setting up a website and deploying Node.js applications**, refer to the [ubuntu/website.md](ubuntu/website.md) file.

---

## Supported Frameworks

This repository supports any Node.js-based application, including:
- **React**: Ensure the build directory is set to `build`.
- **Next.js**: Ensure the build directory is set to `.next`.
- **Vite**: Ensure the build directory is set to `dist`.

---

## Notes

- Ensure that all required secrets (e.g., deploy tokens) are configured in your GitHub repository.
- The scripts are designed to work on Ubuntu-based servers.
- If you encounter any issues, refer to the logs or test individual components (e.g., Nginx, Node.js).

For more details, explore the scripts and documentation in the `ubuntu` folder.
