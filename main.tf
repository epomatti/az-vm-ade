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
  source                 = "./modules/vm/cmk"
  workload               = local.workload
  resource_group_name    = azurerm_resource_group.default.name
  location               = azurerm_resource_group.default.location
  subnet_id              = module.vnet.subnet_id
  size                   = var.vm_size
  disk_encryption_set_id = module.keyvault.disk_encryption_set_id
}

module "vm_ade" {
  source              = "./modules/vm/ade"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  subnet_id           = module.vnet.subnet_id
  size                = var.vm_size
}

module "vm_eah" {
  source              = "./modules/vm/eah"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  subnet_id           = module.vnet.subnet_id
  size                = var.vm_size
}
