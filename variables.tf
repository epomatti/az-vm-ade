variable "location" {
  type    = string
  default = "eastus"
}

variable "vm_size" {
  type = string
}

variable "encryption_at_host_enabled" {
  type = bool
}
