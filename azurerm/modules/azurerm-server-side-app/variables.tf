############################################
# NAMING
############################################

variable "resource_namer" {
  type        = string
  description = "User defined naming convention applied to all resources created as part of this module"
}

variable "resource_tags" {
  type        = map(string)
  description = "Map of tags to be applied to all resources created as part of this module"

  default = {}
}

############################################
# AZURE INFORMATION
############################################

variable "resource_group_location" {
  type = string

  default = "uksouth"
}

variable "subscription_id" {
  type        = string
  description = "SubscriptionID passed from the caller"

  default = ""
}

###########################
# CONDITIONAL SETTINGS
##########################
variable "create_cosmosdb" {
  type        = bool
  description = "Whether to create a cosmosdb or not for this application"

  default = false
}

variable "create_cache" {
  type        = bool
  description = "Whether to create a RedisCache"

  default = false
}

variable "create_dns_record" {
  type        = bool
  description = "Whether to create a dns record"

  default = true
}

variable "create_cdn_endpoint" {
  type        = bool
  description = "Whether to create a CDN endpoint"

  default = false
}

####################
# DNS Options
####################
variable "dns_enable_alias_record" {
  type        = bool
  description = "Whether to set-up an Alias Record and ignore the list of A records in 'dns_a_records'"

  default = true
}

variable "dns_record" {
  type        = string
  description = "DNS record name"

  default = "app"
}

variable "dns_ip_address_name" {
  type        = string
  description = "The name of the IP Address to alias over"

  default = ""
}

variable "dns_ip_address_resource_group" {
  type        = string
  description = "The name of the IP Address Resource Group to alias over"

  default = ""
}

variable "dns_a_records" {
  type        = list(string)
  description = "DNS record"

  default = []
}

variable "dns_ttl" {
  type        = number
  description = "DNS TTL in seconds"

  default = 300
}

variable "dns_zone_name" {
  type        = string
  description = "Name of the DNS zone for which to create the records"

  default = "nonprod.amidostacks.com"
}

variable "dns_zone_name_internal" {
  type        = string
  description = "Name of the internal DNS zone for which to create the records"

  default = "nonprod.amidostacks.internal"
}

variable "dns_zone_resource_group" {
  type        = string
  description = "Name of the Resource group holding the DNS zone. Most commonly this would be part of core/shared services setup. Can be overridden here if you manage DNS in a separate"

  default = ""
}

####################
# CosmosDB Options
####################

variable "cosmosdb_sql_container" {
  type        = string
  description = "Specify the SQLContainer name in CosmosDB"

  default = "Menu"
}

variable "cosmosdb_sql_container_partition_key" {
  type        = string
  description = "Specify partition key"

  default = "/id"
}

variable "cosmosdb_kind" {
  type        = string
  description = "Specify the CosmosDB kind"

  default = "GlobalDocumentDB"
}
variable "cosmosdb_offer_type" {
  type        = string
  description = "Specify the offer type"

  default = "Standard"
}

####################
# RedisCache Options
####################

variable "cache_capacity" {
  type        = number
  description = "Specify desired capacity"

  default = 2
}

variable "cache_family" {
  type        = string
  description = "Specify desired compute family"

  default = "C"
}

variable "cache_sku_name" {
  type        = string
  description = "Specify desired sku_name"

  default = "Standard"
}

variable "cach_enable_non_ssl_port" {
  type        = bool
  description = "Enable non SSL port"

  default = false
}

variable "cache_minimum_tls_version" {
  type        = string
  description = "Specify minimum TLS version"

  default = "1.2"
}

variable "cache_redis_enable_authentication" {
  type        = bool
  description = "Enabale authentication. This highly recommended for any public facing clusters"

  default = true
}

variable "cache_redis_maxmemory_reserved" {
  type        = number
  description = "Specify max reserved memory"

  default = 2
}

variable "cache_redis_maxmemory_delta" {
  type        = number
  description = "Specify max memory delta"

  default = 2
}

variable "cache_redis_maxmemory_policy" {
  type        = string
  description = "Specify max memory policy"

  default = "allkeys-lru"
}

####################
# Infra RG Options
####################

variable "infra_resource_group" {
  type        = string
  description = "Provide the name of the Infra resource group"

  default = ""
}

######
# CDN
######
variable "cdn_tls_version" {
  type        = string
  description = "The TLS Version to use on the CDN"

  default = "TLS12"
}

variable "response_header_cdn" {
  type        = list(map(string))
  description = "Custom Response Headers for Microsoft CDN. Can be used with security and auditing requirements"

  default = [
    {
      action = "Append"
      name   = "Content-Security-Policy"
      value  = "default-src * 'unsafe-inline' 'unsafe-eval'"
    }
  ]
}
