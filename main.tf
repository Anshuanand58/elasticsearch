# Retrieve the latest stack pack version

data "ec_stack" "latest" {

  version_regex = var.version_regex
  region        = var.region

}

# Create an Elastic Cloud deployment

resource "ec_deployment" "es" {

  # Optional name.

  name                   = var.ec_deployment_name
  region                 = data.ec_stack.latest.region
  version                = data.ec_stack.latest.version
  deployment_template_id = var.deployment_template_id

  elasticsearch {
    topology {
      id               = var.elasticsearchid
      size             = var.elasticsearchsize
      zone_count       = var.elasticsearchzone
      node_type_master = var.node_type_master
      node_type_ingest = var.node_type_ingest
      node_type_data   = var.node_type_data
    }

    topology {
      id               = var.masterelasticsearchid
      size             = var.masterelasticsearchsize
      zone_count       = var.elasticsearchzone
      node_type_master = var.masternode_type_master
      node_type_ingest = var.masternode_type_ingest
      node_type_data   = var.masternode_type_data
    }

    dynamic "config" {
      for_each = length(var.plugins) != 0 ? ["config"] : []
      content {
        plugins = var.plugins
      }
    }
  }
  kibana {
    topology {
      size       = var.kibanasize
      zone_count = var.kibanazone
    }
  }

  observability {
    deployment_id = var.monitoring_deployment_id
  }
  lifecycle {
    ignore_changes = [
      traffic_filter, elasticsearch[0].config
    ]
  }
}

data "azurerm_key_vault" "es" {
  name                = var.kv_name
  resource_group_name = var.kv_rg
}

data "azurerm_key_vault_secret" "access_key" {
  name         = var.access_key
  key_vault_id = data.azurerm_key_vault.es.id
}

data "azurerm_key_vault_secret" "secret_key" {
  name         = var.secret_key
  key_vault_id = data.azurerm_key_vault.es.id
}

resource "ec_deployment_elasticsearch_keystore" "access_key" {
  deployment_id = ec_deployment.es.id
  setting_name  = "s3.client.default.access_key"
  value         = data.azurerm_key_vault_secret.access_key.value
}

resource "ec_deployment_elasticsearch_keystore" "secret_key" {
  deployment_id = ec_deployment.es.id
  setting_name  = "s3.client.default.secret_key"
  value         = data.azurerm_key_vault_secret.secret_key.value
}

data "azurerm_subnet" "infra" {
  name                 = var.subnet_name
  resource_group_name  = var.vnet_rg_name
  virtual_network_name = var.virtual_network_name
}

resource "azurerm_private_endpoint" "pep1" {
  count               = var.enable_private_endpoint == true ? 1 : 0
  name                = var.ec_deployment_name
  location            = var.location
  resource_group_name = var.vnet_rg_name
  subnet_id           = data.azurerm_subnet.infra.id

  private_dns_zone_group {
    name                 = var.ec_deployment_name
    private_dns_zone_ids = [data.azurerm_private_dns_zone.infra.id]
  }
  private_service_connection {
    name                              = var.ec_deployment_name
    is_manual_connection              = true
    private_connection_resource_alias = var.private_service_connection_id
    request_message                   = "PL"
  }
}

data "azurerm_private_endpoint_connection" "private-ip1" {
  count               = var.enable_private_endpoint == true ? 1 : 0
  name                = var.ec_deployment_name
  resource_group_name = var.vnet_rg_name
  depends_on          = [ec_deployment.es, azurerm_private_endpoint.pep1]
}

data "azurerm_private_dns_zone" "infra" {
  name                = var.pvt_dns_zone_name
  resource_group_name = var.vnet_rg_name
}

resource "azurerm_private_dns_a_record" "arecord1" {
  name                = "${var.ec_deployment_name}.es"
  zone_name           = data.azurerm_private_dns_zone.infra.name
  resource_group_name = var.vnet_rg_name
  ttl                 = 300
  records             = [data.azurerm_private_endpoint_connection.private-ip1.0.private_service_connection.0.private_ip_address]
  depends_on = [
    azurerm_private_endpoint.pep1
  ]
}

resource "azurerm_private_dns_a_record" "arecord2" {
  name                = "${var.ec_deployment_name}.kb"
  zone_name           = data.azurerm_private_dns_zone.infra.name
  resource_group_name = var.vnet_rg_name
  ttl                 = 300
  records             = [data.azurerm_private_endpoint_connection.private-ip1.0.private_service_connection.0.private_ip_address]
  depends_on = [
    azurerm_private_endpoint.pep1
  ]
}

#Create Key Vault Secret
resource "azurerm_key_vault_secret" "es" {
  name         = "es-password-${var.ec_deployment_name}"
  value        = ec_deployment.es.elasticsearch_password
  key_vault_id = data.azurerm_key_vault.es.id
}

