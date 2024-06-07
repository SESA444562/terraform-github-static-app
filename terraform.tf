terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.90.0"
    }
  }
}

provider "github" {
  owner = var.destination_org
  token = var.gh_token
}

provider "azurerm" {
  features {}
}
