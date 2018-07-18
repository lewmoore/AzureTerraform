resource "azurerm_network_security_group" "ftpuat-sg" {
    name                = "AZMAGSGKAFUAT"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.kafuatrg.name}"

    security_rule {
      name                       = "AllowFTP"
      access                     = "Allow"
      direction                  = "Inbound"
      priority                   = "100"
      protocol                   = "TCP"
      destination_port_ranges    = ["22", "8000-8030"]
      destination_address_prefix = "*"
      source_port_range          = "*"
      source_address_prefix      = "94.31.4.69"
    }
}
