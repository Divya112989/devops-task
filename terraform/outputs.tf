output "dev_rg_name" {
  value = azurerm_resource_group.rg_dev.name
}

output "test_rg_name" {
  value = azurerm_resource_group.rg_test.name
}
