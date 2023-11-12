resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}

data "azurerm_client_config" "current" {}

locals {
  affix = random_string.random.result

  current_tenant_id = data.azurerm_client_config.current.tenant_id
  current_object_id = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault" "default" {
  name                = "kv-${var.workload}${local.affix}"
  location            = var.location
  resource_group_name = var.group
  tenant_id           = local.current_tenant_id
  sku_name            = "standard"

  # Purge protection must be enabled for Azure Disk Encryption (ADE)
  purge_protection_enabled = true

  # Required for Azure Disk Encryption (ADE)
  enabled_for_disk_encryption = true
}

resource "azurerm_key_vault_key" "default" {
  name         = "vmencryptkey"
  key_vault_id = azurerm_key_vault.default.id
  key_type     = "RSA"
  key_size     = 4096

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_disk_encryption_set" "default" {
  name                = "des"
  location            = var.location
  resource_group_name = var.group
  key_vault_key_id    = azurerm_key_vault_key.default.id

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_key_vault_access_policy" "disk_set" {
  key_vault_id = azurerm_key_vault.default.id

  tenant_id = azurerm_disk_encryption_set.default.identity.0.tenant_id
  object_id = azurerm_disk_encryption_set.default.identity.0.principal_id

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "List",
    "Decrypt",
    "Sign",
  ]
}

resource "azurerm_key_vault_access_policy" "current" {
  key_vault_id = azurerm_key_vault.default.id

  tenant_id = local.current_tenant_id
  object_id = local.current_object_id

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey",
    "Release",
    "Rotate",
    "GetRotationPolicy",
    "SetRotationPolicy"
  ]
}
