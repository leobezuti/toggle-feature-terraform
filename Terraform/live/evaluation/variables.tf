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

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default     = {}
}

# SQS variables
variable "queue_name" {
  description = "Nome da fila SQS"
  type        = string
}

variable "delay_seconds" {
  description = "Tempo de atraso para mensagens (em segundos)"
  type        = number
  default     = 0
}

variable "max_message_size" {
  description = "Tamanho máximo da mensagem (em bytes)"
  type        = number
  default     = 262144
}

variable "message_retention_seconds" {
  description = "Tempo de retenção da mensagem (em segundos)"
  type        = number
  default     = 86400
}

variable "visibility_timeout_seconds" {
  description = "Tempo de timeout de visibilidade (em segundos)"
  type        = number
  default     = 300
}

variable "receive_wait_time_seconds" {
  description = "Tempo de espera para recebimento de mensagens (em segundos)"
  type        = number
  default     = 0
}

# RDS variables
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

# Redis variables
variable "cluster_name" {
  description = "Nome do cluster de ElastiCache"
  type        = string
}

variable "elasticache_description" {
  description = "Descrição do cluster de ElastiCache"
  type        = string
  default     = "Cluster de ElastiCache para caching de dados"
}

variable "replication_group_id" {
  description = "ID do grupo de replicação"
  type        = string
}

variable "engine" {
  description = "Engine do cache (redis ou memcached)"
  type        = string
  default     = "redis"
}

variable "node_type" {
  description = "Tipo de nó do ElastiCache"
  type        = string
  default     = "cache.t3.micro"
}

variable "num_cache_nodes" {
  description = "Número de nós de cache"
  type        = number
  default     = 1
}

variable "parameter_group_name" {
  description = "Nome do grupo de parâmetros"
  type        = string
  default     = "default.redis7"
}

variable "engine_version" {
  description = "Versão da engine do Redis"
  type        = string
  default     = "7.0"
}

variable "port" {
  description = "Porta do Redis"
  type        = number
  default     = 6379
}