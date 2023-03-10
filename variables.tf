variable "version_regex" {
  type        = string
  default     = "latest"
  description = "required regex version of stack in elastic search for all deployment resources"
}

variable "region" {
  type        = string
  default     = "azure-centralindia"
  description = " region of stack in elastic search for deployment"
}

variable "ec_deployment_name" {
  type        = string
  default     = "Test_deployment"
  description = "required deployment template id available in specified region"
}

variable "elasticsearchid" {
  type        = string
  default     = "Test_deployment"
  description = "required deployment template id available in specified region"
}

variable "masterelasticsearchid" {
  type        = string
  default     = ""
  description = "required deployment template id available in specified region"
}

variable "elasticsearchzone" {
  type        = string
  default     = "1"
  description = "Number of zones the instance type of the Elasticsearch cluster will span"
}

variable "elasticsearchsize" {
  type        = string
  default     = "0.5g"
  description = "Amount in Gigabytes per topology element in GB notation as g"
}

variable "masterelasticsearchsize" {
  type        = string
  default     = "0.5g"
  description = "Amount in Gigabytes per topology element in GB notation as g"
}

variable "kibanazone" {
  type        = string
  default     = "1"
  description = "Number of zones the instance type of the kibana cluster will span"
}

variable "kibanasize" {
  type        = string
  default     = "0.5g"
  description = "Amount in Gigabytes per topology element in GB notation as g"
}

variable "deployment_template_id" {
  type        = string
  default     = "azure-storage-optimized"
  description = "deployment templare id"
}

variable "azure_endpoint_guid" {
  type        = string
  default     = "0.5g"
  description = "Azure endpoint GUID. Only applicable when the ruleset type is set to azure_private_endpoint"
}

variable "azure_endpoint_name" {
  type        = string
  default     = "azure-storage-optimized"
  description = " Azure endpoint name. Only applicable when the ruleset type is set to azure_private_endpoint."
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  default     = "zp-oyorooms"
  type        = string
}

variable "existing_private_dns_zone" {
  description = "Name of the existing private DNS zone"
  default     = null
  type        = string
}

variable "private_subnet_address_prefix" {
  description = "The name of the subnet for private endpoints"
  default     = ["10.0.3.0/24"]
  type        = list(string)
}

variable "private_service_connection_name" {
  description = "The name of the service connection"
  default     = "vnet-private-zone-link"
  type        = string
}

variable "download_url" {
  description = "download url of the extension"
  default     = "vnet-private-zone-link"
  type        = string
}

variable "monitoring_deployment_id" {
  description = "The id of the monitoring cluster"
  default     = "self"
  type        = string
}

variable "private_service_connection_id" {
  description = "The id for the service connection"
  default     = "centralindia-prod-016-privatelink-service.071806ca-8101-425b-ae86-737935a719d3.centralindia.azure.privatelinkservice"
  type        = string
}

variable "connection_is_manual" {
  description = "The bool datatype for is connection is manual"
  default     = false
  type        = bool
}

variable "sub_resource_name" {
  description = "The name of sub resource "
  default     = ["sql"]
  type        = list(string)
}

variable "subnet_name" {
  description = "The name of sub resource "
  default     = "zs-oyo-ds"
  type        = string
}


variable "pvt_dns_zone_name" {
  description = "The name of sub resource "
  default     = "zs-oyo-ds"
  type        = string
}

variable "vnet_rg_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = "network"
  type        = string
}

variable "location" {
  description = "A container that holds related resources for an Azure solution"
  default     = "network"
  type        = string
}

variable "ec_deployment_extension_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = "network"
  type        = string
}

variable "enable_private_endpoint" {
  default = true
  type    = bool
}


variable "plugins" {
  type    = list(string)
  default = []
}

variable "kv_name" {
  description = "Name of key vault"
  type        = string
  default     = "zp-oyorooms-db-creds-1"
}

variable "kv_rg" {
  description = "Name of resource group for key vault"
  type        = string
  default     = "key-vault"
}

variable "access_key" {
  description = "s3 es access key id"
  type        = string
  default     = "es-s3-prod-access-key"
}

variable "secret_key" {
  description = "secret value of s3 es snapshot"
  type        = string
  default     = "es-s3-prod-secret-key"
}

variable "node_type_master" {
  type    = bool
  default = false
}

variable "node_type_ingest" {
  type    = bool
  default = false
}

variable "node_type_data" {
  type    = bool
  default = false
}

variable "masternode_type_master" {
  type    = bool
  default = false
}

variable "masternode_type_ingest" {
  type    = bool
  default = false
}

variable "masternode_type_data" {
  type    = bool
  default = false
}