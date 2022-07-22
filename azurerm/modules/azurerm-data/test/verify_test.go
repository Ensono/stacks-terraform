package test

import (
	"fmt"
	"testing"

	// "github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// An example of a unit test for the Terraform module in examples/hello-world-app
func TestAzureDeploymentAdls(t *testing.T) {
	t.Parallel()

	// A unique ID we can use to namespace all our resource names and ensure they don't clash across parallel tests
	//uniqueId := random.UniqueId()
	uniqueId := "test"

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../azurerm-data",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"data_factory_name":            fmt.Sprintf("amido-stacks-test-euw-adf%s", uniqueId),
			"region":                       "westeurope",
			"resource_group_name":          fmt.Sprintf("amido-stacks-test-euw-data%s", uniqueId),
			"adls_storage_account_name":    fmt.Sprintf("amidostacksadls%s", uniqueId),
			"default_storage_account_name": fmt.Sprintf("amidostackstesteuw%s", uniqueId),
			"platform_scope":               "stg",
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	//terraform.InitAndApply(t, terraformOptions)

	// Check that the app is working as expected
	validateInfrastructure(t, terraformOptions)
}

// Validate the app is working
func validateInfrastructure(t *testing.T, terraformOptions *terraform.Options) {
	// Run `terraform output` to get the values of output variables
	adls_account_name := terraform.Output(t, terraformOptions, "ADLS_STORAGE_ACCOUNT_NAME")
	adls_instances_clientid := terraform.OutputAll(t, terraformOptions)

	//Verify above var is not empty
	// assert for not nil (good when you expect something)
	if assert.NotNil(t, adls_account_name) {

		// now we know that object isn't nil, we are safe to make
		// further assertions without causing any errors
		assert.Contains(t, adls_account_name, "amidostacksadlstest")
	}

	if assert.NotNil(t, adls_instances_clientid) {

		// now we know that object isn't nil, we are safe to make
		// further assertions without causing any errors

		// assert.Contains(t, adls_instances_clientid, "04b07795")
		fmt.Println("adls_instances_clientid ALL ", adls_instances_clientid)
	}
}
