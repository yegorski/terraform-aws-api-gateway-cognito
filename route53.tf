resource "aws_route53_zone" "zone" {
  name = "${var.domain_name}"
  tags = "${var.tags}"
}

resource "aws_route53_record" "test_record" {
  zone_id = "${aws_route53_zone.zone.zone_id}"
  name    = "test_record"
  type    = "TXT"

  allow_overwrite = true
  ttl             = 10

  records = [
    "this is the ${aws_route53_zone.zone.name} test record",
  ]
}

resource "aws_route53_record" "api" {
  name    = "${aws_api_gateway_domain_name.domain_name.domain_name}"
  type    = "A"
  zone_id = "${aws_route53_zone.zone.id}"

  alias {
    name                   = "${aws_api_gateway_domain_name.domain_name.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.domain_name.cloudfront_zone_id}"
    evaluate_target_health = false
  }
}

# Required for Cognito Custom Domain validation
resource "aws_route53_record" "root_record" {
  name    = "${var.domain_name}"
  type    = "A"
  zone_id = "${aws_route53_zone.zone.id}"

  alias {
    name                   = "api.${var.domain_name}"
    zone_id                = "${aws_route53_zone.zone.id}"
    evaluate_target_health = false
  }

  depends_on = [
    "aws_route53_record.api",
  ]
}

resource "aws_route53_record" "auth" {
  name    = "auth.${var.domain_name}"
  type    = "A"
  zone_id = "${aws_route53_zone.zone.id}"

  alias {
    name                   = "${aws_cognito_user_pool_domain.domain.cloudfront_distribution_arn}"
    zone_id                = "Z2FDTNDATAQYW2"  # AWS' global zone ID
    evaluate_target_health = false
  }
}
