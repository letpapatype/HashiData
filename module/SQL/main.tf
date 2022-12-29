provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "sqlflex" {
  name = format("flexsql-%s!", random_string.random.result)
  location = var.location
}

resource "azurerm_mysql_flexible_server" "flexsql" {
  name                   = format("flexserv-%s!", random_string.random.result)
  resource_group_name    = azurerm_resource_group.sqlflex.name
  location               = var.location
  administrator_login    = "mysqladminun"
  administrator_password = "H@Sh1CoR3!"
  sku_name               = "B_Standard_B1s"
}

resource "azurerm_mysql_flexible_database" "flexdb" {
  name                = format("flexdb-%s!", random_string.random.result)
  resource_group_name = azurerm_resource_group.sqlflex.name
  server_name         = azurerm_mysql_flexible_server.flexsql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "flexfire" {
  name                = format("office-%s!", random_string.random.result)
  resource_group_name = azurerm_resource_group.sqlflex.name
  server_name         = azurerm_mysql_flexible_server.flexsql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}