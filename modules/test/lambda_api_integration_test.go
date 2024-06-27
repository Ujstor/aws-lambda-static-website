package test

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

type User struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

func TestLambdaApiExample(t *testing.T) {
	t.Parallel()

	opts := &terraform.Options{
		TerraformDir: "../examples/lambda-api-gw-api/",
		Vars: map[string]interface{}{
			"environment": fmt.Sprintf("sandbox-integrationAPI-test-%s", random.UniqueId()),
		},
	}

	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	lambdaUrl := terraform.OutputRequired(t, opts, "api_gateway_url")
	url := fmt.Sprint(lambdaUrl)

	time.Sleep(10 * time.Second)

	testUser := User{
		Username: "testuser",
		Password: "testpassword",
	}

	registerUrl := fmt.Sprintf("%s/register", url)
	loginUrl := fmt.Sprintf("%s/login", url)

	time.Sleep(15 * time.Second)
	registerAndLogin(t, registerUrl, loginUrl, testUser)

}

func registerAndLogin(t *testing.T, registerUrl, loginUrl string, testUser User) {
	// Register User
	registerResponse := sendHttpPostRequest(t, registerUrl, testUser)
	assert.Equal(t, http.StatusCreated, registerResponse.StatusCode, "Expected 201 Created status for user registration")

	// Attempt to register the same user again
	duplicateRegisterResponse := sendHttpPostRequest(t, registerUrl, testUser)
	assert.Equal(t, http.StatusConflict, duplicateRegisterResponse.StatusCode, "Expected 409 Conflict status for duplicate user registration")

	// Test user login with correct credentials
	loginResponse := sendHttpPostRequest(t, loginUrl, testUser)
	assert.Equal(t, http.StatusOK, loginResponse.StatusCode, "Expected 200 OK status for successful login")

	// Test user login with incorrect credentials
	invalidUser := User{
		Username: "testuser",
		Password: "wrongpassword",
	}
	invalidLoginResponse := sendHttpPostRequest(t, loginUrl, invalidUser)
	assert.Equal(t, http.StatusUnauthorized, invalidLoginResponse.StatusCode, "Expected 401 Unauthorized status for invalid login")
}

func sendHttpPostRequest(t *testing.T, url string, user User) *http.Response {
	jsonUser, err := json.Marshal(user)
	if err != nil {
		t.Fatalf("Failed to marshal user: %v", err)
	}

	req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonUser))
	if err != nil {
		t.Fatalf("Failed to create HTTP request: %v", err)
	}
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		t.Fatalf("Failed to send HTTP request: %v", err)
	}

	return resp
}
