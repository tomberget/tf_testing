#output "config_map_aws_auth" {
#  value = local.config_map_aws_auth
#}

output "endpoint" {
  value = data.aws_eks_cluster.cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = data.aws_eks_cluster.cluster.certificate_authority.0.data
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}