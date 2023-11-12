data "azurerm_client_config" "current" {}

locals {
  current_tenant_id = data.azurerm_client_config.current.tenant_id
  current_object_id = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault" "databricks" {
  name                     = "kv-${var.workload}789"
  location                 = var.location
  resource_group_name      = var.group
  tenant_id                = local.current_tenant_id
  purge_protection_enabled = false
  sku_name                 = "standard"

  access_policy {
    tenant_id = local.current_tenant_id
    object_id = local.current_object_id

    secret_permissions = ["Delete", "Get", "List", "Set", "Purge"]
  }

  lifecycle {
    ignore_changes = [access_policy]
  }
}

# resource "azurerm_key_vault_secret" "sql_database_admin_username" {
#   name         = "mssqlusername"
#   value        = var.mssql_admin_login
#   key_vault_id = azurerm_key_vault.databricks.id
# }
