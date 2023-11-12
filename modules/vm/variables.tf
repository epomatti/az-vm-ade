variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "size" {
  type = string
}

variable "disk_encryption_set_id" {
  type = string
}

variable "encryption_at_host_enabled" {
  type = bool
}
