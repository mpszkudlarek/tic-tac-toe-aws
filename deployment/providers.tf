# Defines global settings for the entire Terraform configuration file
terraform {
  # A map that specifies the required providers, which are the cloud services or other platforms that Terraform will use to manage resources.
  required_providers {
    aws = {
      # Attribute within the 'aws' block that specifies the provider's source. Here, "hashicorp/aws" indicates
      # that Terraform will download the AWS provider from HashiCorp's public provider registry.
      source  = "hashicorp/aws"
      # Attribute within the 'aws' block that specifies the required version of the AWS provider.
      # Here, "~> 4.16" means Terraform will use a version of the AWS provider from 4.16 up to, but not including, 5.0.
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}
