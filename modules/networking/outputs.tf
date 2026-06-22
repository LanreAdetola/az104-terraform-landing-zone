output "hub_vnet_id" {
  description = "ID of the hub virtual network"
  value       = azurerm_virtual_network.hub.id
}

output "spoke_vnet_id" {
  description = "ID of the spoke virtual network"
  value       = azurerm_virtual_network.spoke.id
}

output "subnet_ids" {
  description = "Map of subnet names to their resource IDs"
  value       = { for k, v in azurerm_subnet.spoke : k => v.id }
}

output "resource_group_name" {
  description = "Name of the networking resource group"
  value       = azurerm_resource_group.networking.name
}