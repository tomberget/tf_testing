resource "helm_release" "traefik" {
  name       = "traefik"
  namespace  = "kube-system"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "traefik"
  version    = "1.86.2"

  values = [
    data.template_file.traefik_config.rendered
  ]
}

data "template_file" "traefik_config" {
  template = file("${path.root}/config/traefik/config.yaml")

  vars = {
    traefik_ingress_dns = "atarifam.com"
  }
}