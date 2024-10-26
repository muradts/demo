terraform {
  backend "azurerm" {
    resource_group_name  = "terraform"                                                                                # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "terraformmuradts"                                                                         # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate"                                                                                  # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "/hQW0g553jkNuWGp6mJ/4oyomCQVwfTY0kAzxgK3AGfFqWDP/Yxrow5Id90t+Qu8dB2EtoVvaE/K+AStLiF/UQ==" # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.0.0"
    }
  }
}