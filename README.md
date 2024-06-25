# Static web on lambda with Terraform

## Testing

Module unit test with [Terratest](https://github.com/gruntwork-io/terratest) and go:

```bash
go test -v -timeout 30m -run TestLambdaExample
go test -v -timeout 30m -run TestLambdaWebExample
go test -v -timeout 30m -run TestLambdaApiExample
```
Test /register /login api:
```bash
curl -X POST https://m4o6vy5i93.execute-api.us-east-1.amazonaws.com/register \
     -H "Content-Type: application/json" \
     -d '{"username": "testuser", "password": "testpass"}'
```
