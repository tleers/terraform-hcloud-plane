# Module reference

This page is generated from the root module. Run `make docs` after changing variables, outputs, providers, or requirements.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | ~> 1.64 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | 1.68.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [hcloud_firewall.plane](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall) | resource |
| [hcloud_primary_ip.plane](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/primary_ip) | resource |
| [hcloud_server.plane](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server) | resource |
| [hcloud_ssh_key.plane](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/ssh_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_admin_email"></a> [admin\_email](#input\_admin\_email) | Email used for Let's Encrypt certificate notices. | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Public hostname for Plane, for example plane.example.com. | `string` | n/a | yes |
| <a name="input_enable_backups"></a> [enable\_backups](#input\_enable\_backups) | Enable Hetzner's seven rotating server backup slots. | `bool` | `true` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Attach a free public IPv6 address to the server. | `bool` | `true` | no |
| <a name="input_image"></a> [image](#input\_image) | Hetzner image used for the server. The bootstrap is tested with Ubuntu 24.04. | `string` | `"ubuntu-24.04"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Additional labels merged onto the server's module-managed labels. | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Hetzner Cloud location. | `string` | `"nbg1"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name used for the Plane server and firewall. | `string` | `"plane"` | no |
| <a name="input_plane_version"></a> [plane\_version](#input\_plane\_version) | Pinned Plane Community Edition release. Upgrade deliberately after taking a backup. | `string` | `"v1.4.2"` | no |
| <a name="input_protect_server"></a> [protect\_server](#input\_protect\_server) | Enable Hetzner delete and rebuild protection. Set false and apply before intentionally destroying. | `bool` | `true` | no |
| <a name="input_server_type"></a> [server\_type](#input\_server\_type) | Hetzner server type. The default CAX11 provides 2 ARM vCPU, 4 GB RAM, and 40 GB disk; choose CAX21 for the 8 GB profile. | `string` | `"cax11"` | no |
| <a name="input_ssh_allowed_cidrs"></a> [ssh\_allowed\_cidrs](#input\_ssh\_allowed\_cidrs) | IPv4 or IPv6 CIDRs allowed to SSH to the server. Keep this narrow. | `list(string)` | n/a | yes |
| <a name="input_ssh_key_ids"></a> [ssh\_key\_ids](#input\_ssh\_key\_ids) | Existing Hetzner Cloud SSH key IDs to install in addition to ssh\_public\_key. | `list(string)` | `[]` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public key to create and install for root access. Set null when supplying existing ssh\_key\_ids. | `string` | `null` | no |
| <a name="input_swap_size_gb"></a> [swap\_size\_gb](#input\_swap\_size\_gb) | Size of the persistent host swap file in GiB. The default is a 2 GiB OOM safety valve for the CAX11 profile, not a substitute for adequate RAM. | `number` | `2` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_bootstrap_log_command"></a> [bootstrap\_log\_command](#output\_bootstrap\_log\_command) | Command for waiting on cloud-init and showing the sanitized bootstrap tail. |
| <a name="output_firewall_id"></a> [firewall\_id](#output\_firewall\_id) | Hetzner Cloud Firewall ID. |
| <a name="output_ipv4_address"></a> [ipv4\_address](#output\_ipv4\_address) | Create your domain's A record with this address. |
| <a name="output_ipv6_address"></a> [ipv6\_address](#output\_ipv6\_address) | Optional IPv6 address for an AAAA record. |
| <a name="output_plane_url"></a> [plane\_url](#output\_plane\_url) | Public HTTPS URL for the Plane instance. |
| <a name="output_server_id"></a> [server\_id](#output\_server\_id) | Hetzner Cloud server ID. |
| <a name="output_ssh_command"></a> [ssh\_command](#output\_ssh\_command) | Command for connecting to the server as root. |
<!-- END_TF_DOCS -->
