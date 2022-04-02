<!-- BEGIN_TF_DOCS -->
## Requriments
1. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. Azure account
3. [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

## Steps to run the project:
1. Conncte your Azure CLI to your Azure accont-`az login`.
2. Add a directory named `vasrsFiles` to the project directory.
3. Add the files `production.tfvars` and `staging.tfvars` to the `vasrsFiles` directory.


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | =2.97.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.97.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_Managed_postgres"></a> [Managed\_postgres](#module\_Managed\_postgres) | ./postgres-managed | n/a |
| <a name="module_client-vm"></a> [client-vm](#module\_client-vm) | ./vmclient | n/a |
| <a name="module_load_balancer"></a> [load\_balancer](#module\_load\_balancer) | ./load_balancer | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.ansible](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.ansible](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/network_interface) | resource |
| [azurerm_network_security_group.NSG](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.ansible-nsg](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.ansiblePip](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.RG](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.ansible](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/resource_group) | resource |
| [azurerm_subnet.DB_SB](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/subnet) | resource |
| [azurerm_subnet.ansible](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/subnet) | resource |
| [azurerm_subnet.client_SB](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.ansible](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.private_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.public_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.Vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_DBPrefix"></a> [DBPrefix](#input\_DBPrefix) | The prefix which should be used for all resources connected to the database. | `string` | `"DB-"` | no |
| <a name="input_TFPrefix"></a> [TFPrefix](#input\_TFPrefix) | The prefix which should be used for all resources connected to the web app from terraform. | `string` | `"TF-"` | no |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | n/a | `string` | `"P@ssw0rd1234!"` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | n/a | `string` | `"shay"` | no |
| <a name="input_ansible_password"></a> [ansible\_password](#input\_ansible\_password) | n/a | `string` | `"P@ssw0rd1234!"` | no |
| <a name="input_ansible_username"></a> [ansible\_username](#input\_ansible\_username) | n/a | `string` | `"shay"` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure Region in which all resources in this example should be created. | `string` | `"eastus"` | no |
| <a name="input_my_ip"></a> [my\_ip](#input\_my\_ip) | n/a | `string` | `"77.137.73.138"` | no |
| <a name="input_size"></a> [size](#input\_size) | n/a | `string` | `"Standard_b1ls"` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | n/a | `string` | `"Standard"` | no |
| <a name="input_vm_zones"></a> [vm\_zones](#input\_vm\_zones) | n/a | `list(string)` | <pre>[<br>  "1",<br>  "2",<br>  "3"<br>]</pre> | no |
| <a name="input_vmcount"></a> [vmcount](#input\_vmcount) | The number of vms to creat | `number` | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password) | n/a |
| <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username) | n/a |
<!-- END_TF_DOCS -->