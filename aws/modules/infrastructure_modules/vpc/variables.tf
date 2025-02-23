# VPC
variable "region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Map of infrastructure tags."
}

variable "vpc_cidr" {
  type        = string
  description = "The VPC CIDR to create"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC and resources"
}

variable "vpc_nat_gateway_per_az" {
  type        = bool
  description = "Whether to spin up a NAT Gateway per-AZ or just use one. Note: There are running costs associated with NAT Gateways. For Production-like environments this should  be true"

  default = true
}

variable "vpc_instance_tenancy" {
  type        = string
  description = "The default tenancy of instances, either 'default' or 'dedicated'"

  default = "default"

  validation {
    condition     = contains(["default", "dedicated"], var.vpc_instance_tenancy)
    error_message = "Must be one of 'default' or 'dedicated'."
  }
}

# Subnets
variable "vpc_subnet_names_public" {
  type        = list(string)
  description = "Names of the Public Subnet resources"

  default = []
}

variable "vpc_subnet_names_private" {
  type        = list(string)
  description = "Names of the Private Subnet resources"

  default = []
}

variable "vpc_subnet_names_database" {
  type        = list(string)
  description = "Names of the Database Subnet resources"

  default = []
}

variable "vpc_subnet_names_firewall" {
  type        = list(string)
  description = "Names of the Firewall Subnet resources"

  default = []
}

variable "vpc_subnet_names_lambda" {
  type        = list(string)
  description = "Names of the Lambda Subnet resources"

  default = []
}

variable "vpc_internet_gateway_name" {
  type        = string
  description = "Name of the Internet Gateway resources"

  default = null
}

variable "vpc_ingress_route_table_name" {
  type        = string
  description = "Name of the Ingress Route Table resources"

  default = null
}

variable "vpc_nat_gateway_names" {
  type        = list(string)
  description = "Names of the Nat Gateway resources"

  default = []
}

variable "vpc_acl_firewall_name" {
  type        = string
  description = "Name of the Firewall Network ACL resource"

  default = null
}

variable "vpc_acl_public_name" {
  type        = string
  description = "Name of the Public Network ACL resource"

  default = null
}

variable "vpc_acl_private_name" {
  type        = string
  description = "Name of the Private Network ACL resource"

  default = null
}

variable "vpc_acl_database_name" {
  type        = string
  description = "Name of the Database Network ACL resource"

  default = null
}

# VPC Flow Logs
variable "flow_log_enabled" {
  type        = bool
  description = "Whether to enable the VPC Flowlogs, currently false as experimental fixes are applied. See: https://github.com/cloudposse/terraform-aws-vpc-flow-logs-s3-bucket/issues/66"

  default = false
}

variable "flow_log_noncurrent_version_expiry_days" {
  type        = number
  description = "Specifies when noncurrent object versions expire"

  default = 90
}

variable "flow_log_noncurrent_version_transition_days" {
  type        = number
  description = "Specifies when noncurrent object versions transitions"

  default = 30
}

variable "flow_log_standard_transition_days" {
  type        = number
  description = "Number of days to persist in the standard storage tier before moving to the infrequent access tier"

  default = 30
}

variable "flow_log_glacier_transition_days" {
  type        = number
  description = "Number of days after which to move the data to the glacier storage tier"

  default = 60
}

variable "flow_log_expiry_days" {
  type        = number
  description = "Number of days after which to expunge the objects"

  default = 90
}

variable "flow_log_force_destroy" {
  type        = bool
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable"

  default = false
}

variable "flow_log_allow_ssl_requests_only" {
  type        = bool
  description = "Set to 'true' to require requests to use Secure Socket Layer (HTTPS/SSL). This will explicitly deny access to HTTP requests"

  default = true
}

# Firewall
variable "firewall_enabled" {
  type        = bool
  description = "Whether to enable the Firewall"

  default = true
}

variable "firewall_deletion_protection" {
  type        = bool
  description = "Whether to protect the firewall from deletion"

  default = true
}

variable "firewall_alert_log_retention" {
  type        = number
  description = "The firewall alert log retention in days"

  default = 7
}

variable "firewall_flow_log_retention" {
  type        = number
  description = "The firewall flow log retention in days"

  default = 7
}

variable "firewall_allowed_domain_targets" {
  type        = list(string)
  description = "The list of allowed domains which can make it through the firewall, e.g. '.foo.com'"

  default = []
}

