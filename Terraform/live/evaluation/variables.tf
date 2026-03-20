variable "aws_region" {
  type        = string
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "queue_name" {
  type        = string
}

variable "delay_seconds" {
  type        = number
  default     = 0
}

variable "max_message_size" {
  type        = number
  default     = 262144
}

variable "message_retention_seconds" {
  type        = number
  default     = 86400
}

variable "visibility_timeout_seconds" {
  type        = number
  default     = 300
}

variable "receive_wait_time_seconds" {
  type        = number
  default     = 0
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

variable "cluster_name" {
  type        = string
}

variable "elasticache_description" {
  type        = string
  default     = "Cluster de ElastiCache para caching de dados"
}

variable "replication_group_id" {
  type        = string
}

variable "engine" {
  type        = string
  default     = "redis"
}

variable "node_type" {
  type        = string
  default     = "cache.t3.micro"
}

variable "num_cache_nodes" {
  type        = number
  default     = 1
}

variable "parameter_group_name" {
  type        = string
  default     = "default.redis7"
}

variable "engine_version" {
  type        = string
  default     = "7.0"
}

variable "port" {
  type        = number
  default     = 6379
}
