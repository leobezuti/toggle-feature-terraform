variable "aws_region" {
  type        = string
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
}

variable "private_subnets" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
}

variable "enable_nat_gateway" {
  type = bool
}

variable "tags" {
  type = map(string)
}
