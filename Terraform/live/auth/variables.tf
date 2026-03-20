variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "project_name" { type = string }
variable "vpc_id" { type = string }
variable "vpc_cidr" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "db_identifier" { type = string }
variable "db_name" { type = string }
variable "db_username" { type = string }         