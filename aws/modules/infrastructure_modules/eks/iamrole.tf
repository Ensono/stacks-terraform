################################################################################
# Nodegroup IAM Role
################################################################################

locals {
  create_node_iam_role = var.node_iam_assume_role_policy != null ? true : false
  # If node_iam_assume_role_policy variable is set then we must create an IAM role for the node group, one for each AZ.
  eks_managed_iam_roles = local.create_node_iam_role ? {
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
    for role in aws_iam_role.node : [
      for policy in local.policies : {
        role   = role.name
        policy = policy
      }
    ]
  ])
}
# If node_iam_assume_role_policy variable is set then we must create the node group IAM role in this module and pass this to the downstream module.
resource "aws_iam_role" "node" {
  for_each    = local.eks_managed_iam_roles
  name_prefix = "${each.key}-eks-node-group-"
  description = "EKS managed node group IAM role"

  assume_role_policy    = var.node_iam_assume_role_policy
  force_detach_policies = true

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  for_each = { for idx, combo in local.role_policy_combinations : idx => combo }

  role       = each.value.role
  policy_arn = each.value.policy
}


################################################################################
# Cluster IAM Role
################################################################################

locals {
  create_cluster_iam_role = var.cluster_iam_assume_role_policy != null ? true : false
  iam_role_name           = "${var.cluster_name}-cluster"

  cluster_encryption_policy_name = "${local.iam_role_name}-ClusterEncryption"
}

resource "aws_iam_role" "cluster" {
  count = local.create_cluster_iam_role ? 1 : 0

  name_prefix = "${local.iam_role_name}-"
  description = "EKS cluster IAM role"

  assume_role_policy    = var.cluster_iam_assume_role_policy
  force_detach_policies = true

  # https://github.com/terraform-aws-modules/terraform-aws-eks/issues/920
  # Resources running on the cluster are still generating logs when destroying the module resources
  # which results in the log group being re-created even after Terraform destroys it. Removing the
  # ability for the cluster role to create the log group prevents this log group from being re-created
  # outside of Terraform due to services still generating logs during destroy process
  inline_policy {
    name = local.iam_role_name

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["logs:CreateLogGroup"]
          Effect   = "Deny"
          Resource = "*"
        },
      ]
    })
  }

  tags = var.tags
}

# Policies attached ref https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html
resource "aws_iam_role_policy_attachment" "this" {
  for_each = { for k, v in {
    AmazonEKSClusterPolicy         = "${local.iam_role_policy_prefix}/AmazonEKSClusterPolicy",
    AmazonEKSVPCResourceController = "${local.iam_role_policy_prefix}/AmazonEKSVPCResourceController",
  } : k => v if local.create_cluster_iam_role }

  policy_arn = each.value
  role       = aws_iam_role.cluster[0].name
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = { for k, v in var.cluster_iam_role_additional_policies : k => v if local.create_cluster_iam_role }

  policy_arn = each.value
  role       = aws_iam_role.cluster[0].name
}

# Using separate attachment due to `The "for_each" value depends on resource attributes that cannot be determined until apply`
resource "aws_iam_role_policy_attachment" "cluster_encryption" {
  count      = local.create_cluster_iam_role ? 1 : 0
  policy_arn = aws_iam_policy.cluster_encryption[0].arn
  role       = aws_iam_role.cluster[0].name
}

resource "aws_iam_policy" "cluster_encryption" {
  count       = local.create_cluster_iam_role ? 1 : 0
  name_prefix = local.cluster_encryption_policy_name
  description = "Cluster encryption policy to allow cluster role to utilize CMK provided"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ListGrants",
          "kms:DescribeKey",
        ]
        Effect   = "Allow"
        Resource = module.eks.kms_key_arn
      },
    ]
  })

  tags = var.tags
}
