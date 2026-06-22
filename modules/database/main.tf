data "azurerm_mssql_server" "existing" {
  name                = "bankretain-sql-dev-mqi4i4pjzxcdc"
  resource_group_name = "bankretain-ml-rg"
}
resource "azurerm_mssql_database" "main" {
  name      = "db-${var.environment}"
  server_id = data.azurerm_mssql_server.existing.id
  sku_name  = "Free"

  tags = var.tags
}

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = data.azurerm_mssql_server.existing.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_firewall_rule" "allow_my_ip" {
  name             = "AllowMyIP"
  server_id        = data.azurerm_mssql_server.existing.id
  start_ip_address = var.my_ip_address
  end_ip_address   = var.my_ip_address
}