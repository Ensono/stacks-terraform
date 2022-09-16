locals {
  pipeline_properties = jsondecode(file(var.definition_file)).properties
  pipeline_parameters = { for k, v in local.pipeline_properties.parameters : k => "" }
  pipeline_variables  = { for k, v in local.pipeline_properties.variables : k => "" }
}

resource "azurerm_data_factory_pipeline" "pipeline" {
  data_factory_id = var.data_factory_id
  name            = var.pipeline_name

  activities_json = jsonencode(local.pipeline_properties.activities)
  parameters      = local.pipeline_parameters
  variables       = local.pipeline_variables
}
