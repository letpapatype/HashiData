provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "sqlflex" {
  name     = "${var.project}-sql"
  location = var.location
}

resource "azurerm_mysql_flexible_server" "flexsql" {
  name                   = "${var.project}-server"
  resource_group_name    = azurerm_resource_group.sqlflex.name
  location               = var.location
  administrator_login    = "mysqladminun"
  administrator_password = "H@Sh1CoR3!"
  sku_name               = "B_Standard_B1s"
}

resource "azurerm_mysql_flexible_database" "flexdb" {
  name                = "${var.project}-db"
  resource_group_name = azurerm_resource_group.sqlflex.name
  server_name         = azurerm_mysql_flexible_server.flexsql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "example" {
  name                = "office"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mysql_flexible_server.example.name
  start_ip_address    = "40.112.0.0"
  end_ip_address      = "40.112.255.255"
}