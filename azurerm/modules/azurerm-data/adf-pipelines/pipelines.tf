module "example_pipeline" {
  source = "./pipeline_module"

  data_factory_id     = var.data_factory_id
  resource_group_name = var.resource_group_name
  pipeline_name       = "database_ingestion_example"
  definition_file     = "./adf-pipelines/pipeline_definitions/database_ingestion_example.json"
}