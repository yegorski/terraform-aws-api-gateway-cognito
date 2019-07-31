resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.name}"
  tags = "${var.tags}"
}

resource "aws_cognito_resource_server" "resource_server" {
  name         = "${var.name}"
  identifier   = "https://api.${var.domain_name}"
  user_pool_id = "${aws_cognito_user_pool.user_pool.id}"

  scope {
    scope_name        = "all"
    scope_description = "Get access to all API Gateway endpoints."
  }
}

###
# TODO: provisioning of Cognito Custom Domain times out on `terraform apply`.
# See the `Manual Steps` section in README.md.
###
# resource "aws_cognito_user_pool_domain" "domain" {
#   domain          = "auth.${var.domain_name}"
#   certificate_arn = "${module.acm_certificate.this_acm_certificate_arn}"
#   user_pool_id    = "${aws_cognito_user_pool.user_pool.id}"

#   depends_on = [
#     "aws_cognito_user_pool.user_pool",
#     "aws_cognito_resource_server.resource_server",
#     "aws_route53_record.root_record",
#   ]
# }

resource "aws_cognito_user_pool_client" "client" {
  name                                 = "${var.name}"
  user_pool_id                         = "${aws_cognito_user_pool.user_pool.id}"
  generate_secret                      = true
  allowed_oauth_flows                  = ["client_credentials"]
  supported_identity_providers         = ["COGNITO"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["${aws_cognito_resource_server.resource_server.scope_identifiers}"]

  depends_on = [
    "aws_cognito_user_pool.user_pool",
    "aws_cognito_resource_server.resource_server",
  ]
}
