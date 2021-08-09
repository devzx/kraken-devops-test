provider "aws" {
  region = "eu-west-2"
}

module "iam" {
  # Replace with git repo uri / version
  source = "./aws-iam"

  name                    = var.name
  resource_prefix_enabled = true
}
