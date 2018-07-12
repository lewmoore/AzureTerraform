resource "azurerm_network_security_group" "ftpuat-sg" {
    name                = "AZMAGSGFTPUAT"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.machinerg.name}"

    security_rule {
      name                       = "AllowFTP"
      access                     = "Allow"
      direction                  = "Inbound"
      priority                   = "100"
      protocol                   = "TCP"
      destination_port_ranges    = ["21", "5000-5050"]
      destination_address_prefix = "*"
      source_port_range          = "*"
      source_address_prefix      = "217.138.46.244"
    }

    security_rule {
      name                       = "AllowRDP"
      access                     = "Allow"
      direction                  = "Inbound"
      priority                   = "110"
      protocol                   = "TCP"
      destination_port_range     = "3389"
      destination_address_prefix = "*"
      source_port_range          = "*"
      source_address_prefix      = "217.138.46.244"
    }
}
