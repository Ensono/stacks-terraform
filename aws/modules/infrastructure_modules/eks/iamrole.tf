# If node_iam_assume_role_policy variable is set then we must create the node group IAM role in this module and pass this to the downstream module.
resource "aws_iam_role" "this" {
  for_each = local.eks_managed_iam_roles
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
