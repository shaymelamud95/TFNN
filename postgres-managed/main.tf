resource "azurerm_private_dns_zone" "private_dns" {
  name                = "${var.DBPrefix}privatednszone.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}
resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = "${var.DBPrefix}VnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = var.vnet_id
  resource_group_name   = var.resource_group_name
}
resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = "${var.TFPrefix}shay-psqlflexibleserver"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "13"
  delegated_subnet_id    = var.subnet_id
  private_dns_zone_id    = azurerm_private_dns_zone.private_dns.id
  administrator_login    = var.admin_username
  administrator_password = var.admin_password
  zone                   = 1
  storage_mb             = 32768

  sku_name   = "B_Standard_B1ms"
  depends_on = [azurerm_private_dns_zone_virtual_network_link.dns_link]
}
resource "azurerm_postgresql_flexible_server_configuration" "rm_ssl" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.postgres.id
  value     = "off"
}
