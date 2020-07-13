############################################
# AUTHENTICATION
############################################
# RELYING PURELY ON ENVIRONMENT VARIABLES as the user can control these from their own environment
############################################
# NAMING
############################################

variable "resource_namer" {
  type = string
  description = "User defined naming convention applied to all resources created as part of this module"
}

variable "resource_tags" {
  description = "Map of tags to be applied to all resources created as part of this module"
  type    = map(string)
  default = {}
}

############################################
# AZURE INFORMATION
############################################

variable "resource_group_location" {
  type    = string
  default = "uksouth"
}

variable "subscription_id" {
  type = string
  default = ""
  description = "SubscriptionID passed from the caller"
}

###########################
# CONDITIONAL SETTINGS
##########################
variable "create_cosmosdb" {
  description = "Whether to create a cosmosdb or not for this application"
  type    = bool
  default = false
}

variable "create_cache" {
  type = bool
  description = "Whether to create a RedisCache"
  default = false
}

variable "create_dns_record" {
  type = bool
  description = "Whether to create a dns recrod"
  default = true
}

variable "create_cdn_endpoint" {
  type = bool
  default = false
  description = "Whether to create a CDN endpoint"
}

####################
# DNS Options
####################

variable "dns_record" {
  description = "DNS record name"
  type = string
  default = "app"
}

variable "dns_a_records" {
  description = "DNS record"
  type = list(string)
}

variable "dns_ttl" {
  type = number
  description = "DNS TTL in seconds"
  default = 300
}

variable "dns_zone_name" {
  description = "Name of the DNS zone for which to create the records"
  type    = string
  default = "nonprod.amidostacks.com"
}

variable "dns_zone_name_internal" {
  description = "Name of the internal DNS zone for which to create the records"
  type    = string
  default = "nonprod.amidostacks.internal"
}

variable "dns_zone_resource_group" {
  description = "Name of the Resource group holding the DNS zone. Most commonly this would be part of core/shared services setup. Can be overridden here if you manage DNS in a separate"
  type    = string
  default = ""
}

####################
# CosmosDB Options
####################

variable "cosmosdb_sql_container" {
  type = string
  description = "Specify the SQLContainer name in CosmosDB"
  default = "Menu"
}

variable "cosmosdb_sql_container_partition_key" {
  type = string
  default = "/id"
  description = "Specify partition key"
}

variable "cosmosdb_kind" {
  type = string
  default = "GlobalDocumentDB"
  description = "Specify the CosmosDB kind"
}
variable "cosmosdb_offer_type" {
  type = string
  default = "Standard"
  description = "Specify the offer type"
}

####################
# RedisCache Options
####################

variable "cache_capacity" {
  type = number
  default = 2
  description = "Specify desired capacity"
}

variable "cache_family" {
  type = string
  default = "C"
  description = "Specify desired compute family"
}

variable "cache_sku_name" {
  type = string
  default = "Standard"
  description = "Specify desired sku_name"
}

variable "cach_enable_non_ssl_port" {
  type = bool
  default = false
  description = "Enable non SSL port"
}

variable "cache_minimum_tls_version" {
  type = string
  default = "1.2"
  description = "Specify minimum TLS version"
}

variable "cache_redis_enable_authentication" {
  type = bool
  default = true
  description = "Enabale authentication. This highly recommended for any public facing clusters"
}

variable "cache_redis_maxmemory_reserved" {
  type = number
  default = 2
  description = "Specify max reserved memory"
}

variable "cache_redis_maxmemory_delta" {
  type = number
  default = 2
  description = "Specify max memory delta"
}

variable "cache_redis_maxmemory_policy" {
  type = string
  default = "allkeys-lru"
  description = "Specify max memory policy"
}

####################
# Core RG Options
####################

variable "core_resource_group" {
  type = string
  default = ""
  description = "Provide the name of the core resource group"
}

########################
# CDN Response Headers #
########################

variable "response_header_cdn" {
  type = list(map(string))
  description = "Custom Response Headers for Microsoft CDN. Can be used with security and auditing requirements"
  default = [
    {
      action = "Append"
      name = "Content-Security-Policy"
      value = "default-src * 'unsafe-inline' 'unsafe-eval'"
    }
  ]
}
