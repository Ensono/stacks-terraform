locals {

  ## Cluster
  cluster_azs = var.cluster_single_az ? [data.aws_availability_zones.available.names[0]] : data.aws_availability_zones.available.names

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
        create_iam_role = var.node_iam_assume_role_policy != null ? false : true
        iam_role_arn = var.node_iam_assume_role_policy != null ? aws_iam_role.this["general-${v}"].arn : null
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

  # If node_iam_assume_role_policy variable is set then we must create an IAM role for the node group, one for each AZ.
  eks_managed_iam_roles = var.node_iam_assume_role_policy != null ? {
    for k, v in local.cluster_azs : "general-${v}" => {
      name = "general-${v}"
    }
  } : {}

  iam_role_policy_prefix = "arn:${data.aws_partition.current.partition}:iam::aws:policy"

  # Each IAM role about will be assigned these policies
  policies = compact([
    "${local.iam_role_policy_prefix}/AmazonEKSWorkerNodePolicy",
    "${local.iam_role_policy_prefix}/AmazonEC2ContainerRegistryReadOnly",
    "${local.iam_role_policy_prefix}/AmazonEKS_CNI_Policy",
  ])

  role_policy_combinations = flatten([
    for role in aws_iam_role.this : [
      for policy in local.policies : {
        role   = role.name
        policy = policy
      }
    ]
  ])
}
