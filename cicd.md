# CI/CD Setup Using `node-deploy-ssh.yml`

The `node-deploy-ssh.yml` workflow is designed to automate the deployment of Node.js-based applications (e.g., React, Next.js, Vite) to a remote server via SSH. Below are the steps to configure and use this workflow.

---

## Prerequisites

1. **GitHub Repository**: Ensure your application code is hosted in a GitHub repository.
2. **Remote Server**: A server with SSH access where the application will be deployed.
3. **Environment Variables**: If your application requires an `.env` file, ensure it is accessible in your repository or a secure location.
4. **Secrets and Variables Configuration**:
   - Add the following **secrets** to your GitHub repository or organization:
     - `SSH_KEY`: The private SSH key for accessing the server.
     - `SSH_USER`: The username for the SSH connection.
     - `GH_TOKEN` (optional): A GitHub token for accessing private repositories or files.
   - Add the following **variable** to your GitHub repository or organization:
     - `SSH_HOST`: The hostname or IP address of the remote server.

---

## Workflow Inputs

The workflow accepts the following inputs:

| Input Name         | Required | Description                                                  | Default Value |
|--------------------|----------|--------------------------------------------------------------|---------------|
| `NAME`             | Yes      | A unique name for the deployment (e.g., project name).       | -             |
| `PROJECT_PATH`     | Yes      | The path to the project directory on the remote server.      | -             |
| `ENV_FILE_PATH`    | No       | The path to the `.env` file in the repository (if required). | -             |
| `RUN_MIGRATION`    | No       | Whether to run database migrations (`true` or `false`).      | `false`       |
| `RUN_TESTS`        | No       | Whether to run tests before deployment (`true` or `false`).  | `false`       |
| `EXECUTE_DEPLOYMENT` | No     | Whether to execute the deployment process (`true` or `false`). | `false`       |
| `REDEPLOY`         | No       | Whether to refresh `.env` and redeploy the application.      | `false`       |
| `BUILD_DIR_NAME`   | No       | The name of the build directory (e.g., `build`, `out`, `dist`). | `build`       |
| `SSH_HOST`         | Yes      | The hostname or IP address of the remote server.             | -             |

---

## How to Use

### Full Deployment

To perform a full deployment, use the following configuration:

```yaml
# filepath: .github/workflows/deploy.yml
name: Deploy Application

on:
  push:
    branches:
      - main

jobs:
  deploy:
    uses: Opendashboard-Inc/opendashboard-deployments/.github/workflows/node-deploy-ssh.yml@main
    with:
      NAME: "my-app"
      PROJECT_PATH: "/var/www/my-app"
      ENV_FILE_PATH: "/configs/contents/env/api.prod.env"
      RUN_MIGRATION: true
      RUN_TESTS: true
      EXECUTE_DEPLOYMENT: true
      BUILD_DIR_NAME: "build"
      SSH_HOST: "your-server-ip-or-hostname"
    secrets:
      SSH_KEY: ${{ secrets.SSH_KEY }}
      SSH_USER: ${{ secrets.SSH_USER }}
      GH_TOKEN: ${{ secrets.GH_TOKEN }}
```

### Redeploy Only

To refresh the `.env` file and redeploy the application without a full deployment, use the following configuration:

```yaml
# filepath: .github/workflows/redeploy.yml
name: Redeploy Application

on:
  workflow_dispatch:

jobs:
  redeploy:
    uses: Opendashboard-Inc/opendashboard-deployments/.github/workflows/node-deploy-ssh.yml@main
    with:
      PROJECT_PATH: "/var/www/my-app"
      ENV_FILE_PATH: "/configs/contents/env/api.prod.env"
      REDEPLOY: true
      SSH_HOST: "your-server-ip-or-hostname"
    secrets:
      SSH_KEY: ${{ secrets.SSH_KEY }}
      SSH_USER: ${{ secrets.SSH_USER }}
      GH_TOKEN: ${{ secrets.GH_TOKEN }}
```

---

## Notes

- Ensure the remote server has Node.js installed and configured.
- Use the `REDEPLOY` option for quick updates to environment variables and application restarts.
- For full deployments, use the `EXECUTE_DEPLOYMENT` option with other inputs like `RUN_MIGRATION` and `RUN_TESTS`.

For more details, refer to the comments in the `node-deploy-ssh.yml` file.
