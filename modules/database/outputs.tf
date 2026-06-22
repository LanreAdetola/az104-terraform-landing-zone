output "database_id" {
  description = "ID of the created database"
  value       = azurerm_mssql_database.main.id
}

output "database_name" {
  description = "Name of the created database"
  value       = azurerm_mssql_database.main.name
}

output "server_fqdn" {
  description = "Fully qualified domain name of the SQL Server, used for app connection strings"
  value       = data.azurerm_mssql_server.existing.fully_qualified_domain_name
}