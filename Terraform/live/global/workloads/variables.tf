variable "aws_region" {
  description = "AWS region used to access the EKS cluster."
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "manifest_base_path" {
  description = "Path to Kubernetes manifests root folder."
  type        = string
  default     = "../../../../Kubernetes"
}

variable "services" {
  description = "Service folders to deploy from Kubernetes manifests root."
  type        = list(string)
  default = [
    "analytics-service",
    "auth-service",
    "evaluation-service",
    "flag-service",
    "targeting-service"
  ]
}
