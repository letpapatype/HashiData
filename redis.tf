resource "azurerm_resource_group" "redis" {
  name     = format("redis-rg-%s", random_string.random.result)
  location = var.location
}

resource "azurerm_redis_cache" "redis" {
  name                          = format("redis-%s", random_string.random.result)
  location                      = var.location
  resource_group_name           = azurerm_resource_group.redis.name
  capacity                      = 1
  family                        = "P"
  sku_name                      = "Premium"
  enable_non_ssl_port           = false
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  redis_configuration {
    aof_backup_enabled              = true
    aof_storage_connection_string_0 = "DefaultEndpointsProtocol=https;BlobEndpoint=${azurerm_storage_account.redis.primary_blob_endpoint};AccountName=${azurerm_storage_account.redis.name};AccountKey=${azurerm_storage_account.redis.primary_access_key}"
  }

  #   depends_on = [
  #     azurerm_private_dns_zone_virtual_network_link.redis
  #   ]
}

resource "azurerm_private_endpoint" "redis" {
  location            = var.location
  name                = format("redis-ep-%s", random_string.random.result)
  resource_group_name = azurerm_resource_group.azure.name
  subnet_id           = azurerm_subnet.redis.id

  private_dns_zone_group {
    name                 = "redisgroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.redis.id]
  }

  private_service_connection {
    name                           = "redispsc"
    private_connection_resource_id = azurerm_private_link_service.redis.id
    is_manual_connection           = false
  }
}

resource "azurerm_private_link_service" "redis" {
  name                                        = "redis-privatelink"
  location                                    = var.location
  resource_group_name                         = azurerm_resource_group.azure.name
  load_balancer_frontend_ip_configuration_ids = [azurerm_lb.azure.frontend_ip_configuration.0.id]

  nat_ip_configuration {
    name    = "primary"
    primary = true
    # private_ip_address = azurerm_private_dns_zone.redis.name
    subnet_id = azurerm_subnet.redis.id
  }

}

resource "azurerm_storage_account" "redis" {
  name                     = format("redissa%s", random_string.random.result)
  resource_group_name      = azurerm_resource_group.azure.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["108.0.0.1"]
    virtual_network_subnet_ids = [azurerm_subnet.redis.id]
  }

}

output "redis" {
  value = format("%s.redis.cache.windows.net", azurerm_redis_cache.redis.name)
}