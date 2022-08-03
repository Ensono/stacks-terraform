package test

import (
	"testing"

	// "github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

var terraformOptions = &terraform.Options{
	// The path to where our Terraform code is located
	TerraformDir: "test-options/",
	// Variables to pass to our Terraform code using -var options
	}

func TestSetup(t *testing.T) {
	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}

// An example of a unit test for the Terraform module in examples/hello-world-app
func TestCheckAdlsIsDeployed(t *testing.T) {

	adls_account_name := terraform.Output(t, terraformOptions, "ADLS_STORAGE_ACCOUNT_NAME")

	//Verify above var is not empty
	// assert for not nil (good when you expect something)
	if assert.NotNil(t, adls_account_name) {

		// now we know that object isn't nil, we are safe to make
		// further assertions without causing any errors
		assert.Contains(t, adls_account_name, "alklklk")
	}
	// A unique ID we can use to namespace all our resource names and ensure they don't clash across parallel tests
	//uniqueId := random.UniqueId()
	//uniqueId := "test"

	// Check that the app is working as expected
}

// Validate the app is working
func TestCheckAdfIsDeployed(t *testing.T) {
	// Run `terraform output` to get the values of output variables
	
	adf_factory_id := terraform.Output(t, terraformOptions, "ADF_FACTORY_ID")
	if assert.NotNil(t, adf_factory_id) {

		// now we know that object isn't nil, we are safe to make
		// further assertions without causing any errors
		assert.Contains(t, adf_factory_id, "amido-stacks-adf-test")
	}
}

func TestTeardown(t *testing.T) {
	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)
}