variable "create_tls_alert_rule" {
  type        = bool
  description = "This variable toggles creation of tls alert rule"

  default = false
}

variable "icmp_alert_capacity" {
  type    = number
  default = 100

  description = "Capacity for ICMP alert rule group"
}

variable "tls_alert_capacity" {
  type    = number
  default = 100

  description = "Capacity for TLS alert rule group"
}

variable "domain_allow_capacity" {
  type    = number
  default = 100

  description = "Capacity for Domain allow rule group"
}

variable "firewall_endpoint_per_az" {
  type        = bool
  description = "Whether to create a firewall endpoint per-AZ or just use one. Note: There are running costs associated with Firewall Endpoints. For Production-like environments this should be true"

  default = true
}

# Subnet ACLs
variable "create_public_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for public subnets"
  type        = bool
  default     = false
}

variable "public_inbound_acl_rules" {
  description = "Public subnets inbound network ACLs"
  type = list(object({
    rule_number = number
    rule_action = string
    protocol    = any
    from_port   = optional(number, 0)
    to_port     = optional(number, 0)
    cidr_block  = optional(string, "0.0.0.0/0")
  }))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "public_outbound_acl_rules" {
  description = "Public subnets outbound network ACLs"
  type = list(object({
    rule_number = number
    rule_action = string
    protocol    = any
    from_port   = optional(number, 0)
    to_port     = optional(number, 0)
    cidr_block  = optional(string, "0.0.0.0/0")
  }))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "create_private_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for private subnets"
  type        = bool
  default     = false
}

variable "private_inbound_acl_rules" {
  description = "Private subnets inbound network ACLs"
  type = list(object({
    rule_number = number
    rule_action = string
    protocol    = any
    from_port   = optional(number, 0)
    to_port     = optional(number, 0)
    cidr_block  = optional(string, "0.0.0.0/0")
  }))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "private_outbound_acl_rules" {
  description = "Private subnets outbound network ACLs"
  type = list(object({
    rule_number = number
    rule_action = string
    protocol    = any
    from_port   = optional(number, 0)
    to_port     = optional(number, 0)
    cidr_block  = optional(string, "0.0.0.0/0")
  }))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "create_database_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for database subnets"
  type        = bool
  default     = false
}

variable "database_inbound_acl_rules" {
  description = "Database subnets inbound network ACLs"
  type        = list(object({
    rule_number = number
    rule_action = string
    protocol    = any
    from_port   = optional(number, 0)
    to_port     = optional(number, 0)
    cidr_block  = optional(string, "0.0.0.0/0")
  }))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "database_outbound_acl_rules" {
  description = "Database subnets outbound network ACLs"
  type        = list(object({
    rule_number = number
    rule_action = string
    protocol    = any
    from_port   = optional(number, 0)
    to_port     = optional(number, 0)
    cidr_block  = optional(string, "0.0.0.0/0")
  }))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "create_lambda_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for lamda subnets"
  type        = bool
  default     = false
}

variable "lambda_inbound_acl_rules" {
  description = "Lambda subnets inbound network ACLs"
  type        = list(object({
    rule_number = number
    rule_action = string
    protocol    = any
    from_port   = optional(number, 0)
    to_port     = optional(number, 0)
    cidr_block  = optional(string, "0.0.0.0/0")
  }))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "lambda_outbound_acl_rules" {
  description = "Lambda subnets outbound network ACLs"
  type        = list(object({
    rule_number = number
    rule_action = string
    protocol    = any
    from_port   = optional(number, 0)
    to_port     = optional(number, 0)
    cidr_block  = optional(string, "0.0.0.0/0")
  }))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "create_network_firewall_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for network firewall subnets"
  type        = bool
  default     = false
}

variable "network_firewall_inbound_acl_rules" {
  description = "Network firewall subnets inbound network ACLs"
  type        = list(object({
    rule_number = number
    rule_action = string
    protocol    = any
    from_port   = optional(number, 0)
    to_port     = optional(number, 0)
    cidr_block  = optional(string, "0.0.0.0/0")
  }))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "network_firewall_outbound_acl_rules" {
  description = "Network firewall subnets outbound network ACLs"
  type        = list(object({
    rule_number = number
    rule_action = string
    protocol    = any
    from_port   = optional(number, 0)
    to_port     = optional(number, 0)
    cidr_block  = optional(string, "0.0.0.0/0")
  }))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_block  = "0.0.0.0/0"
    },
  ]
}
