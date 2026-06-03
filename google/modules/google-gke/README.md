# GKE bootstrap

this module wraps around existing GruntWorks terraform modules for network and GKE bootstrap

## Pre-requisites

- GCP project name
- GCP service account
- enable APIs (once K8s enabled a lot should be enabled by default)
  - Kubernetes
  - IAM
  - network

### Enable APIs

you can do that by visiting this page: `https://console.developers.google.com/apis/api/container.googleapis.com/overview?project=$PROJECT_ID`

PROJECT_ID will be the one

## Providers

| Name        | Version |
| ----------- | ------- |
| google      | ~> 3.20 |
| google-beta | ~> 3.20 |

## Inputs

| Name                                       | Description                                                                                                                                      | Type           | Default                                                      | Required |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------ | -------------- | ------------------------------------------------------------ | :------: |
| cluster_name                               | The name of the Kubernetes cluster.                                                                                                              | `string`       | `"example-cluster"`                                          |    no    |
| cluster_service_account_description        | A description of the custom service account used for the GKE cluster.                                                                            | `string`       | `"Example GKE Cluster Service Account managed by Terraform"` |    no    |
| cluster_service_account_name               | The name of the custom service account used for the GKE cluster. This parameter is limited to a maximum of 28 characters.                        | `string`       | `"example-cluster-sa"`                                       |    no    |
| cluster_version                            | n/a                                                                                                                                              | `string`       | `"1.15.11-gke.12"`                                           |    no    |
| create_dns_zone                            | Whether or not to create a DNS zone at shared-services infrastructure level                                                                      | `bool`         | `true`                                                       |    no    |
| dns_zone                                   | DNS zone name to be created                                                                                                                      | `string`       | n/a                                                          |   yes    |
| enable_legacy_abac                         | Whether or not to create a DNS zone at shared-services infrastructure level                                                                      | `bool`         | `false`                                                      |    no    |
| enable_vertical_pod_autoscaling            | Enable vertical pod autoscaling                                                                                                                  | `string`       | `true`                                                       |    no    |
| is_cluster_private                         | Set cluster private                                                                                                                              | `bool`         | `false`                                                      |    no    |
| location                                   | The location (region or zone) of the GKE cluster.                                                                                                | `string`       | n/a                                                          |   yes    |
| name_company                               | n/a                                                                                                                                              | `string`       | `"amido"`                                                    |    no    |
| name_component                             | n/a                                                                                                                                              | `string`       | `"gke-infra"`                                                |    no    |
| name_environment                           | n/a                                                                                                                                              | `string`       | `"nonprod"`                                                  |    no    |
| name_project                               | n/a                                                                                                                                              | `string`       | `"stacks"`                                                   |    no    |
| override_default_node_pool_service_account | When true, this will use the service account that is created for use with the default node pool that comes with all GKE clusters                 | `bool`         | `false`                                                      |    no    |
| project                                    | The project ID where all resources will be launched.                                                                                             | `string`       | n/a                                                          |   yes    |
| region                                     | The region for the network. If the cluster is regional, this must be the same region. Otherwise, it should be the region of the zone.            | `string`       | n/a                                                          |   yes    |
| resource_namer                             | Unified resource namer value                                                                                                                     | `string`       | n/a                                                          |   yes    |
| service_account_roles                      | Additional Service account roles for GKE                                                                                                         | `list(string)` | `[]`                                                         |    no    |
| stage                                      | Stage of depployment - usually set by a workspace name or passed in specifically from caller                                                     | `string`       | `"nonprod"`                                                  |    no    |
| tags                                       | Tags used for uniform resource tagging                                                                                                           | `map(string)`  | `{}`                                                         |    no    |
| vpc_cidr_block                             | The IP address range of the VPC in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27.                           | `string`       | `"10.6.0.0/16"`                                              |    no    |
| vpc_secondary_cidr_block                   | The IP address range of the VPC's secondary address range in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27. | `string`       | `"10.7.0.0/16"`                                              |    no    |

## Outputs

| Name                       | Description                                                                                           |
| -------------------------- | ----------------------------------------------------------------------------------------------------- |
| client_certificate         | Public certificate used by clients to authenticate to the cluster endpoint.                           |
| client_key                 | Private key used by clients to authenticate to the cluster endpoint.                                  |
| cluster_ca_certificate     | The public certificate that is the root of trust for the cluster.                                     |
| cluster_endpoint           | The IP address of the cluster master.                                                                 |
| cluster_name               | The name of the cluster master. This output is used for interpolation with node pools, other modules. |
| gke_ingress_public_ip      | Public IP to be used for the ingress controller inside the cluster                                    |
| gke_ingress_public_ip_name | Public IP name to be used for the ingress controller inside the cluster                               |
| master_version             | The Kubernetes master version.                                                                        |
