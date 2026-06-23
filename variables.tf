variable "environment" {
  description = "Environment name (dev or prod)"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "spaincentral"
}

variable "spoke_address_space" {
  description = "Address space for the spoke VNet"
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "Map of subnet names to their CIDR prefixes"
  type        = map(string)
}

variable "nsg_rules" {
  description = "List of NSG rule objects to apply per subnet"
  type = list(object({
    name                       = string
    subnet_key                 = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}

variable "app_service_sku" {
  description = "SKU for the App Service Plan"
  type        = string
  default     = "B1"
}