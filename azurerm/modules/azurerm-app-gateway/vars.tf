############################################
# AUTHENTICATION
############################################
# RELYING PURELY ON ENVIRONMENT VARIABLES as the user can control these from their own environment
############################################
# NAMING
############################################


variable "stage" {
  type    = string
  default = "dev"
}

variable "attributes" {
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}


############################################
# AZURE INFORMATION
############################################

# RELYING PURELY ON ENVIRONMENT VARIABLES as the user can control these from their own environment

############################################
# RESOURCE INFORMATION
############################################

variable "resource_group_location" {
  type    = string
  default = "uksouth"
}

variable "resource_group_tags" {
  type    = map(string)
  default = {}
}

variable "resource_group_name" {
  type = string
}

variable "dns_resource_group" {
  type        = string
  description = "RG that contains the existing DNS zones, if the zones are not being created here"
  default     = null
}

variable "azure_subscription_id" {
  type        = string
  description = "Optional subscription ID used by ACME azuredns challenge for DNS zone service discovery"
  default     = null
}

###########################
# CONDITIONAL SETTINGS
##########################
variable "create_ssl_cert" {
  type        = bool
  default     = true
  description = "Deprecated legacy toggle retained for compatibility. HTTPS listener and certificate configuration are now controlled by certificate_source."
}

variable "disable_complete_propagation" {
  type    = bool
  default = false
}


# ###########################
# # NETWORK SETTINGS
# ##########################

variable "vnet_name" {
  type    = string
  default = "changeme"
}

variable "vnet_cidr" {
  type = list(string)
}

variable "subnet_prefixes" {
  type    = list(string)
  default = [""]
}

variable "subnet_front_end_prefix" {
  type = string
}

variable "subnet_backend_end_prefix" {
  type = string
}

variable "subnet_names" {
  type    = list(string)
  default = [""]
}

# ###########################
# # DNS SETTINGS
# ##########################
variable "dns_zone" {
  type    = string
  default = ""
}

variable "aks_ingress_ip" {
  type = string
}

# ###########################
# # AKS SETTINGS
# ##########################

variable "aks_resource_group" {
  type = string
}

###########################
# AppGateway SETTINGS
##########################

variable "ssl_policy" {
  # NOTE: If you use `policy_type` as `Predefined`, the three variables,
  # `min_protocol_version`, `disabled_protocols`, and `cipher_suites`
  # will be ignored and TF will keep trying to apply them each run...
  type = object(
    {
      policy_type          = string,
      policy_name          = string,
      min_protocol_version = optional(string, null),
      disabled_protocols   = optional(list(string), null),
      cipher_suites        = optional(list(string), null),
    }
  )

  description = "SSL policy definition, defaults to latest Predefined settings with min protocol of TLSv1.2"

  default = {
    "policy_type" = "Predefined",
    "policy_name" = "AppGwSslPolicy20220101",
  }
}

variable "cert_name" {
  type        = string
  default     = "sample.cert.pfx"
  description = "Deprecated legacy input retained for compatibility. Inline certificate uploads are now selected through certificate_source."
}

variable "certificate_source" {
  type        = string
  default     = null
  description = "Explicit certificate source mode. Supported values are key_vault, acme, and self_signed. When unset, the module preserves legacy behavior by deriving the mode from create_valid_cert."

  validation {
    condition = var.certificate_source == null ? true : contains([
      "key_vault",
      "acme",
      "self_signed",
    ], var.certificate_source)
    error_message = "certificate_source must be one of key_vault, acme, or self_signed when set."
  }
}

variable "key_vault_secret_id" {
  type        = string
  default     = null
  description = "Versionless Azure Key Vault secret or certificate URI used when certificate_source is key_vault. Prefer a versionless secret identifier to enable certificate rotation."

  validation {
    condition = var.key_vault_secret_id == null ? true : (
      length(trimspace(var.key_vault_secret_id)) > 0 &&
      can(regex("^https://[^/]+\\.vault\\.azure\\.net/(secrets|certificates)/[^/]+/?$", var.key_vault_secret_id))
    )
    error_message = "key_vault_secret_id must be a versionless Azure Key Vault secret or certificate URI such as https://example.vault.azure.net/secrets/my-cert."
  }
}

variable "identity_type" {
  type        = string
  default     = null
  description = "Managed identity type for Application Gateway. Azure Application Gateway currently supports only UserAssigned for Key Vault-backed TLS certificates."

  validation {
    condition     = var.identity_type == null ? true : contains(["UserAssigned"], var.identity_type)
    error_message = "identity_type must be UserAssigned when set."
  }
}

variable "user_assigned_identity_ids" {
  type        = list(string)
  default     = []
  description = "List of user-assigned managed identity resource IDs to attach to the Application Gateway when identity_type is UserAssigned."

  validation {
    condition     = length([for identity_id in var.user_assigned_identity_ids : identity_id if length(trimspace(identity_id)) > 0]) == length(var.user_assigned_identity_ids)
    error_message = "user_assigned_identity_ids cannot contain empty values."
  }
}

variable "create_valid_cert" {
  type        = bool
  default     = true
  description = "Deprecated legacy selector retained for compatibility. When certificate_source is unset, true maps to acme and false maps to self_signed."
}

variable "app_gateway_sku" {
  type        = string
  default     = "Standard_v2"
  description = "he Name of the SKU to use for this Application Gateway. Possible values are Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2"
}

variable "app_gateway_tier" {
  type        = string
  default     = "Standard_v2"
  description = "The Tier of the SKU to use for this Application Gateway. Possible values are Standard_v2, WAF_v2"
}

###########################
# MISC SETTINGS
##########################

variable "resource_namer" {
  type    = string
  default = "genericname"
}

variable "pfx_password" {
  type        = string
  default     = "Password1"
  description = "Password for inline PFX material used by acme and self_signed certificate modes. Ignored when certificate_source is key_vault."
}

variable "acme_email" {
  type        = string
  default     = null
  description = "Email for ACME registration. Required when certificate_source resolves to acme."
}

variable "acme_account_key_rotation_token" {
  type        = string
  default     = null
  description = "Optional non-sensitive token used to force recreation of the ACME account key and registration. Change this value to recover from a deactivated ACME account. Use a short non-secret value such as a date or nonce. Do not use passwords, API keys, email addresses, or other sensitive or identifying data, as this value will be stored in Terraform state and may appear in resource instance keys."
}

variable "pick_host_name_from_backend_http_settings" {
  type        = bool
  default     = false
  description = "Whether the host header should be picked from the backend HTTP settings. Defaults to false."
}

variable "probe_path" {
  type        = string
  default     = "/healthz"
  description = "The Path used for this Probe."
}

variable "host_name" {
  type        = string
  default     = null
  description = "Host header to be sent to the backend servers. Cannot be set if pick_host_name_from_backend_address is set to true"
}

variable "expected_status_codes" {
  default     = ["200"]
  description = "The expect status code returned from the health probe"
}
