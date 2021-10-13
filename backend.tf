terraform {
  backend "s3" {
    bucket = "terraform-session-akim"
    key    = "web/terraform.tfstate"
    region = "us-west-2"
  }
}