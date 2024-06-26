package main

import (
	"context"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func HandleRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	htmlBody := "<html><body><h1>Hello, World!</h1></body></html>"

	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Headers: map[string]string{
			"Content-Type": "text/html",
		},
		Body: htmlBody,
	}, nil
}

func main() {
	lambda.Start(HandleRequest)
}
