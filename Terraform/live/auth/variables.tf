variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "project_name" { type = string }
variable "db_identifier" { type = string }
variable "db_name" { type = string }
variable "db_username" { type = string }   
variable "tags" { type = map(string) }