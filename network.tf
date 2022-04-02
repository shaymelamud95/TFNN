resource "azurerm_resource_group" "RG" { # Creating a resource group
  name     = "${var.TFPrefix}RG"
  location = var.location
}

resource "azurerm_network_security_group" "NSG" { # Create a security group
  name                = "${var.TFPrefix}NSG"
  resource_group_name = azurerm_resource_group.RG.name
  location            = var.location

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "5.29.20.0/24"
    destination_address_prefix = azurerm_subnet.client_SB.address_prefix
  }

  security_rule {
    name                       = "8080"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_subnet.client_SB.address_prefix
  }
  security_rule {
    name                       = "Allow access to DB from the web vm"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = azurerm_subnet.client_SB.address_prefix
    destination_address_prefix = azurerm_subnet.DB_SB.address_prefix
  }
  security_rule {
    name                       = "Deny every other connection to the Private Subnet"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_subnet.DB_SB.address_prefix
  }
}
resource "azurerm_subnet_network_security_group_association" "public_assoc" {
  subnet_id                 = azurerm_subnet.client_SB.id
  network_security_group_id = azurerm_network_security_group.NSG.id
}
resource "azurerm_subnet_network_security_group_association" "private_assoc" {
  subnet_id                 = azurerm_subnet.DB_SB.id
  network_security_group_id = azurerm_network_security_group.NSG.id
}
resource "azurerm_virtual_network" "Vnet" {
  name                = "${var.TFPrefix}vnet"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
}
resource "azurerm_subnet" "client_SB" {
  name                 = "${var.TFPrefix}client_subnet"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_subnet" "DB_SB" {
  name                 = "${var.TFPrefix}server_subnet"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = ["10.0.5.0/24"]
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

