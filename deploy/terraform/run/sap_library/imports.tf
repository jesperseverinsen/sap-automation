# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
    Description:
      Import deployer resources
*/

data "terraform_remote_state" "deployer"          {
                                                    backend =    "azurerm"
                                                    count        = var.use_deployer && length(var.deployer_tfstate_key) > 0 ? 1 : 0
                                                    config       = {
                                                                     resource_group_name  = local.saplib_resource_group_name
                                                                     storage_account_name = local.tfstate_storage_account_name
                                                                     container_name       = local.tfstate_container_name
                                                                     key                  = local.deployer_tfstate_key
                                                                     subscription_id      = local.saplib_subscription_id
                                                                     use_msi              = var.use_spn ? false : true
                                                                   }
                                                  }

data "azurerm_key_vault_secret" "subscription_id" {
                                                    provider     = azurerm.deployer
                                                    count        = var.use_deployer && local.use_spn ? 1 : 0
                                                    name         = format("%s-subscription-id", upper(local.infrastructure.environment))
                                                    key_vault_id = local.key_vault.kv_spn_id
                                                  }

data "azurerm_key_vault_secret" "client_id"       {
                                                    provider     = azurerm.deployer
                                                    count        = var.use_deployer && local.use_spn ? 1 : 0
                                                    name         = format("%s-client-id", upper(local.infrastructure.environment))
                                                    key_vault_id = local.key_vault.kv_spn_id
                                                  }

data "azurerm_key_vault_secret" "client_secret"   {
                                                    provider     = azurerm.deployer
                                                    count        = var.use_deployer && local.use_spn ? 1 : 0
                                                    name         = format("%s-client-secret", upper(local.infrastructure.environment))
                                                    key_vault_id = local.key_vault.kv_spn_id
                                                  }

data "azurerm_key_vault_secret" "tenant_id"       {
                                                    provider     = azurerm.deployer
                                                    count        = var.use_deployer && local.use_spn ? 1 : 0
                                                    name         = format("%s-tenant-id", upper(local.infrastructure.environment))
                                                    key_vault_id = local.key_vault.kv_spn_id
                                                  }

// Import current service principal
data "azuread_service_principal" "sp"             {
                                                    count          = local.use_spn ? 1 : 0
                                                    client_id      = local.spn.client_id
                                                  }
