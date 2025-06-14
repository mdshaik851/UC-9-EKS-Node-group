terraform {
  backend "s3" {
    bucket       = "uc9-eks-2"
    key          = "terraform.tfstate"
    region       = "us-east-2"
  }
}