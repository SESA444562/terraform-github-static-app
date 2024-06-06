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

resource "github_repository" "gh_repo" {
  name       = var.waypoint_application
  visibility = "public"

  template {
    owner                = var.template_org
    repository           = var.template_repo
    include_all_branches = false
  }

  # Enable GitHub pages
  pages {
    build_type = "workflow"
  }
}

resource "github_repository_file" "readme" {
  repository = github_repository.gh_repo.name
  branch     = "main"
  file       = "README.md"
  content = templatefile("${path.module}/templates/README.md", {
    application_name = var.waypoint_application,
    destination_org  = var.destination_org
  })
  commit_message      = "Added readme file."
  commit_author       = "Platform team"
  commit_email        = "no-reply@example.com"
  overwrite_on_create = true
}

resource "github_actions_environment_secret" "slack_hook_url" {
  repository      = github_repository.gh_repo.name
  environment     = "github-pages"
  secret_name     = "SLACK_HOOK_URL"
  plaintext_value = var.slack_hook_url
}

###### AZURERM ######

data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}

resource "azurerm_key_vault" "test-add-on" {
  name                = "kv-test-add-on"
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  sku_name            = "standard"
  tenant_id           = "db8e2ba9-95c1-4fbb-b558-6bf8bb1d2981"
}
