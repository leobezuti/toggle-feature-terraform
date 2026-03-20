variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "cluster_name" {
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
  default     = null
}

variable "enable_elastic_load_balancing" {
  type        = bool
  default     = true
}

variable "node_group_name" {
  type        = string
  default     = "default"
}

variable "instance_type" {
  type        = string
  default     = "t3.medium"
}

variable "desired_size" {
  type        = number
  default     = 2
}

variable "min_size" {
  type        = number
  default     = 1
}

variable "max_size" {
  type        = number
  default     = 3
}

variable "tags" {
  type        = map(string)
  default     = {}
}
