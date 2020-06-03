variable "cluster_id" {}
variable "external_dns_enabled" {
  default = true
}
variable "external_dns_id" {}
variable "external_dns_region" {}
variable "external_dns_chart_version" {}
variable "external_dns_role_name" {}
variable "account_id" {}
variable "txt_owner_id" {}
variable "external_dns_namespace" {
  default = "external-dns"
}