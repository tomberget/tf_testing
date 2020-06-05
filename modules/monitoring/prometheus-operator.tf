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
    domain_name                  = var.domain_name
    org_name                     = var.org_name
    alertmanager_tls_secret_name = "alertmanager-${replace("${var.domain_name}", ".", "-")}-tls"
    grafana_tls_secret_name      = "grafana-${replace("${var.domain_name}", ".", "-")}-tls"
    prometheus_tls_secret_name   = "prometheus-${replace("${var.domain_name}", ".", "-")}-tls"
    grafana_pwd                  = var.grafana_pwd
  }
}

resource "kubernetes_config_map" "grafana_dashboards" {
  metadata {
    name      = "grafana-dashboards"
    namespace = kubernetes_namespace.prometheus.metadata[0].name

    labels = {
      grafana_dashboard = "1"
    }
  }

  data = {
    "kubernetes-cluster_rev1.json" = file("${path.root}/config/grafana/dashboards/kubernetes-cluster_rev1.json")
  }
}