package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// An example of a unit test for the Terraform module in examples/hello-world-app
func TestAzureDeploymentAndDestroy(t *testing.T) {
	t.Parallel()

	// A unique ID we can use to namespace all our resource names and ensure they don't clash across parallel tests
	uniqueId := random.UniqueId()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../app",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"resource_group_name": fmt.Sprintf("fc_Terratest_%s", uniqueId),
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Check that the app is working as expected
	validateResponse(t, terraformOptions)
}

// Validate the "Hello, World" app is working
func validateResponse(t *testing.T, terraformOptions *terraform.Options) {
	// Run `terraform output` to get the values of output variables
	resource_group_id := terraform.Output(t, terraformOptions, "resource_group_id")

	//Verify above var is not empty
	// assert for not nil (good when you expect something)
	if assert.NotNil(t, resource_group_id) {

		// now we know that object isn't nil, we are safe to make
		// further assertions without causing any errors
		assert.Contains(t, resource_group_id, "1797fee2")

	}
}
