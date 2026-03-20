variable "aws_region" {
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  type        = string
}

variable "manifest_base_path" {
  type        = string
  default     = "../../../../Kubernetes"
}

variable "services" {
  type        = list(string)
  default = [
    "analytics-service",
    "auth-service",
    "evaluation-service",
    "flag-service",
    "targeting-service"
  ]
}
