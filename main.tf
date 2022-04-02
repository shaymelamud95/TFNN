module "Managed_postgres" {
  source                          = "./postgres-managed"
  name                            = var.DBPrefix
  resource_group_name             = azurerm_resource_group.RG.name
  location                        = azurerm_resource_group.RG.location
  size                            = var.size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  subnet_id                       = azurerm_subnet.DB_SB.id
  vnet_id                         = azurerm_virtual_network.Vnet.id
  DBPrefix                        = var.DBPrefix
  TFPrefix                        = var.TFPrefix
}

module "load_balancer" {
  source              = "./load_balancer"
  resource_group_name = azurerm_resource_group.RG.name
  vnet_id             = azurerm_virtual_network.Vnet.id
  TFPrefix            = var.TFPrefix
  location            = azurerm_resource_group.RG.location
  sku                 = var.sku
  vmcount             = var.vmcount
  client-vms          = module.client-vm
}

module "client-vm" {
  source                          = "./vmclient"
  vmcount                         = var.vmcount
  resource_group_name             = azurerm_resource_group.RG.name
  location                        = azurerm_resource_group.RG.location
  size                            = var.size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  zones                           = var.vm_zones
  subnet_id                       = azurerm_subnet.client_SB.id
  TFPrefix                        = var.TFPrefix
}

