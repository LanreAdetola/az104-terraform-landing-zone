module "networking" {
  source              = "./modules/networking"
  environment         = "dev"
  location            = "spaincentral"
  spoke_address_space = ["10.1.0.0/16"]
  subnet_prefixes = {
    frontend = "10.1.1.0/24"
    backend  = "10.1.2.0/24"
    data     = "10.1.3.0/24"
  }
  tags = {
    environment = "dev"
    project     = "az104-landing-zone"
  }
  nsg_rules = [
    {
      name                       = "allow-https-inbound"
      subnet_key                 = "frontend"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "allow-frontend-to-backend"
      subnet_key                 = "backend"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "10.1.1.0/24"
      destination_address_prefix = "*"
    },
    {
      name                       = "allow-backend-to-data"
      subnet_key                 = "data"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1433"
      source_address_prefix      = "10.1.2.0/24"
      destination_address_prefix = "*"
    },
    {
      name                       = "deny-all-inbound"
      subnet_key                 = "data"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                       = "kv-az104-dev-${random_string.kv_suffix.result}"
  location                   = "spaincentral"
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
  source               = "./modules/compute"
  environment          = "dev"
  location             = "spaincentral"
  resource_group_name  = module.networking.resource_group_name
  frontend_subnet_id   = module.networking.subnet_ids["frontend"]
  backend_subnet_id    = module.networking.subnet_ids["backend"]
  app_service_sku      = "B1"
  key_vault_id         = azurerm_key_vault.main.id

  tags = {
    environment = "dev"
    project     = "az104-landing-zone"
  }
}