package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// An example of a unit test for the Terraform module in examples/hello-world-app
func TestInfra_monitoring(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../app",
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Check that the app is working as expected
	validateResponseInfra(t, terraformOptions)
}

func validateResponseInfra(t *testing.T, terraformOptions *terraform.Options) {
	// Run `terraform output` to get the values of output variables
	fc_db_name := terraform.Output(t, terraformOptions, "azurerm_mssql_db_fcsql_db_name")

	// Verify above var is not empty
	// assert for not nil (good when you expect something)
	if assert.NotNil(t, fc_db_name) {

		// now we know that object isn't nil, we are safe to make
		// further assertions without causing any errors
		assert.Contains(t, fc_db_name, "fc-mssql_db")

	}
}
