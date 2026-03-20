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
  description = "ID do grupo de replicação (opcional, usado para replication group)"
  type        = string
  default     = null
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

variable "subnet_group_name" {
  description = "Nome do grupo de subnets"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de subnet IDs"
  type        = list(string)
}

variable "automatic_failover_enabled" {
  description = "Ativa failover automático"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default     = {}
}
