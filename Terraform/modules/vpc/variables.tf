variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Configuração das subnets públicas"
  type = map(object({
    cidr_block = string
    az         = string
  }))
  default = {
    "pub-a" = { cidr_block = "10.0.1.0/24", az = "us-east-1a" }
    "pub-b" = { cidr_block = "10.0.2.0/24", az = "us-east-1b" }
  }
}

variable "private_subnets" {
  description = "Configuração das subnets privadas"
  type = map(object({
    cidr_block = string
    az         = string
  }))
  default = {
    "pvt-a" = { cidr_block = "10.0.10.0/24", az = "us-east-1a" }
    "pvt-b" = { cidr_block = "10.0.11.0/24", az = "us-east-1b" }
  }
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
