from run_pipeline import run_adf_pipeline

import pytest


@pytest.mark.dev
def test_pipeline_success():
    parameters = {
        "windowEnd": "2021-01-01 10:00:00",
        "windowStart": "2021-01-01 11:00:00",
        "testConfig": "config_test.json",
    }

    run_data = run_adf_pipeline(parameters, "database_ingestion_example")

    assert run_data.status == "Succeeded"
