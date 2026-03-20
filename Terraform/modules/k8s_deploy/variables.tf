variable "manifest_base_path" {
  description = "Base path containing service subdirectories with Kubernetes YAML files."
  type        = string
}

variable "services" {
  description = "List of service directory names under manifest_base_path."
  type        = list(string)
}
