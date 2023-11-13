# Azure VM Disk Encryption

This project will create three VMs, each with a different encryption customization:

- Customer-Managed Key (CMK-SSE)
- Azure Disk Encryption (ADE)
- Encryption at Host

Create the `.auto.tfvars` configuration file:

```terraform
location = "eastus"
vm_size  = "Standard_B2ms"
```

Create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

### Customer-Managed Key (CMK-SSE)

Encryption will be performed with the Key Vault CMK key that is created.

### Azure Disk Encryption (ADE)

Check [the documentation][5] for extension. The extensions installed [does not support auto-update][4].

> ℹ️ Notice that ADE have some few restrictions with VM types and [memory][1] allocated. Check this for production.

Terraform will add the `AzureDiskEncryptionForLinux` extension and ADE will be enabled for the VM.

Underlying encryption technology:

- Windows: BitLocker
- Linux: DM-Crypt + VFAT

Other restrictions:
- Basic and A-Series VMS are not supported
- Memory requirements (check docs for Windows and Linux)
- Does not currently support ephemeral disks

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
