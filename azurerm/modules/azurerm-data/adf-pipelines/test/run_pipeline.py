from datetime import datetime, timedelta
from azure.identity import DefaultAzureCredential
from azure.mgmt.datafactory import DataFactoryManagementClient
from azure.mgmt.datafactory.models import RunQueryFilter, RunFilterParameters

import os
import time


def create_run(adf_client, resource_group_name, factory_name, pipeline_name, parameters):
    run_id = adf_client.pipelines.create_run(
        resource_group_name, factory_name, pipeline_name, parameters=parameters
    )
    return run_id


def get_run_data(adf_client, resource_group_name, factory_name, run_id):
    status = ""
    while status not in ("Succeeded", "Failed"):
        time.sleep(10)
        df = adf_client.pipeline_runs.get(resource_group_name, factory_name, run_id)
        status = df.status
        print(f"Pipeline status: {status}, waiting 10 seconds")
    if status == "Failed":
        print("Error: Pipeline failed")
        print(df.message)

    return df


def check_for_active_run(adf_client, resource_group_name, factory_name, pipeline_names):
    status_filter = RunQueryFilter(operand="Status", operator="In", values=["InProgress", "Queued"])
    print(pipeline_names)
    pipeline_name_filter = RunQueryFilter(operand="PipelineName", operator="In", values=pipeline_names)

    filter_params = RunFilterParameters(last_updated_after=datetime.now() - timedelta(1),
                                        last_updated_before=datetime.now() + timedelta(1),
                                        filters=[status_filter, pipeline_name_filter])

    run_list = adf_client.pipeline_runs.query_by_factory(resource_group_name, factory_name, filter_params)
    run_list = run_list.value
    if run_list:
        for item in run_list:
            run_id = item.run_id
            run_data = get_run_data(adf_client, resource_group_name, factory_name, run_id)
            if run_data.status == "Failed":
                raise Exception(f"Pipeline run for {run_data.pipeline_name} failed")
        return run_data.status, run_data.run_id
    else:
        return "No run", None


def run_adf_pipeline(
        pipeline_parameters, pipeline_name, activity_data_bool=False, activity_name_filter="create_incident",
        check_for_runs_bool=False, dependant_pipelines=None
):
    subscription_id = os.environ["AZURE_SUBSCRIPTION_ID"]
    resource_group_name = os.environ["ADF_RESOURCE_GROUP_NAME"]
    factory_name = os.environ["ADF_ACCOUNT_NAME"]

    credential = DefaultAzureCredential()
    adf_client = DataFactoryManagementClient(credential, subscription_id)

    if check_for_runs_bool:
        if dependant_pipelines is None:
            dependant_pipelines = [pipeline_name]
        else:
            dependant_pipelines.append(pipeline_name)
        existing_run_status, run_id = check_for_active_run(adf_client, resource_group_name, factory_name,
                                                           dependant_pipelines)
        if existing_run_status == "No run":
            run_response = create_run(
                adf_client, resource_group_name, factory_name, pipeline_name, pipeline_parameters
            )
            run_id = run_response.run_id
    else:
        run_response = create_run(
            adf_client, resource_group_name, factory_name, pipeline_name, pipeline_parameters
        )
        run_id = run_response.run_id

    run_data = get_run_data(
        adf_client, resource_group_name, factory_name, run_id
    )
    duration = run_data.duration_in_ms

    print(f"run_id = {run_id}")

    print(f"duration_ms = {duration}")
    print(f"##vso[task.setvariable variable=duration_ms]{duration}")

    if activity_data_bool:
        activity_name = RunQueryFilter(operand="ActivityName", operator="Equals", values=[activity_name_filter])
        filter_params = RunFilterParameters(last_updated_after=datetime.now() - timedelta(1),
                                            last_updated_before=datetime.now() + timedelta(1), filters=[activity_name])
        query_response = adf_client.activity_runs.query_by_pipeline_run(resource_group_name, factory_name, run_id,
                                                                        filter_params)

        return run_data, query_response

    else:
        return run_data
