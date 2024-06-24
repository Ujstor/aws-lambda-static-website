# Static web on lambda with Terraform

## Testing

Module unit test with [Terratest](https://github.com/gruntwork-io/terratest) and go:

```bash
go test -v -timeout 30m -run TestLambdaExample
go test -v -timeout 30m -run TestLambdaApiGatewayExample
```
