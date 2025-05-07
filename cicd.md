# CI/CD Setup Using `node-deploy-ssh.yml`

The `node-deploy-ssh.yml` workflow is designed to automate the deployment of Node.js-based applications (e.g., React, Next.js, Vite) to a remote server via SSH. Below are the steps to configure and use this workflow.

---

## Prerequisites

1. **GitHub Repository**: Ensure your application code is hosted in a GitHub repository.
2. **Remote Server**: A server with SSH access where the application will be deployed.
3. **Environment Variables**: If your application requires an `.env` file, ensure it is accessible in your repository or a secure location.
4. **Secrets Configuration**: Add the following secrets to your GitHub repository:
   - `SSH_HOST`: The hostname or IP address of the remote server.
   - `SSH_KEY`: The private SSH key for accessing the server.
   - `SSH_USER`: The username for the SSH connection.
   - `GH_TOKEN` (optional): A GitHub token for accessing private repositories or files.

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
| `BUILD_DIR_NAME`   | No       | The name of the build directory (e.g., `build`, `out`, `dist`). | `build`       |

---

## How to Use

1. **Reference the Workflow**:
   You can reference the workflow directly from the public `opendashboard-deployments` repository. Use the following syntax in your workflow file:

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
       secrets:
         SSH_HOST: ${{ secrets.SSH_HOST }}
         SSH_KEY: ${{ secrets.SSH_KEY }}
         SSH_USER: ${{ secrets.SSH_USER }}
         GH_TOKEN: ${{ secrets.GH_TOKEN }}
   ```

   **Note**: The `ENV_FILE_PATH` should be relative to the repository root and follow the format `/repository-name/contents/path/to/env-file`. For example, if the `.env` file is hosted in a repository named `configs` at the path `env/api.prod.env`, the `ENV_FILE_PATH` would be `/configs/contents/env/api.prod.env`.

---

## Deployment Process

- The workflow installs dependencies, builds the application, and compresses the build directory.
- It transfers the build artifact to the remote server via SCP.
- On the server, it extracts the artifact, optionally runs migrations and tests, and restarts the application.

---

## Supported Frameworks

This workflow supports any Node.js-based application, including:
- **React**: Ensure the `BUILD_DIR_NAME` is set to `build`.
- **Next.js**: Ensure the `BUILD_DIR_NAME` is set to `.next`.
- **Vite**: Ensure the `BUILD_DIR_NAME` is set to `dist`.

---

## Notes

- Ensure the remote server has Node.js installed and configured.
- Customize the `npm run deploy` script in your `package.json` to handle application-specific deployment steps.
- Use the `RUN_MIGRATION` and `RUN_TESTS` inputs as needed for your application.
- The CI is configured to pull `.env` files only from repositories owned by the same owner as the repository running the action.

For more details, refer to the comments in the `node-deploy-ssh.yml` file.
