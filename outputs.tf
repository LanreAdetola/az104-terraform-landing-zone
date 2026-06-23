output "networking_resource_group" {
  description = "Name of the networking resource group"
  value       = module.networking.resource_group_name
}

output "frontend_url" {
  description = "URL of the frontend App Service"
  value       = "https://${module.compute.frontend_url}"
}

output "backend_url" {
  description = "URL of the backend App Service"
  value       = "https://${module.compute.backend_url}"
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "cosmosdb_account_name" {
  description = "Name of the Cosmos DB account"
  value       = module.database.cosmosdb_account_name
}

output "cosmosdb_endpoint" {
  description = "Endpoint URI for the Cosmos DB account"
  value       = module.database.cosmosdb_endpoint
}