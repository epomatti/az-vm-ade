output "id" {
  value = azurerm_key_vault.databricks.id
}

output "vault_uri" {
  value = azurerm_key_vault.databricks.vault_uri
}

output "keyvault_key_id" {
  value = azurerm_key_vault_key.databricks.id
}
