variable "environment" {
  description = "Environment name (dev or prod) — used for resource naming"
  type        = string
}

variable "location" {
  description = "Azure region for the Cosmos DB account"
  type        = string
  default     = "spaincentral"
}

variable "resource_group_name" {
  description = "Resource group to deploy Cosmos DB into"
  type        = string
}

variable "tags" {
  description = "Common tags applied to the database account"
  type        = map(string)
  default     = {}
}