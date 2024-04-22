# This block configures the overall settings applicable to the entire Terraform project.
terraform {
  # Defines which providers are necessary for this configuration. Providers are third-party extensions that Terraform uses to manage resources in various systems, platforms, or services.
  required_providers {
    aws = {
      # Specifies the source of the AWS provider, indicating that Terraform will retrieve it from HashiCorp's official public provider registry.
      source = "hashicorp/aws"
      # Sets the version constraint for the AWS provider. "~> 4.16" means any version in the range 4.16 to less than 5.0 is acceptable, allowing for backward compatible updates.
      version = "~> 4.16"
    }
  }
  # Specifies the minimum Terraform version that is required for this configuration to work. This ensures that all features used in this configuration are supported by the Terraform version in use.
  required_version = ">= 1.2.0"
}
