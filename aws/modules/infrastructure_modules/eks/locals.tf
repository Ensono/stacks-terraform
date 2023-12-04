locals {

  ## Cluster
  cluster_azs = var.cluster_single_az ? [data.aws_availability_zones.available.names[0]] : data.aws_availability_zones.available.names

  eks_spot_bootstrap_extra_args = <<-EOT
  [settings.kernel]
  lockdown = "integrity"
  [settings.kubernetes.node-labels]
  "node.kubernetes.io/lifecycle" = "spot"
  EOT

  eks_on_demand_bootstrap_extra_args = <<-EOT
  [settings.kernel]
  lockdown = "integrity"
  EOT

  eks_bottlerocket_base_node_config = {
    ami_type        = "BOTTLEROCKET_x86_64"
    platform        = "bottlerocket"
    use_name_prefix = true
    ebs_optimized   = true

    metadata_options = {
      http_endpoint               = "enabled"
      http_tokens                 = "required"
      http_put_response_hop_limit = 3
    }

    iam_role_name_use_prefix = false
    bootstrap_extra_args     = var.eks_node_type == "SPOT" ? local.eks_spot_bootstrap_extra_args : local.eks_on_demand_bootstrap_extra_args

    tags = var.tags
  }

  eks_managed_node_groups = {
    for k, v in local.cluster_azs : "general-${v}" => merge(
      local.eks_bottlerocket_base_node_config,
      {
        name         = "general-${v}"
        min_size     = var.eks_minimum_nodes
        max_size     = var.eks_maximum_nodes
        desired_size = var.eks_desired_nodes

        subnet_ids = [var.vpc_private_subnets[k]]

        instance_types = [var.eks_node_size]
      }
    )
  }

  ## KMS
  eks_kms_key_name                    = "alias/cmk-${lower(var.cluster_name)}"
  eks_kms_key_description             = "Secret Encryption Key for EKS"
  eks_kms_key_deletion_window_in_days = "7"
  eks_kms_key_tags = merge(
    var.tags,
    tomap({
      "Name" = local.eks_kms_key_name
    })
  )

  logging_bucket_kms_key_name                    = "alias/cmk-${lower(var.cluster_name)}-logging-bucket"
  logging_bucket_kms_key_description             = "Secret Encryption Key for the Flow Log Bucket"
  logging_bucket_kms_key_deletion_window_in_days = "7"
  logging_bucket_kms_key_tags = merge(
    var.tags,
    tomap({
      "Name" = local.logging_bucket_kms_key_name
    })
  )
}
