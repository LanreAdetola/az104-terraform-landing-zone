resource "azurerm_service_plan" "main" {
  name                = "asp-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.app_service_sku
  tags                = var.tags
}

resource "azurerm_linux_web_app" "backend" {
  name                = "app-backend-${var.environment}-${random_string.app_suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true


  site_config {
    application_stack {
      python_version = "3.11"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  virtual_network_subnet_id = var.backend_subnet_id

  tags = var.tags
}

resource "random_string" "app_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_linux_web_app" "frontend" {
  name                = "app-frontend-${var.environment}-${random_string.app_suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true


  site_config {
    application_stack {
      python_version = "3.11"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  virtual_network_subnet_id = var.frontend_subnet_id

  app_settings = {
    BACKEND_URL = "https://${azurerm_linux_web_app.backend.default_hostname}"
  }

  tags = var.tags
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "backend" {
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.backend.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_key_vault_access_policy" "frontend" {
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.frontend.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}