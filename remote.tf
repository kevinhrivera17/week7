terraform {
  backend "s3" {
    bucket = "challenge-state"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}