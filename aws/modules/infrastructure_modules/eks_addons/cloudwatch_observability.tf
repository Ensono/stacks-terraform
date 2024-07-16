# locals {
#   default_config = {
#     agent = {
#       config = {
#         logs = {
#           metrics_collected = {
#             app_signals: {},
#             kubernetes = {
#               enhanced_container_insights = false
#             }
#           }
#         }
#       }
#     }
#   }

#   # Merge default config with custom config if provided
#   final_config = length(var.custom_config) > 0 ? var.custom_config : local.default_config
# }

resource "aws_eks_addon" "amazon_cloudwatch_observability" {

  count = var.cloudwatch_observability_enabled ? 1 : 0

  cluster_name  = var.cluster_name
  addon_name    = "amazon-cloudwatch-observability"
  addon_version = var.addon_version

  configuration_values = var.custom_config != null ? jsonencode(var.custom_config) : null

  resolve_conflicts_on_create = var.addon_resolve_conflicts_on_create
  resolve_conflicts_on_update = var.addon_resolve_conflicts_on_update
}

