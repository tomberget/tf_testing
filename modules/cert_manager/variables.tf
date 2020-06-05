variable "cert_manager_enabled" {
  default = true
}
variable "cert_manager_namespace" {
  default = "cert-manager"
}
variable "cert_manager_chart_version" {}
variable "hostedzone_id" {}
variable "open_id_connect_arn" {}
variable "identity_oidc_issuer" {}
variable "worker_iam_role_arn" {}
variable "account_id" {}
variable "email" {}
variable "region" {}
variable "domain_name" {}