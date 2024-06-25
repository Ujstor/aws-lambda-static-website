package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestLambdaWebExample(t *testing.T) {
	t.Parallel()

	opts := &terraform.Options{
		TerraformDir: "../examples/lambda-api-gw-web/",
		Vars: map[string]interface{}{
			"environment": fmt.Sprintf("web-integration-test-%s", random.UniqueId()),
		},
	}

	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	lambdaUrl := terraform.OutputRequired(t, opts, "api_gateway_url")
	url := fmt.Sprint(lambdaUrl)
	maxRetries := 3
	timeBetweenRetries := 10 * time.Second

	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		url,
		nil,
		maxRetries,
		timeBetweenRetries,
		func(status int, body string) bool {
			if status != 200 {
				return false
			}

			normalizedBody := strings.ToLower(body)
			expected := "<h1>hello, world!</h1>"
			return strings.Contains(normalizedBody, expected)
		},
	)
}
