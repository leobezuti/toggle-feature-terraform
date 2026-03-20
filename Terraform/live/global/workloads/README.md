# Terraform Workloads (Kubernetes Manifests)

This stack applies all manifests from `Kubernetes/<service>` into the EKS cluster.

## Usage

From `Terraform/live/global/workloads`:

```bash
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```
