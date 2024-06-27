package test

import (
	"crypto/rand"
	"fmt"
	"math/big"
	"net"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

const letters = "abcdefghijklmnopqrstuvwxyz"

func TestLambdaWebDomainExample(t *testing.T) {
	t.Parallel()

	domain := fmt.Sprintf("%s.ujstor.com", generateRandomString(5))

	opts := &terraform.Options{
		TerraformDir: "../examples/lambda-web-domain/",
		Vars: map[string]interface{}{
			"environment": fmt.Sprintf("lambda-domain-integration-test-%s", random.UniqueId()),
			"domain":      domain,
		},
	}

	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	url := fmt.Sprintf("https://%s", domain)
	maxRetries := 25
	timeBetweenRetries := 15 * time.Second

	// Try to resolve the domain name 10 times with a 10-second delay
	var addrs []string
	var err error
	for i := 0; i < 10; i++ {
		addrs, err = net.LookupHost(domain)
		if err == nil {
			break
		}
		t.Logf("Attempt %d: Failed to resolve domain %s: %v", i+1, domain, err)
		time.Sleep(10 * time.Second)
	}

	if err != nil {
		t.Fatalf("Failed to resolve domain %s after 10 attempts: %v", domain, err)
	}
	t.Logf("Resolved IP addresses for domain %s: %v", domain, addrs)

	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		url,
		nil,
		maxRetries,
		timeBetweenRetries,
		func(status int, body string) bool {
			// Log HTTP response status and body
			t.Logf("HTTP status: %d, body: %s", status, body)
			return status == 200
		},
	)
}

func generateRandomString(length int) string {
	result := make([]byte, length)
	for i := range result {
		num, err := rand.Int(rand.Reader, big.NewInt(int64(len(letters))))
		if err != nil {
			panic(err)
		}
		result[i] = letters[num.Int64()]
	}
	return string(result)
}
