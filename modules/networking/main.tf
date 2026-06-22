resource "azurerm_resource_group" "networking" {
  name     = "rg-networking-${var.environment}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub-${var.environment}"
  address_space       = var.hub_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.networking.name
  tags                = var.tags
}

resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-spoke-${var.environment}"
  address_space       = var.spoke_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.networking.name
  tags                = var.tags
}

resource "azurerm_subnet" "spoke" {
  for_each             = var.subnet_prefixes
  name                 = each.key
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [each.value]
}

resource "azurerm_network_security_group" "spoke" {
  for_each            = var.subnet_prefixes
  name                = "nsg-${each.key}-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.networking.name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "spoke" {
  for_each                    = { for rule in var.nsg_rules : rule.name => rule }
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.networking.name
  network_security_group_name = azurerm_network_security_group.spoke[each.value.subnet_key].name
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-spoke-${var.environment}"
  resource_group_name      = azurerm_resource_group.networking.name
  virtual_network_name     = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-spoke-to-hub-${var.environment}"
  resource_group_name      = azurerm_resource_group.networking.name
  virtual_network_name     = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
}