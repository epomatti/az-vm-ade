data "azurerm_client_config" "current" {}

locals {
  current_tenant_id = data.azurerm_client_config.current.tenant_id
  current_object_id = data.azurerm_client_config.current.object_id
}

// TODO: Fix name
resource "azurerm_key_vault" "databricks" {
  name                     = "kv-${var.workload}789"
  location                 = var.location
  resource_group_name      = var.group
  tenant_id                = local.current_tenant_id
  purge_protection_enabled = false
  sku_name                 = "standard"

  # Required for Azure Disk Encryption (ADE)
  enabled_for_disk_encryption = true

  access_policy {
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
}

// TODO: Fix name
resource "azurerm_key_vault_key" "databricks" {
  name         = "vmencryptkey"
  key_vault_id = azurerm_key_vault.databricks.id
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
