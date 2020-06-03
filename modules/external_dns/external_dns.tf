resource "kubernetes_namespace" "external_dns" {
  metadata {
    annotations = {
      name = var.external_dns_namespace
    }

    name = var.external_dns_namespace
  }
}

resource "helm_release" "external_dns" {
  count = var.external_dns_enabled ? 1 : 0

  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = var.external_dns_chart_version
  namespace  = "external-dns"
  timeout    = 600

  values = [
    data.template_file.external_dns_config.rendered
  ]
}

data "template_file" "external_dns_config" {
  template = file("${path.root}/config/external-dns/config.yaml")

  vars = {
    external_dns_region    = var.external_dns_region
    account_id             = var.account_id
    txt_owner_id           = var.txt_owner_id
    external_dns_role_name = var.external_dns_role_name
  }
}