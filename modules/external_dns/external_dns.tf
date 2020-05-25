##https://github.com/bitnami/charts/tree/master/bitnami/external-dns/#installing-the-chart
#resource "kubernetes_service_account" "external-dns" {
#  metadata {
#    name = "external-dns"
#    namespace = kubernetes_namespace.external_dns.metadata.0.name
#  }
#  secret {
#    name = kubernetes_secret.external-dns.metadata.0.name
#  }
#}

#resource "kubernetes_secret" "external-dns" {
#  metadata {
#    name = "external-dns"
#    namespace = kubernetes_namespace.external_dns.metadata.0.name
#  }
#}

resource "kubernetes_namespace" "external_dns" {
  metadata {
    annotations = {
      name = var.external_dns_namespace
    }

    #labels = {
    #  "istio-injection"    = "disabled"
    #  "kiali.io/member-of" = "istio-system"
    #}

    name = var.external_dns_namespace
  }
}

resource "helm_release" "external_dns" {
  count = var.external_dns_enabled ? 1 : 0

  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = var.external_dns_chart_version
  namespace  = kubernetes_namespace.external_dns.metadata[0].name
  timeout    = 600

  set {
    name  = "policy"
    value = "upsert-only"
  }

  set {
    name  = "sources"
    value = "{ingress,service,istio-gateway}"
  }

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name = "aws.region"
    value = var.external_dns_region
  }

  set {
    name  = "aws.assumeRoleArn"
    value = "arn:aws:iam::${var.account_id}:role/UpdateExternalDNS"
  }
}