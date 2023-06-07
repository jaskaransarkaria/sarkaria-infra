terraform {
  backend "s3" {
    bucket = "sarkaria-terraform-prod"
    key    = "infra"
    region = "eu-west-2"
  }
}
