
locals {
  cluster_name = "${var.prefix}-cluster-spot-${var.environment}"
}

locals {
  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${data.aws_eks_cluster.cluster.endpoint}
    certificate-authority-data: ${data.aws_eks_cluster.cluster.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${local.cluster_name}""
KUBECONFIG
}
#locals {
#  config_map_aws_auth = <<CONFIGMAPAWSAUTH


#apiVersion: v1
#kind: ConfigMap
#metadata:
#  name: aws-auth
#  namespace: kube-system
#data:
#  mapRoles: |
#    - rolearn: ${aws_iam_role.default-node.arn}
#      username: system:node:{{EC2PrivateDNSName}}
#      groups:
#        - system:bootstrappers
#        - system:nodes
#CONFIGMAPAWSAUTH
#}