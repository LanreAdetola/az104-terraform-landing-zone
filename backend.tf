terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstate3a80ff"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
    use_azuread_auth      = true
  }
}