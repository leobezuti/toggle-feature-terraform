variable "aws_region" {
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  type        = string
  default     = "toggle-feature-vpc"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
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
  type        = bool
  default     = true
}

variable "cluster_name" {
  type        = string
  default     = "toggle-feature-cluster"
}

variable "enable_elastic_load_balancing" {
  type        = bool
  default     = true
}

variable "desired_size" {
  type        = number
  default     = 2
}

variable "max_size" {
  type        = number
  default     = 4
}

variable "min_size" {
  type        = number
  default     = 2
}

variable "instance_type" {
  type        = string
  default     = "t3.small"
}

variable "tags" {
  type        = map(string)
  default     = {
    Project = "toggle-feature"
  }
}

variable "github_repository" {
  type        = string
  default     = "leobezuti/toggle-feature-terraform"
}

variable "github_branch" {
  type        = string
  default     = "main"
}

variable "github_oidc_provider_arn" {
  type        = string
  default     = ""
}
