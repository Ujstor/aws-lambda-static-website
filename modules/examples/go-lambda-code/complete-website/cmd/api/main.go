package main

import (
	"context"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-lambda-go/lambdacontext"
	"log"
	"portfolio-web/internal/server"
)

func handler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	lc, ok := lambdacontext.FromContext(ctx)
	if !ok {
		log.Println("Failed to get Lambda context")
		return events.APIGatewayProxyResponse{StatusCode: 500, Body: "Internal Server Error"}, nil
	}
	log.Printf("request received from AWS Lambda, request ID: %s", lc.AwsRequestID)

	srv := server.NewServer()
	resp, err := srv.HandleRequest(ctx, req)
	if err != nil {
		log.Printf("Error handling request: %v", err)
		return events.APIGatewayProxyResponse{StatusCode: 500, Body: "Internal Server Error"}, nil
	}
	return resp, nil
}

func main() {
	lambda.Start(handler)
}
