provider "aws" {
  region  = "eu-north-1"
  version = ">= 2.38.0"
}

provider "random" {
  version = "~> 2.1"
}

provider "local" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 2.1"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  #client_key = base64decode(azurerm_kubernetes_cluster.example.kube_config.0.client_key)
  #client_certificate = base64decode(azurerm_kubernetes_cluster.example.kube_config.0.client_certificate)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}

#provider "helm" {
#  kubernetes {
#    load_config_file       = "false"
#    host                   = azurerm_kubernetes_cluster.example.kube_config.0.host
#    client_certificate     = base64decode(azurerm_kubernetes_cluster.example.kube_config.0.client_certificate)
#    client_key             = base64decode(azurerm_kubernetes_cluster.example.kube_config.0.client_key)
#    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.example.kube_config.0.cluster_ca_certificate)
#    /*     host     = "https://104.196.242.174"
#    username = "ClusterMaster"
#    password = "MindTheGap"
#    client_certificate     = file("~/.kube/client-cert.pem")
#    client_key             = file("~/.kube/client-key.pem")
#    cluster_ca_certificate = file("~/.kube/cluster-ca-cert.pem") */
#  }
#}