terraform {
  required_version = ">=1.0.0"
  required_providers {
    aws = {
      version = ">= 3.53.0"
      source  = "hashicorp/aws"
    }
  }
}