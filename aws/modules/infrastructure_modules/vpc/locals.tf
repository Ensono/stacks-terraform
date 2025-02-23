locals {
  # Note this won't work if a region has 10+ AZs, but none do currently,
  # besdies this module is designed for 3 AZs anyway...
  sorted_azs = sort(data.aws_availability_zones.available.zone_ids)
  # Generates a revese map of sorted azs to their names: e.g. { "euw1-az3" =>  }
  sorted_azs_map = {for az in local.sorted_azs : az => data.aws_availability_zones.available.names[index(data.aws_availability_zones.available.zone_ids, az)]}

  logging_bucket_name                            = "${lower(var.vpc_name)}-logging-bucket"
  logging_bucket_kms_key_name                    = "alias/cmk-${local.logging_bucket_name}"
  logging_bucket_kms_key_description             = "Secret Encryption Key for the Flow Log Bucket"
  logging_bucket_kms_key_deletion_window_in_days = "7"
  logging_bucket_kms_key_tags = merge(
    var.tags,
    {
      Name = local.logging_bucket_kms_key_name
    },
  )
}
