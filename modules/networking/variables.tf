variable "environment" {
  description = "Environment name (dev or prod) — used for naming and tagging"
  type        = string
}

variable "location" {
  description = "Azure region where networking resources will be deployed"
  type        = string
  default     = "westeurope"
}

variable "hub_address_space" {
  description = "Address space for the hub VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "spoke_address_space" {
  description = "Address space for this environment's spoke VNet"
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "Map of subnet names to their CIDR prefixes within the spoke"
  type        = map(string)
  # Example: { frontend = "10.1.1.0/24", backend = "10.1.2.0/24", data = "10.1.3.0/24" }
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
  default = []
}

variable "tags" {
  description = "Common tags applied to all networking resources"
  type        = map(string)
  default     = {}
}