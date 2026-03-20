variable "table_name" {
  description = "Nome da tabela DynamoDB"
  type        = string
}

variable "hash_key" {
  description = "Nome da hash key (partition key)"
  type        = string
}

variable "hash_key_type" {
  description = "Tipo da hash key (S, N, B)"
  type        = string
  default     = "S"
}

variable "billing_mode" {
  description = "Modo de cobrança (PROVISIONED ou PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "read_capacity" {
  description = "Capacidade de leitura provisionada (apenas para PROVISIONED)"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Capacidade de escrita provisionada (apenas para PROVISIONED)"
  type        = number
  default     = 5
}

variable "ttl_attribute_name" {
  description = "Nome do atributo TTL"
  type        = string
  default     = null
}

variable "point_in_time_recovery_enabled" {
  description = "Ativa recuperação point-in-time"
  type        = bool
  default     = false
}

variable "stream_specification" {
  description = "DynamoDB stream settings."
  type = object({
    stream_enabled   = bool
    stream_view_type = string
  })
  default = {
    stream_enabled   = false
    stream_view_type = "NEW_AND_OLD_IMAGES"
  }
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default     = {}
}
