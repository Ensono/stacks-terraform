# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables are expected to be passed in by the operator.
# ---------------------------------------------------------------------------------------------------------------------

variable "project" {
  description = "The project ID where all resources will be launched."
  type        = string
}

variable "location" {
  description = "The location (region or zone) of the GKE cluster."
  type        = string
}

variable "region" {
  description = "The region for the network. If the cluster is regional, this must be the same region. Otherwise, it should be the region of the zone."
  type        = string
}

variable "resource_namer" {
  description = "Unified resource namer value"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# BUSINESS PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "name_company" {
  type    = string
  default = "amido"
}

variable "name_project" {
  type    = string
  default = "stacks"
}

variable "name_component" {
  type    = string
  default = "gke-infra"
}

variable "name_environment" {
  type    = string
  default = "nonprod"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  type        = string
  default     = "example-cluster"
}

variable "cluster_service_account_name" {
  description = "The name of the custom service account used for the GKE cluster. This parameter is limited to a maximum of 28 characters."
  type        = string
  default     = "example-cluster-sa"
}

variable "cluster_service_account_description" {
  description = "A description of the custom service account used for the GKE cluster."
  type        = string
  default     = "Example GKE Cluster Service Account managed by Terraform"
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation (size must be /28) to use for the hosted master network. This range will be used for assigning internal IP addresses to the master or set of masters, as well as the ILB VIP. This range must not overlap with any other ranges in use within the cluster's network."
  type        = string
  default     = "10.5.0.0/28"
}

# For the example, we recommend a /16 network for the VPC. Note that when changing the size of the network,
# you will have to adjust the 'cidr_subnetwork_width_delta' in the 'vpc_network' -module accordingly.
variable "vpc_cidr_block" {
  description = "The IP address range of the VPC in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27."
  type        = string
  default     = "10.6.0.0/16"
}

# For the example, we recommend a /16 network for the secondary range. Note that when changing the size of the network,
# you will have to adjust the 'cidr_subnetwork_width_delta' in the 'vpc_network' -module accordingly.
variable "vpc_secondary_cidr_block" {
  description = "The IP address range of the VPC's secondary address range in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27."
  type        = string
  default     = "10.7.0.0/16"
}

variable "enable_vertical_pod_autoscaling" {
  description = "Enable vertical pod autoscaling"
  type        = string
  default     = true
}

variable "service_account_roles" {
  type        = list(string)
  description = "Additional Service account roles for GKE"
  default     = []
}
# ---------------------------------------------------------------------------------------------------------------------
# TEST PARAMETERS
# These parameters are only used during testing and should not be touched.
# ---------------------------------------------------------------------------------------------------------------------

variable "override_default_node_pool_service_account" {
  description = "When true, this will use the service account that is created for use with the default node pool that comes with all GKE clusters"
  type        = bool
  default     = false
}

# --------
# Stacks Additions
#
# -----------

variable "stage" {
  description = "Stage of depployment - usually set by a workspace name or passed in specifically from caller"
  type        = string
  default     = "nonprod"
}

variable "tags" {
  description = "Tags used for uniform resource tagging"
  type        = map(string)
  default     = {}
}

variable "create_dns_zone" {
  description = "Whether or not to create a DNS zone at shared-services infrastructure level"
  type        = bool
  default     = true
}

variable "dns_zone" {
  description = "DNS zone name to be created "
  type        = string
}

variable "enable_legacy_abac" {
  description = "Whether or not to create a DNS zone at shared-services infrastructure level"
  type        = bool
  default     = false
}

variable "cluster_version" {
  type    = string
  default = "1.23.12-gke.100"
}

variable "is_cluster_private" {
  type        = bool
  description = "Set cluster private"
  default     = false
}

variable "node_machine_type" {
  type    = string
  default = "n1-standard-1"
}

variable "min_node_count" {
  type    = number
  default = 1
}
variable "max_node_count" {
  type    = number
  default = 5
}