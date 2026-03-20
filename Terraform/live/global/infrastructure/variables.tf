variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "toggle-feature-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnets configuration"
  type = map(object({
    cidr_block = string
    az         = string
  }))
  default = {
    "public-1" = {
      cidr_block = "10.0.1.0/24"
      az         = "us-east-1a"
    }
    "public-2" = {
      cidr_block = "10.0.2.0/24"
      az         = "us-east-1b"
    }
  }
}

variable "private_subnets" {
  description = "Private subnets configuration"
  type = map(object({
    cidr_block = string
    az         = string
  }))
  default = {
    "private-1" = {
      cidr_block = "10.0.3.0/24"
      az         = "us-east-1a"
    }
    "private-2" = {
      cidr_block = "10.0.4.0/24"
      az         = "us-east-1b"
    }
  }
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "toggle-feature-cluster"
}

variable "enable_elastic_load_balancing" {
  description = "Enable elastic load balancing"
  type        = bool
  default     = true
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 1  # Reduced from 2 to minimize cost
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.small"  # Changed from t3.medium to reduce cost
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    Project = "toggle-feature"
  }
}