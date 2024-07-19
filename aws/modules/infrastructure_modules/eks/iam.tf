module "container_insights_irsa_iam_role" {
  count = var.cluster_addon_enable_container_insights ? 1 : 0

  source = "../eks_irsa"

  cluster_name            = "${var.cluster_name}"
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  aws_account_id          = local.account_id

  # See: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-prerequisites.html
  namespace            = "amazon-cloudwatch"
  service_account_name = "observability-agent"
  additional_policies  = ["CloudWatchAgentServerPolicy"]
}
