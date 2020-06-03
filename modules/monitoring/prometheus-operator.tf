resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = "monitoring"

    #labels = {
    #  "istio-injection"    = "disabled"
    #  "kiali.io/member-of" = "istio-system"
    #}
  }
}

resource "helm_release" "prometheus-operator" {
  name       = "prometheus-operator"
  namespace  = kubernetes_namespace.prometheus.metadata[0].name
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "prometheus-operator"
  version    = "8.13.8"

  values = [
    data.template_file.prometheus_operator_config.rendered
  ]
}

data "template_file" "prometheus_operator_config" {
  template = file("${path.root}/config/prometheus-operator/config.yaml")

  vars = {
    domain_name = var.domain_name
    org_name    = var.org_name
  }
}