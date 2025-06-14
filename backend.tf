terraform {
  backend "s3" {
    bucket       = "uc-9-eks-new-latest"
    key          = "terraform.tfstate"
    region       = "us-west-1"
  }
}