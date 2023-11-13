terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.79.0"
    }
  }
}

locals {
  workload = "bigcorplimited"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.workload}"
  location = var.location
}

module "vnet" {
  source              = "./modules/vnet"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "keyvault" {
  source   = "./modules/keyvault"
  workload = local.workload
  group    = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location
}

module "vm_cmk" {
  source                     = "./modules/vm/cmk"
  workload                   = local.workload
  resource_group_name        = azurerm_resource_group.default.name
  location                   = azurerm_resource_group.default.location
  subnet_id                  = module.vnet.subnet_id
  size                       = var.vm_size
  disk_encryption_set_id     = module.keyvault.disk_encryption_set_id
  encryption_at_host_enabled = var.encryption_at_host_enabled
}
