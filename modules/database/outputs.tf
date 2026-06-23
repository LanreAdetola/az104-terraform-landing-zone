output "cosmosdb_account_name" {
  description = "Name of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.main.name
}

output "cosmosdb_endpoint" {
  description = "Endpoint URI for the Cosmos DB account, used by apps to connect"
  value       = azurerm_cosmosdb_account.main.endpoint
}

output "cosmosdb_account_id" {
  description = "Resource ID of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.main.id
}