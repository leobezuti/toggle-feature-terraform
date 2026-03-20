variable "aws_region" {
  type        = string
}

variable "table_name" {
  type        = string
}

variable "hash_key" {
  type        = string
}

variable "hash_key_type" {
  type        = string
  default     = "S"
}

variable "billing_mode" {
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "read_capacity" {
  type        = number
  default     = 5
}

variable "write_capacity" {
  type        = number
  default     = 5
}

variable "ttl_attribute_name" {
  type        = string
  default     = null
}

variable "point_in_time_recovery_enabled" {
  type        = bool
  default     = false
}

variable "tags" {
  type        = map(string)
  default     = {}
}
