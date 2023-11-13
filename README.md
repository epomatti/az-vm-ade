# Azure VM + ADE

Azure Virtual Machine implementation with Azure Disk Encryption.

This project will create 3 VMs:

- Customer-Managed Key (CMK)
- Azure Disk Encryption (ADE)
- Encryption at Host

Create the `.auto.tfvars` configuration file:

```terraform
location = "eastus"
vm_size  = "Standard_B2ms"
```

> ℹ️ Notice that ADE have some few restrictions with VM types and [memory][1] allocated. Check this for production.

Create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

### Azure Disk Encryption (ADE)

Check [the documentation][5] for extension. The extensions installed [does not support auto-update][4].




### Encryption at Host

Encryption at Host is [not supported][3] with ADE and has other restrictions. Check this for production.

Keep in mind that to use Encryption at host, you have to [enable the feature][2] in the subscription:

```sh
# Register
az feature register --name EncryptionAtHost  --namespace Microsoft.Compute

# Propagate
az provider register -n Microsoft.Compute

# Confirm
az feature show --name EncryptionAtHost --namespace Microsoft.Compute
```

---

### Clean-up

Destroy the resources:

```sh
terraform destroy -auto-approve
```

[1]: https://learn.microsoft.com/en-us/azure/virtual-machines/linux/disk-encryption-overview#memory-requirements
[2]: https://learn.microsoft.com/en-us/azure/virtual-machines/disks-enable-host-based-encryption-portal?tabs=azure-cli
[3]: https://learn.microsoft.com/en-us/azure/virtual-machines/disks-enable-host-based-encryption-portal?tabs=azure-cli#restrictions
[4]: https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-extension-upgrade
[5]: https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/azure-disk-enc-linux
