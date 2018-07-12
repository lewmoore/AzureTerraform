output "azurerm_resource_group_name" {
  value = "${azurerm_resource_group.vnet1rg.name}"
}

output "virtual_network_name" {
  value = "${azurerm_virtual_network.vnet1.name}"
}
