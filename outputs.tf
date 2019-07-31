output "api_endpoint" {
  value       = "https://api.${var.domain_name}/hello_world"
  description = "The base URL of API Gateway. Use it to construct the full path to API resources."
}

output "auth_endpoint" {
  value       = "https://auth.${var.domain_name}/oauth2/token"
  description = "The base URL of Cognito. Use it to obtain the `access_token` with `?grant_type=client_credentials` authorization flow."
}
