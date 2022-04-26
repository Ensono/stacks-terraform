variable "enable_zone" {
  description = "Conditionally create route53 zones"
  type        = bool
}

variable "enable_dynamodb" {
  description = "Conditionally create dynamodb"
  type        = bool
}

variable "tags" {
  description = "Meta data for labelling the infrastructure"
  type        = map(string)
}

variable "public_zones" {
  description = "Map of Route53 zone parameters"
  type        = map(any)
}

variable "table_name" {
  description = "The name of the table, this needs to be unique within a region."
  type        = string
}

variable "hash_key" {
  description = "The attribute to use as the hash (partition) key."
  type        = string
}

variable "attribute_name" {
  description = "Name of the attribute."
  type        = string
}

variable "attribute_type" {
  description = "Type of the attribute, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data"
}
