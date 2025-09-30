# provider.tf

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"

  # Using environment variables instead of Terraform variables
  # client_id       = var.client_id
  # client_secret   = var.client_secret
  # tenant_id       = var.tenant_id
  # subscription_id = var.subscription_id
}

terraform {
  backend "azurerm" {
    resource_group_name  = "devops-task-rg"
    storage_account_name = "tfstateoqbmrg"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# ---------------------------------------------------------------
# To use environment variables for authentication:
# Set these in your Jenkins environment or locally:
#   ARM_CLIENT_ID       -> Azure Service Principal Client ID
#   ARM_CLIENT_SECRET   -> Azure Service Principal Client Secret
#   ARM_TENANT_ID       -> Azure Tenant ID
#   ARM_SUBSCRIPTION_ID -> Azure Subscription ID
#
# Example (Linux/macOS):
#   export ARM_CLIENT_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#   export ARM_CLIENT_SECRET="xxxxxxxxxxxxxxxxxxxx"
#   export ARM_TENANT_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#   export ARM_SUBSCRIPTION_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#
# Example (Windows PowerShell):
#   $env:ARM_CLIENT_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#   $env:ARM_CLIENT_SECRET="xxxxxxxxxxxxxxxxxxxx"
#   $env:ARM_TENANT_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#   $env:ARM_SUBSCRIPTION_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#
# Terraform will automatically pick up these environment variables.




