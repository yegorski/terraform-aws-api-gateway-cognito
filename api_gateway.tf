resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.name}"
  description = "Redundant description of the API Gateway resource."
}

resource "aws_api_gateway_deployment" "production" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "production"

  depends_on = [
    "aws_api_gateway_integration.hello_world",
  ]
}

resource "aws_api_gateway_base_path_mapping" "path_mapping" {
  base_path = "v1"

  api_id      = "${aws_api_gateway_rest_api.api.id}"
  domain_name = "${aws_api_gateway_domain_name.domain_name.domain_name}"
  stage_name  = "${aws_api_gateway_deployment.production.stage_name}"
}

resource "aws_api_gateway_domain_name" "domain_name" {
  certificate_arn = "${module.acm_certificate.this_acm_certificate_arn}"
  domain_name     = "api.${var.domain_name}"
}

resource "aws_api_gateway_authorizer" "authorizer" {
  name          = "${var.name}"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  provider_arns = ["${aws_cognito_user_pool.user_pool.arn}"]
}

# /hello_world endpoint
resource "aws_api_gateway_resource" "hello_world" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "hello_world"
}

resource "aws_api_gateway_method" "hello_world" {
  rest_api_id          = "${aws_api_gateway_rest_api.api.id}"
  resource_id          = "${aws_api_gateway_resource.hello_world.id}"
  http_method          = "GET"
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = "${aws_api_gateway_authorizer.authorizer.id}"
  authorization_scopes = ["${aws_cognito_resource_server.resource_server.scope_identifiers}"]
}

resource "aws_api_gateway_integration" "hello_world" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.hello_world.id}"
  http_method             = "${aws_api_gateway_method.hello_world.http_method}"
  content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda.arn}/invocations"
}
