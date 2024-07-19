locals {
  ## Cluster
  cluster_azs = var.cluster_single_az ? [data.aws_availability_zones.available.names[0]] : data.aws_availability_zones.available.names

  cluster_container_insights_addon = var.cluster_addon_enable_container_insights ? {
    amazon-cloudwatch-observability = merge(
      {
        service_account_role_arn = module.container_insights_irsa_iam_role.0.irsa_role_arn
      },
      var.cluster_addon_container_insights_config
    )
  } : {}

  cluster_addons = merge(local.cluster_container_insights_addon)

  eks_bootstrap_extra_args = <<-EOT
  [settings.kernel]
  lockdown = "integrity"
  %{if var.eks_node_type == "SPOT"}
  [settings.kubernetes.node-labels]
  "node.kubernetes.io/lifecycle" = "spot"
  %{endif}
  %{if var.enable_cis_bootstrap == true}
  [settings.bootstrap-containers.cis-bootstrap]
  source = "${var.cis_bootstrap_image}"
  mode = "always"

  [settings.kernel.modules.udf]
  allowed = false

  [settings.kernel.modules.sctp]
  allowed = false

  [settings.kernel.sysctl]
  "net.ipv4.conf.all.send_redirects" = "0"
  "net.ipv4.conf.default.send_redirects" = "0"
  "net.ipv4.conf.all.accept_redirects" = "0"
  "net.ipv4.conf.default.accept_redirects" = "0"
  "net.ipv6.conf.all.accept_redirects" = "0"
  "net.ipv6.conf.default.accept_redirects" = "0"
  "net.ipv4.conf.all.secure_redirects" = "0"
  "net.ipv4.conf.default.secure_redirects" = "0"
  "net.ipv4.conf.all.log_martians" = "1"
  "net.ipv4.conf.default.log_martians" = "1"

  [settings.kubernetes]
  image-gc-high-threshold-percent = "${var.image_gc_high_threshold_percent}"
  image-gc-low-threshold-percent = "${var.image_gc_low_threshold_percent}"
  %{endif}
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
    bootstrap_extra_args     = local.eks_bootstrap_extra_args

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

  trusted_key_identities = var.trusted_role_arn == "" ? ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"] : ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root", "${var.trusted_role_arn}"]

  logging_bucket_kms_key_name                    = "alias/cmk-${lower(var.cluster_name)}-logging-bucket"
  logging_bucket_kms_key_description             = "Secret Encryption Key for the Flow Log Bucket"
  logging_bucket_kms_key_deletion_window_in_days = "7"
  logging_bucket_kms_key_tags = merge(
    var.tags,
    tomap({
      "Name" = local.logging_bucket_kms_key_name
    })
  )

  account_id = data.aws_caller_identity.this.account_id
}
