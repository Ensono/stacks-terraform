module "container_insights_irsa_iam_role" {
  count = var.cluster_addon_enable_container_insights ? 1 : 0

  source = "../eks_irsa"

  cluster_name            = var.cluster_name
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  aws_account_id          = local.account_id

  policy_prefix = "/${var.cluster_name}/"

  # See: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-prerequisites.html
  namespace                        = "amazon-cloudwatch"
  service_account_name             = "cloudwatch-agent"
  additional_service_account_names = ["amazon-cloudwatch-observability-controller-manager"]
  additional_policies              = ["CloudWatchAgentServerPolicy"]
}

################################################################################
# Nodegroup IAM Role (optional override)
################################################################################
resource "aws_iam_role" "node" {
  count = var.node_iam_assume_role_policy != null ? 1 : 0
  name_prefix           = "${var.cluster_name}-eks-node-group-"
  description           = "EKS managed node group IAM role"
  assume_role_policy    = var.node_iam_assume_role_policy
  force_detach_policies = true
  tags = var.tags
}
resource "aws_iam_role_policy_attachment" "node_policies" {
  count      = var.node_iam_assume_role_policy != null ? 3 : 0
  role       = aws_iam_role.node[0].name
  policy_arn = element([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ], count.index)
}