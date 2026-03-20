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
  default     = 262144 # 256 KiB
}
variable "message_retention_seconds" {
  description = "Tempo de retenção da mensagem (em segundos)"
  type        = number
  default     = 86400 # 1 dia
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

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default     = {}
}