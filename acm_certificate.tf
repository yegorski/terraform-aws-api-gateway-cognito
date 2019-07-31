module "acm_certificate" {
  source              = "terraform-aws-modules/acm/aws"
  version             = "~> v1.0"
  domain_name         = "*.${var.domain_name}"
  zone_id             = "${aws_route53_zone.zone.id}"
  wait_for_validation = true
  tags                = "${var.tags}"
}
