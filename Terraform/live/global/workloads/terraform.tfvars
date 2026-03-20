aws_region      = "us-east-1"
cluster_name    = module.eks_cluster.name
manifest_base_path = "../../../../Kubernetes"

services = [
  "analytics-service",
  "auth-service",
  "evaluation-service",
  "flag-service",
  "targeting-service"
]
