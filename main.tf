module "networking" {
  source              = "./modules/networking"
  environment         = var.environment
  location            = var.location
  spoke_address_space = var.spoke_address_space
  subnet_prefixes     = var.subnet_prefixes

  tags = {
    environment = var.environment
    project     = "az104-landing-zone"
  }

  nsg_rules = var.nsg_rules
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                       = "kv-az104-${var.environment}-${random_string.kv_suffix.result}"
  location                   = var.location
  resource_group_name        = module.networking.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
}

resource "random_string" "kv_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]
}

module "compute" {
  source              = "./modules/compute"
  environment         = var.environment
  location            = var.location
  resource_group_name = module.networking.resource_group_name
  frontend_subnet_id  = module.networking.subnet_ids["frontend"]
  backend_subnet_id   = module.networking.subnet_ids["backend"]
  app_service_sku     = var.app_service_sku
  key_vault_id        = azurerm_key_vault.main.id

  tags = {
    environment = var.environment
    project     = "az104-landing-zone"
  }
}

module "database" {
  source              = "./modules/database"
  environment         = var.environment
  location            = var.location
  resource_group_name = module.networking.resource_group_name

  tags = {
    environment = var.environment
    project     = "az104-landing-zone"
  }
}

module "governance" {
  source      = "./modules/governance"
  environment = var.environment
  scope_id    = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${module.networking.resource_group_name}"

  tags = {
    environment = var.environment
    project     = "az104-landing-zone"
  }
}