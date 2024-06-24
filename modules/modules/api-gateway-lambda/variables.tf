variable "api_gw_conf" {
  description = "API Gateway configuration"
  type = object({
    name          = string
    protocol_type = string
  })
  default = {
    name          = "api-gw"
    protocol_type = "HTTP"
  }
}

variable "lambda_integration_route_premission" {
  description = "Lambda integration, route and permission configuration"
  type = object({
    integration_type                  = string
    integration_method                = string
    connection_type                   = string
    route_key                         = string
    statement_id                      = string
    action                            = string
    principal                         = string
    authorizer_type                   = string
    indentity_sources                 = set(string)
    authorizer_name                   = string
    authorizer_payload_format_version = string
  })
}

variable "lambda_invoke_arn" {
  description = "The ARN of the Lambda function to invoke"
  type        = string
}

variable "lambda_func_name" {
  description = "The name of the Lambda function to invoke"
  type        = string
}

variable "authorizer_uri" {
  description = "The URI of the authorizer, lambda invoke arn"
  type        = string
}
