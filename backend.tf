terraform {
  backend "s3" {
    bucket = "ordering-system-serverless-state"
    key    = "ordering-system-serverless.tfstate"
    region = "us-east-1"
  }
}
