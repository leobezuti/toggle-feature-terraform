variable "aws_region" {
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "vpc_cidr" {
  type        = string
}

variable "private_subnet_ids" {
  type        = list(string)
}

variable "project_name" {
  type        = string
}

variable "db_identifier" {
  type        = string
}

variable "db_name" {
  type        = string
}

variable "db_username" {
  type        = string
}

variable "db_engine_version" {
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  type        = number
  default     = 20
}

variable "tags" {
  type        = map(string)
  default     = {}
}
