variable "environment" {
  description = "Environment name (dev or prod) — used for naming and scoping policy assignments"
  type        = string
}

variable "scope_id" {
  description = "Resource ID to scope policy assignments to (e.g. a resource group)"
  type        = string
}

variable "tags" {
  description = "Common tags applied to governance resources"
  type        = map(string)
  default     = {}
}