# output "vm_public_ip" {
#   value = module.vm.public_ip
# }

output "keyvault_uri" {
  value = module.keyvault.keyvault_uri
}
output "keyvault_id" {
  value = module.keyvault.keyvault_resource_id
}
output "keyvault_key_id" {
  value = module.keyvault.keyvault_key_id
}
