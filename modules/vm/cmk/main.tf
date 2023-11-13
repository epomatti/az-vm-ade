locals {
  encrypt_type = "cmk"
}

resource "azurerm_public_ip" "default" {
  name                = "pip-${var.workload}-${local.encrypt_type}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "default" {
  name                = "nic-${var.workload}-${local.encrypt_type}"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.default.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  username = "sysadmin"
}

resource "azurerm_linux_virtual_machine" "default" {
  name                       = "vm-${var.workload}-${local.encrypt_type}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  size                       = var.size
  admin_username             = local.username
  admin_password             = "P@ssw0rd.123"
  network_interface_ids      = [azurerm_network_interface.default.id]
  encryption_at_host_enabled = false

  custom_data = filebase64("${path.module}/cloud-init.sh")

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = local.username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    name                 = "osdisk-linux-${var.workload}-${local.encrypt_type}"
    caching              = "ReadOnly"
    storage_account_type = "StandardSSD_LRS"

    # Azure Disk Encryption (ADE)
    disk_encryption_set_id = var.disk_encryption_set_id
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    # sku       = "22_04-lts-arm64"
    version = "latest"
  }
}
