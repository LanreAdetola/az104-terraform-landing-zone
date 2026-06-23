resource "azurerm_cosmosdb_account" "main" {
  name                = "cosmos-az104-${var.environment}-${random_string.cosmos_suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  free_tier_enabled             = true
  local_authentication_disabled = true
  minimal_tls_version           = "Tls12"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  backup {
    type                = "Continuous"
    tier                = "Continuous7Days"
  }

  capacity {
    total_throughput_limit = 1000
  }

  is_virtual_network_filter_enabled = false

  tags = merge(var.tags, {
    defaultExperience = "Core (SQL)"
  })
}

resource "random_string" "cosmos_suffix" {
  length  = 6
  special = false
  upper   = false
}