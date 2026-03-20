variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "db_identifier" {
  description = "Identificador da instância RDS"
  type        = string
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
}

variable "db_username" {
  description = "Nome do usuário do banco"
  type        = string
}

variable "db_engine_version" {
  description = "Versão do engine do banco"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "Classe da instância"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Armazenamento alocado"
  type        = number
  default     = 20
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default     = {}
}