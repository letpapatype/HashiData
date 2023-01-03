resource "azurerm_resource_group" "sqlflex" {
  name     = format("flexsql-%s", random_string.random.result)
  location = var.location
}

resource "azurerm_mysql_flexible_server" "flexsql" {
  name                   = format("flexserv-%s", random_string.random.result)
  resource_group_name    = azurerm_resource_group.sqlflex.name
  location               = var.location
  administrator_login    = "jovannewland"
  administrator_password = "H@Sh1CoR3!"
  sku_name               = "B_Standard_B1ms"
  backup_retention_days  = 7
  delegated_subnet_id    = azurerm_subnet.azure.id
  private_dns_zone_id    = azurerm_private_dns_zone.azure.id

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.azure
  ]
}

resource "azurerm_mysql_flexible_database" "flexdb" {
  name                = format("flexdb-%s", random_string.random.result)
  resource_group_name = azurerm_resource_group.sqlflex.name
  server_name         = azurerm_mysql_flexible_server.flexsql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "flexfire" {
  name                = format("office-%s", random_string.random.result)
  resource_group_name = azurerm_resource_group.sqlflex.name
  server_name         = azurerm_mysql_flexible_server.flexsql.name
  start_ip_address    = var.world
  end_ip_address      = var.world
}