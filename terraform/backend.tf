terraform {
  backend "s3" {
    bucket         = "kredi-remote-backend"
    key            = "kredi-backend/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "kredi-state-lock"
  }
}