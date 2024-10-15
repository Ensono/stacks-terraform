# SSL APP GATEWAY

DESCRIPTION:
---



PRE_REQUISITES:
---
NB: below only qualifies if you have run the [amido-stacks-cli](https://amido.github.io/stacks/docs/getting_started_demo) to create your component repo
NB: Because AzureDNS is not a supported LetsEncrypt plugin to authenticate an SSL certificate
As such you must first run the infrastructure once with a sample selfsigned cert included in the repo

Once complete please run the cert creation process for your domain:
```
cd $CreatedProjectDir
$ docker run -v $(pwd):/usr/data --rm -it amidostacks/ci-tf:0.0.3 /bin/bash
docker: $ cd /usr/data && chmod +x certbot.sh 
docker: $ ./certbot.sh your.domain.com email@domain.com pfxPassword1 # password is optional if ommitted will default to Password1
```

Use only the subdomain as is - the script will add the wildcard so your certificate is valid for all values in that subdomain

PS: ensure your directory you bind to on container is as per above `/usr/data`

Follow the onscreen instructions as this process has to be manual for `AzureDNS` 
Ensure your Azure created subdomain NS records have been correctly referenced by the APEX domain registrar (speak to your network admins to ensure this is the case if you are not able to do this yourself) 

Create the TXT record as instructed

```bash
$ dig TXT _acme-challenge.nonprod.amidostacks.com
```
If all successful

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_acme"></a> [acme](#provider\_acme) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_pkcs12"></a> [pkcs12](#provider\_pkcs12) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [acme_certificate.default](https://registry.terraform.io/providers/vancluever/acme/latest/docs/resources/certificate) | resource |
| [acme_registration.reg](https://registry.terraform.io/providers/vancluever/acme/latest/docs/resources/registration) | resource |
| [azurerm_application_gateway.network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_public_ip.app_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet.backend](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.frontend](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [pkcs12_from_pem.self_cert_p12](https://registry.terraform.io/providers/chilicat/pkcs12/latest/docs/resources/from_pem) | resource |
| [tls_cert_request.req](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/cert_request) | resource |
| [tls_private_key.cert_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.reg_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.self_cert](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [azurerm_public_ip.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acme_email"></a> [acme\_email](#input\_acme\_email) | Email for Acme registration, must be a valid email | `string` | n/a | yes |
| <a name="input_aks_ingress_ip"></a> [aks\_ingress\_ip](#input\_aks\_ingress\_ip) | n/a | `string` | n/a | yes |
| <a name="input_aks_resource_group"></a> [aks\_resource\_group](#input\_aks\_resource\_group) | n/a | `string` | n/a | yes |
| <a name="input_app_gateway_sku"></a> [app\_gateway\_sku](#input\_app\_gateway\_sku) | he Name of the SKU to use for this Application Gateway. Possible values are Standard\_Small, Standard\_Medium, Standard\_Large, Standard\_v2, WAF\_Medium, WAF\_Large, and WAF\_v2 | `string` | `"Standard_v2"` | no |
| <a name="input_app_gateway_tier"></a> [app\_gateway\_tier](#input\_app\_gateway\_tier) | The Tier of the SKU to use for this Application Gateway. Possible values are Standard\_v2, WAF\_v2 | `string` | `"Standard_v2"` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | n/a | `list` | `[]` | no |
| <a name="input_cert_name"></a> [cert\_name](#input\_cert\_name) | Certificate name stored under certs/ locally, to be used for SSL appgateway | `string` | `"sample.cert.pfx"` | no |
| <a name="input_create_ssl_cert"></a> [create\_ssl\_cert](#input\_create\_ssl\_cert) | ########################## CONDITIONAL SETTINGS ######################### | `bool` | `true` | no |
| <a name="input_create_valid_cert"></a> [create\_valid\_cert](#input\_create\_valid\_cert) | States if a certificate should be requested from LetsEncrypt (true) or a self-signed certificate should be generated (false) | `bool` | `true` | no |
| <a name="input_disable_complete_propagation"></a> [disable\_complete\_propagation](#input\_disable\_complete\_propagation) | n/a | `bool` | `false` | no |
| <a name="input_dns_resource_group"></a> [dns\_resource\_group](#input\_dns\_resource\_group) | RG that contains the existing DNS zones, if the zones are not being created here | `string` | `null` | no |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | ########################### # DNS SETTINGS ########################## | `string` | `""` | no |
| <a name="input_host_name"></a> [host\_name](#input\_host\_name) | Host header to be sent to the backend servers. Cannot be set if pick\_host\_name\_from\_backend\_address is set to true | `string` | `null` | no |
| <a name="input_pfx_password"></a> [pfx\_password](#input\_pfx\_password) | n/a | `string` | `"Password1"` | no |
| <a name="input_pick_host_name_from_backend_http_settings"></a> [pick\_host\_name\_from\_backend\_http\_settings](#input\_pick\_host\_name\_from\_backend\_http\_settings) | Whether the host header should be picked from the backend HTTP settings. Defaults to false. | `bool` | `false` | no |
| <a name="input_probe_path"></a> [probe\_path](#input\_probe\_path) | The Path used for this Probe. | `string` | `"/healthz"` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | n/a | `string` | `"uksouth"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_resource_group_tags"></a> [resource\_group\_tags](#input\_resource\_group\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_resource_namer"></a> [resource\_namer](#input\_resource\_namer) | n/a | `string` | `"genericname"` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | SSL policy definition, defaults to latest Predefined settings with min protocol of TLSv1.2 | <pre>object(<br>    {<br>      policy_type          = string,<br>      policy_name          = string,<br>      min_protocol_version = optional(string, null),<br>      disabled_protocols   = optional(list(string), null),<br>      cipher_suites        = optional(list(string), null),<br>    }<br>  )</pre> | <pre>{<br>  "policy_name": "AppGwSslPolicy20220101",<br>  "policy_type": "Predefined"<br>}</pre> | no |
| <a name="input_stage"></a> [stage](#input\_stage) | n/a | `string` | `"dev"` | no |
| <a name="input_subnet_backend_end_prefix"></a> [subnet\_backend\_end\_prefix](#input\_subnet\_backend\_end\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_subnet_front_end_prefix"></a> [subnet\_front\_end\_prefix](#input\_subnet\_front\_end\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_subnet_names"></a> [subnet\_names](#input\_subnet\_names) | n/a | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_subnet_prefixes"></a> [subnet\_prefixes](#input\_subnet\_prefixes) | n/a | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_vnet_cidr"></a> [vnet\_cidr](#input\_vnet\_cidr) | n/a | `list(string)` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | n/a | `string` | `"changeme"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_gateway_ip"></a> [app\_gateway\_ip](#output\_app\_gateway\_ip) | Application Gateway public IP. Should be used with DNS provider at a top level. Can have multiple subs pointing to it - e.g. app.sub.domain.com, app-uat.sub.domain.com. App Gateway will perform SSL termination for all |
| <a name="output_app_gateway_ip_name"></a> [app\_gateway\_ip\_name](#output\_app\_gateway\_ip\_name) | Application Gateway public IP name |
| <a name="output_app_gateway_name"></a> [app\_gateway\_name](#output\_app\_gateway\_name) | Name of the application gateway |
| <a name="output_app_gateway_resource_group_name"></a> [app\_gateway\_resource\_group\_name](#output\_app\_gateway\_resource\_group\_name) | Resource group of the application gateway |
| <a name="output_certificate_pem"></a> [certificate\_pem](#output\_certificate\_pem) | PEM key of certificate, can be used internally |
| <a name="output_issuer_pem"></a> [issuer\_pem](#output\_issuer\_pem) | PEM key of certificate, can be used internally together certificate to create a full cert |
