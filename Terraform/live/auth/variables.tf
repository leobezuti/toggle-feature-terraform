variable "aws_region" {
  type        = string
}

variable "project_name" { type = string }
variable "db_identifier" { type = string }
variable "db_name" { type = string }
variable "db_username" { type = string }   
variable "tags" { type = map(string) }
