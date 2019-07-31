terraform {
  backend "s3" {
    acl     = "bucket-owner-full-control"
    bucket  = "yegorski-terraform-state"
    encrypt = true
    key     = "api-gateway-cognito.tfstate"
    region  = "us-east-1"
  }
}
