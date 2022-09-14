resource "azurerm_resource_group_template_deployment" "pipelines" {
  name                = "${var.data_factory_name}-pipelines-deployment"
  deployment_mode     = "Incremental"
  resource_group_name = var.resource_group_name
  parameters_content  = file("../adf-pipelines/arm_template_parameters.json")
  template_content    = file("../adf-pipelines/arm_template.json")
}
