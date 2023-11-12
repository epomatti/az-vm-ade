# Azure VM + ADE

Azure Virtual Machine implementation with Azure Disk Encryption.

Create the `.auto.tfvars` configuration file:

```terraform
location                   = "eastus"
vm_size                    = "Standard_B2ms"
encryption_at_host_enabled = false
```

> ℹ️ Notice that ADE have some few restrictions with VM types and [memory][1] allocated. Check this for production.

Create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

### Encryption at Host

Encryption at Host is [not supported][3] with ADE. In case you want to run it, change the variable properties in the code.

To run with Encryption at host, [enable the feature][2]:

```sh
# Register
az feature register --name EncryptionAtHost  --namespace Microsoft.Compute

# Propagate
az provider register -n Microsoft.Compute

# Confirm
az feature show --name EncryptionAtHost --namespace Microsoft.Compute
```

[1]: https://learn.microsoft.com/en-us/azure/virtual-machines/linux/disk-encryption-overview#memory-requirements
[2]: https://learn.microsoft.com/en-us/azure/virtual-machines/disks-enable-host-based-encryption-portal?tabs=azure-cli
[3]: https://learn.microsoft.com/en-us/azure/virtual-machines/disks-enable-host-based-encryption-portal?tabs=azure-cli#restrictions
