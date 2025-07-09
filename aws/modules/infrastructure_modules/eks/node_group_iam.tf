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
