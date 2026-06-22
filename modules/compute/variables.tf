variable "environment" {
  description = "Environment name (dev or prod) — used for naming and tagging"
  type        = string
}

variable "location" {
  description = "Azure region where compute resources will be deployed"
  type        = string
  default     = "spaincentral"
}

variable "resource_group_name" {
  description = "Resource group to deploy compute resources into"
  type        = string
}

variable "frontend_subnet_id" {
  description = "Subnet ID for frontend App Service VNet integration"
  type        = string
}

variable "backend_subnet_id" {
  description = "Subnet ID for backend App Service VNet integration"
  type        = string
}

variable "app_service_sku" {
  description = "SKU for the App Service Plan (B1 required for VNet integration support)"
  type        = string
  default     = "B1"
}

variable "key_vault_id" {
  description = "ID of the Key Vault apps will pull secrets from"
  type        = string
}

variable "tags" {
  description = "Common tags applied to all compute resources"
  type        = map(string)
  default     = {}
}