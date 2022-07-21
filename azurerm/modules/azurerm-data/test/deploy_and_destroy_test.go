package test

import (
	"fmt"
	"testing"

	// "github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// An example of a unit test for the Terraform module in examples/hello-world-app
func TestAzureDeploymentAndDestroy(t *testing.T) {
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
	fmt.Println("FCTEST DEFERRING...")

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	fmt.Println("FCTEST Before INIT...")
	terraform.InitAndApply(t, terraformOptions)
	fmt.Println("FCTEST AFTER INIT...")

	// Check that the app is working as expected
	fmt.Println("FCTEST BEFORE VALDIATE...")
	validateResponse(t, terraformOptions)
	fmt.Println("FCTEST AFTER VALDIATE...")
}

// Validate the app is working
func validateResponse(t *testing.T, terraformOptions *terraform.Options) {
	// Run `terraform output` to get the values of output variables
	adf_account_name := terraform.Output(t, terraformOptions, "ADLS_STORAGE_ACCOUNT_NAME")

	//Verify above var is not empty
	// assert for not nil (good when you expect something)
	if assert.NotNil(t, adf_account_name) {

		// now we know that object isn't nil, we are safe to make
		// further assertions without causing any errors
		assert.Contains(t, adf_account_name, "amido-stacks-test-euw-adftest")
	}
}
