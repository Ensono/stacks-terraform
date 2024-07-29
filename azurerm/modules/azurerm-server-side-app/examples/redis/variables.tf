############################################
# NAMING
############################################

variable "name_company" {
  type = string

  default = "example"
}

variable "name_project" {
  type = string

  default = "stacks"

}

variable "name_component" {
  type = string

  default = "redis"
}

variable "stage" {
  type = string

  default = "dev"
}

variable "attributes" {
  default = []
}

variable "tags" {
  type = map(string)

  default = {}
}

# Each region must have corresponding a shortend name for resource naming purposes
variable "location_name_map" {
  type = map(string)

  default = {
    northeurope   = "eun"
    westeurope    = "euw"
    uksouth       = "uks"
    ukwest        = "ukw"
    eastus        = "use"
    eastus2       = "use2"
    westus        = "usw"
    eastasia      = "ase"
    southeastasia = "asse"
  }
}

############################################
# AZURE INFORMATION
############################################

variable "resource_group_location" {
  type = string

  default = "westeurope"
}

###########################
# CONDITIONAL SETTINGS
##########################
variable "create_cosmosdb" {
  type = bool

  default = false
}

variable "create_cache" {
  type = bool

  default = true
}

variable "create_dns_record" {
  type = bool

  default = false
}

variable "create_cdn_endpoint" {
  type = bool

  default = false
}

####################
# RedisCache Options
####################

variable "cache_capacity" {
  type = number

  default = 2
}

variable "cache_family" {
  type = string

  default = "C"
}

variable "cache_sku_name" {
  type = string

  default = "Standard"
}

variable "cach_enable_non_ssl_port" {
  type = bool

  default = false
}

variable "cache_minimum_tls_version" {
  type = string

  default = "1.2"
}

variable "cache_redis_enable_authentication" {
  type = bool

  default = true
}

variable "cache_redis_maxmemory_reserved" {
  type = number

  default = 2
}

variable "cache_redis_maxmemory_delta" {
  type = number

  default = 2
}

variable "cache_redis_maxmemory_policy" {
  type = string

  default = "allkeys-lru"
}
