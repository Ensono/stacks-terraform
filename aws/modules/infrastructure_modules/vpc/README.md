Stacks AWS VPC Module
---------------------

Creates a VPC and a set of opinionated Subnets. Currently this module assumes
no more than 3 Availability Zones and sets up all networks (except Firewall) as
the same size.
This sets up a firewall with all domains allowed by default. This should be
tightened up as you know which domains pods will communicate with outside of the
network.

Subnets are set up one per-AZ and consist of:
 - Firewall - The Firewall resides in this subnet and nothing else should be
   provisioned here
 - Public - Public Load Balancers should reside in here and the NAT Gateways
 - Lambda
 - Database
 - Private - For Private EC2s such as EKS Nodes

The path for traffic from Private/Lambda/Database to the Internet is:
![An image showing the path from the Private/Lambda/Database subnets through the network subnets to the Internet](OutboundNetworkTrafficFlow.png)

**NOTE:** To force `ingress-nginx` to place the Load Balancers in the Public
Subnets, pass the Subnet IDs into the the annocation for the controller service:
```yml
service.beta.kubernetes.io/aws-load-balancer-subnets: "{{ aws_public_subnets }}"
```
It seems it'll use the Firewall subnets otherwise which are closer to the
Internet.

**NOTE2:** VPC Flow Logging is currently not finished due to a bug in the
downstream module: https://github.com/cloudposse/terraform-aws-vpc-flow-logs-s3-bucket/issues/66

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.firewall_alert_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.firewall_flow_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_networkfirewall_firewall.firewall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall) | resource |
| [aws_networkfirewall_firewall_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy) | resource |
| [aws_networkfirewall_logging_configuration.firewall_logging_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_logging_configuration) | resource |
| [aws_networkfirewall_rule_group.domain_allow_fw_rule_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |
| [aws_networkfirewall_rule_group.icmp_alert_fw_rule_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |
| [aws_route.firewall_to_internet_gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.ingress_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_to_firewall_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_to_internet_gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.ingress_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.network_firewall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.ingress_route_table_gw_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.network_firewall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.network_firewall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_firewall_alert_log_retention"></a> [firewall\_alert\_log\_retention](#input\_firewall\_alert\_log\_retention) | The firewall alert log retention in days | `number` | `7` | no |
| <a name="input_firewall_allowed_domain_targets"></a> [firewall\_allowed\_domain\_targets](#input\_firewall\_allowed\_domain\_targets) | The list of allowed domains which can make it through the firewall, e.g. '.foo.com' | `list(string)` | `[]` | no |
| <a name="input_firewall_deletion_protection"></a> [firewall\_deletion\_protection](#input\_firewall\_deletion\_protection) | Whether to protect the firewall from deletion | `bool` | `true` | no |
| <a name="input_firewall_enabled"></a> [firewall\_enabled](#input\_firewall\_enabled) | Whether to enable the Firewall | `bool` | `true` | no |
| <a name="input_firewall_flow_log_retention"></a> [firewall\_flow\_log\_retention](#input\_firewall\_flow\_log\_retention) | The firewall flow log retention in days | `number` | `7` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of infrastructure tags. | `map(string)` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The VPC CIDR to create | `string` | n/a | yes |
| <a name="input_vpc_instance_tenancy"></a> [vpc\_instance\_tenancy](#input\_vpc\_instance\_tenancy) | The default tenancy of instances, either 'default' or 'dedicated' | `string` | `"default"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC and resources | `string` | n/a | yes |
| <a name="input_vpc_nat_gateway_per_az"></a> [vpc\_nat\_gateway\_per\_az](#input\_vpc\_nat\_gateway\_per\_az) | Whether to spin up a NAT Gateway per-AZ or just use one. Note: There are running costs associated with NAT Gateways. For Production-like environments this should  be true | `bool` | `true` | no |
| <a name="create_tls_alert_rule"></a> [create\_tls\_alert\_rule](#create\_tls\_alert\_rule) |This variable toggles creation of tls alert rule | `bool` | `false` | no |
| <a name="icmp_alert_capacity"></a> [icmp\_alert\_capacity](#icmp\_alert\_capacity) | Capacity for ICMP alert rule group | `number` | `100` | no |
| <a name="tls_alert_capacity"></a> [tls\_alert\_capacity](#tls\_alert\_capacity) | Capacity for TLS alert rule group | `number` | `100` | no |
| <a name="domain_allow_capacity"></a> [domain\_allow\_capacity](#domain\_allow\_capacity) | Capacity for Domain allow rule group | `number` | `100` | no |
| <a name="firewall_endpoint_per_az"></a> [firewall\_endpoint\_per\_az](#firewall\_endpoint\_per_\az) | Whether to create a firewall endpoint per-AZ or just use one. Note: There are running costs associated with Firewall Endpoints. For Production-like environments this should be true | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the VPC Created by this module. |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | The IDs of the private routing tables |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | The IDs of the private subnets created by this module. |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | The IDs of the public subnets created by this module. |
<!-- END_TF_DOCS -->
