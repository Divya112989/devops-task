resource "azurerm_resource_group" "rg" {
  name     = "devops-task-rg"
  location = "East US"
}

resource "azurerm_resource_group" "demo" {
  name     = "rg-demo"
  location = "East US"
}


resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_storage_account" "devops-task-sa" {
  name                     = "tfstate${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "devops-task-sc" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.devops-task-sa.name
  container_access_type = "private"
}
