# set env VAULT_ADDR as TF_VAR_variableaddress and VAULT_TOKEN as TF_VAR_vaulttoken
provider "vault" {
  address = var.vaultaddress
  token = var.vaulttoken
  token_name = var.tokenname
}

resource "vault_azure_secret_backend" "azure" {
  use_microsoft_graph_api = true
  subscription_id         = var.subscription_id
  tenant_id               = var.tenant_id
  client_id               = var.client_id
  client_secret           = var.client_secret
  environment             = "AzurePublicCloud"
}

resource "vault_azure_secret_backend_role" "azure_role" {
  backend                     = vault_azure_secret_backend.azure.path
  role                        = var.vault_role
  ttl                         = 300
  max_ttl                     = 600

  azure_roles {
    role_name = "Contributor"
    scope =  "/subscriptions/${var.subscription_id}"
  }
}

output "backend" {
  value = vault_azure_secret_backend.azure.path
}

output "role" {
  value = vault_azure_secret_backend_role.azure_role.name
}