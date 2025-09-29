provider "azurerm" {
  features {}
  resource_provider_registrations = "none"

  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

terraform {
  backend "azurerm" {
    resource_group_name  = "devops-task-rg"
    storage_account_name = "tfstateoqbmrg"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}



