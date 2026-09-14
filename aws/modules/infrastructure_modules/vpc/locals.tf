locals {
  # Resources passed into the AWS VPC module try to name themselves and passing
  # in a tag called Name means they use that instead. This breaks naming when
  # there's multiple resources, so unset it here.
  tags_no_name = { for k, v in var.tags : k => v if !contains(["Name"], k) }

  # This module is designed for exactly 3 AZs; slice to 3 even if the region has more.
  # When availability_zone_ids is provided, use that explicit order (preserves an existing/brownfield subnet
  # layout and avoids a destructive re-lay); otherwise default to sorting by Zone ID.
  sorted_azs = length(var.availability_zone_ids) > 0 ? slice(var.availability_zone_ids, 0, 3) : slice(sort(data.aws_availability_zones.available.zone_ids), 0, 3)

  # Generates a reverse map of sorted azs to their names: e.g. { "euw2-az1" => "eu-west-2a" }
  sorted_azs_map = { for az in local.sorted_azs : az => data.aws_availability_zones.available.names[index(data.aws_availability_zones.available.zone_ids, az)] }

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
