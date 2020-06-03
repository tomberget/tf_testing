
module "monitoring" {
  source = "./modules/monitoring"
  domain_name = var.domain_name
  org_name = var.prefix
}

module "external_dns" {
  source                     = "./modules/external_dns"
  cluster_id                 = module.eks.cluster_id
  external_dns_id            = "aws"
  external_dns_region        = var.aws_region
  external_dns_chart_version = "2.22.1"
  account_id                 = data.aws_caller_identity.current.account_id
}

module "nginx" {
  source      = "./modules/nginx"
  domain_name = var.domain_name
}