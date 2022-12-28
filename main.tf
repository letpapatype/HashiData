terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.37.0"
    }
    vault = {
      source = "hashicorp/vault"
      version = "3.11.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
  }
}
# TODO: Get proper creds https://developer.hashicorp.com/vault/tutorials/secrets-management/azure-secrets
# set env ARM_TENANT_ID, ARM_CLIENT_ID, ARM_CLIENT_SECRET and ARM_RESOURCE_GROUP
provider "azurerm" {
  features {
      resource_group {
      prevent_deletion_if_contains_resources = false
    }
    subscription_id = var.subscription_id
    client_id       = data.vault_azure_access_credentials.creds.client_id
    client_secret   = data.vault_azure_access_credentials.creds.client_secret
    tenant_id       = var.tenant_id
  }
}

provider "random" {
  # Configuration options
}

data "vault_azure_access_credentials" "creds" {
  role                        = var.vault_role
  validate_creds              = true
  num_sequential_successes    = 8
  num_seconds_between_tests   = 1
  max_cred_validation_seconds = 300 
}

module "datainfra" {
    source = "./module"
}