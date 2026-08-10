# Troubleshooting RDS Connection Issues in Keeper App

## Overview
The Keeper App is a full-stack note-taking application with a React frontend, Flask backend, and PostgreSQL database hosted on AWS RDS. When adding notes fails with errors, it often indicates the backend cannot connect to or authenticate with the RDS instance. This guide covers diagnosis and fixes based on the app's architecture.

## Root Cause Analysis
- **Database Connection Logic**: The backend uses SQLAlchemy with connection details from environment variables (e.g., `DB_HOST`, `DB_USER`) in `backend/app/config.py`. In production, these are set via Docker environment variables during EC2 deployment.
- **Workflow Issue**: GitHub Actions deploys the backend to EC2 via Docker, but required environment variables for RDS (e.g., `RDS_INSTANCE_ENDPOINT`, `RDS_INSTANCE_USERNAME`) are not properly set before the SSH deployment step. This leads to undefined values, causing `DB_HOST` to default to `'localhost'`, which fails on EC2.
- **RDS Provisioning**: RDS is created via Terraform (`Terraform/database.tf` and RDS module). The workflow applies the full plan, but if RDS isn't created, check AWS console for the instance.
- **Security/Network**: RDS is in private subnets with a security group allowing traffic from EC2 SG on port 5432. Connection failures may indicate subnet routing or SG issues.
- **Credentials/Endpoint Mismatch**: Incorrect env vars (e.g., wrong endpoint from Terraform output) cause failures. Check EC2 container logs (`docker logs myapp`) for SQLAlchemy errors like "connection refused" or "authentication failed."
- **Other Possibilities**: RDS may not be fully ready (provisioning takes 10-15 minutes), or there could be typos in the Docker run command.

## Immediate Fixes
Update `.github/workflows/deployment.yaml` to set RDS-related environment variables in the `deploy-app` job. Add a new step **before** the "Deploy Docker Image to EC2 Instance" step to export them from Terraform outputs and secrets.

```yaml
# ... existing steps ...

- name: Set DB Environment Variables
  run: |
    echo "RDS_INSTANCE_ENDPOINT=${{ needs.deploy-infra.outputs.rds_instance_endpoint }}" >> $GITHUB_ENV
    echo "RDS_INSTANCE_PORT=${{ needs.deploy-infra.outputs.rds_instance_port }}" >> $GITHUB_ENV
    echo "RDS_INSTANCE_NAME=${{ needs.deploy-infra.outputs.rds_instance_name }}" >> $GITHUB_ENV
    echo "RDS_INSTANCE_USERNAME=${{ secrets.AWS_RDS_USERNAME }}" >> $GITHUB_ENV
    echo "RDS_INSTANCE_PASSWORD=${{ secrets.AWS_RDS_PASSWORD }}" >> $GITHUB_ENV

- name: Deploy Docker Image to EC2 Instance
  # ... existing SSH action ...
```

- **Why this fixes it**: The SSH action's `envs` will now have defined values. Without this, `$RDS_INSTANCE_ENDPOINT` etc. are empty, causing `DB_HOST` to default incorrectly.
- **Test After Fix**: Push to `main`, monitor workflow logs for the "Set DB Environment Variables" step, and check EC2 logs (`docker logs myapp`) for connection errors. If the RDS endpoint is wrong, verify Terraform outputs in workflow logs.

## Additional Debugging Steps
- **Check RDS Status**: In AWS console (RDS > Databases), confirm the instance exists, is in "available" state, and note its endpoint/port. Ensure it's in the correct VPC/subnets.
- **Verify Security Groups**: In AWS EC2 > Security Groups, check that the DB SG allows inbound from the EC2 SG on port 5432. The ingress rule is created in `Terraform/networking.tf`.
- **Test Locally**: Run the backend locally with RDS credentials (update `backend/app/config.py` to use production env vars) and test the API. Use tools like `psql` to connect directly to RDS.
- **Logs and Errors**:
  - Frontend: Check browser console for Axios errors (e.g., 500 from backend).
  - Backend: SSH into EC2 (`ssh ubuntu@<elastic_ip>`) and run `docker logs myapp` for SQLAlchemy traces.
  - Workflow: Review GitHub Actions logs for Terraform apply errors or undefined vars.
- **Common Errors**:
  - "OperationalError: (psycopg2.OperationalError) connection to server at ... failed": Endpoint/port wrong or SG blocking.
  - "FATAL: password authentication failed": Username/password mismatch (check secrets).
  - If RDS isn't created, re-run Terraform manually: `terraform apply` in `./Terraform` with vars.

## Prevention for Future
- Add health checks in the workflow (e.g., a step to ping the RDS endpoint after Terraform apply).
- Use AWS Secrets Manager for DB creds instead of GitHub secrets for better security.
- Ensure Terraform state is consistent (check the S3 backend in `Terraform/provider.tf`).

If these steps don't resolve the issue, share the exact error message from `docker logs` or browser console for further refinement. The app's architecture is solid—this is likely a deployment configuration issue.