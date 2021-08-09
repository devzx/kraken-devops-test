variable "name" {
  type        = string
  description = "name for created resources"
}

variable "resource_prefix_enabled" {
  type        = bool
  default     = false
  description = "whether to add a prefix with the resources type to the name of the created resource"
}