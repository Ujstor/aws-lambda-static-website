package main

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type User struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

var users = make(map[string]string)

func register(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	var user User
	err := json.Unmarshal([]byte(request.Body), &user)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusBadRequest,
			Body:       fmt.Sprintf("Error parsing request body: %v", err),
		}, nil
	}

	if _, exists := users[user.Username]; exists {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusConflict,
			Body:       "User already exists",
		}, nil
	}

	users[user.Username] = user.Password

	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusCreated,
		Body:       "User registered successfully",
	}, nil
}

func login(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	var user User
	err := json.Unmarshal([]byte(request.Body), &user)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusBadRequest,
			Body:       fmt.Sprintf("Error parsing request body: %v", err),
		}, nil
	}

	if password, exists := users[user.Username]; exists && password == user.Password {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusOK,
			Body:       "Login successful",
		}, nil
	}

	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusUnauthorized,
		Body:       "Invalid username or password",
	}, nil
}

func handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	switch request.Path {
	case "/register":
		return register(request)
	case "/login":
		return login(request)
	default:
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusNotFound,
			Body:       "Not Found",
		}, nil
	}
}

func main() {
	lambda.Start(handler)
}
