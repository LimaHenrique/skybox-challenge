# Terraform block specifies the required providers for this configuration.
terraform {
  required_version = ">= 0.13" 
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.1"
    }
  }
}

# Provider block configures the Docker provider.
provider "docker" {
  host = var.docker_sock
}