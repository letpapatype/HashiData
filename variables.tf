resource "random_string" "random" {
  length           = 3
  special          = false
  lower = true
  min_lower = 3
}

variable "project" {
    default = "roving${random_string.random.result}"
}

variable "vaultaddress" {
    default = ""
}
variable "vaulttoken" {
    default = ""
}

variable "tokenname" {
    default = ""
}

variable "vault_role" {
    default = ""
}

variable "subscription_id" {
    default = ""
}

variable "client_id" {
    default = ""
}

variable "client_secret" {
    default = ""
}

variable "tenant_id" {
    default = ""
}