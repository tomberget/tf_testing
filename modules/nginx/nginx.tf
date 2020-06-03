resource "helm_release" "nginx" {
  name       = "nginx"
  namespace  = "kube-system"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "nginx-ingress"
  version    = "1.39.0"

  values = [
    data.template_file.nginx_config.rendered
  ]
}

data "template_file" "nginx_config" {
  template = file("${path.root}/config/nginx/config.yaml")

  vars = {
    domain_name = var.domain_name
  }
}