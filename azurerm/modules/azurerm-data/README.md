# Stacks Azure Data Platform

This module is designed to get you up and running with a basic Azure Data Platform. 
It creates two storage accounts, one for the data lake and one for configuration, as well as a Data Factory and a Key Vault.

Out of the box, the module will create the Data Factory with linked services to the storage accounts and the Key Vault, 
datasets for the storage accounts, and a pipeline to copy data from a SQL server to the data lake.

While all the code can be edited when added to your project, it is expected that most of it will remain unchanged and
the only changes/additions will be related to the ADF pipelines you develop and their supporting resources.

Usage
-----
For now, adding this module to your project is a manual process. You will have to copy the files from this module into 
your project until support for this module is added to the Stacks CLI.

Once added to your project, you can develop your own ADF pipelines and add them to the `adf-pipelines` submodule.
Each pipeline requires a json file with the pipeline definition (located in `adf-pipelines/pipeline_definitions`) and a 
module declaration in the `adf-pipelines/pipelines.tf` file. It is recommended to develop your pipelines in the Azure in
your browser and then copy the json definition into the `pipeline_definitions` folder.

To get started with ingesting data from a SQL database, you can use the database ingestion template provided in the
`adf-pipelines/templates/database_ingestion_template` folder. For more information on how to use this template, see the
[Database Ingestion Template](https://amidodevelopment.atlassian.net/wiki/spaces/TEC/pages/3822026765/Database+Ingestion+Template)
page in Confluence.

### Testing
An example test for ensuring the example pipeline runs successfully is provided in the `adf-pipelines/tests` folder.