resource "aws_iam_openid_connect_provider" "default" {
  url = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = []

  depends_on = [data.aws_eks_cluster.cluster]
}

resource "aws_iam_policy" "AllowExternalDNSUpdates" {
  name        = "AllowExternalDNSUpdates"
  path        = "/"
  description = "Allow External DNS to update Route53 records"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZones",
                "route53:ListResourceRecordSets"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "ExternalDNS" {
  name = var.external_dns_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${aws_iam_openid_connect_provider.default.arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${replace(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")}:sub": "system:serviceaccount:external-dns:external-dns"
        }
      }
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.external_dns_role_name}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  depends_on = [aws_iam_openid_connect_provider.default, aws_iam_policy.AllowExternalDNSUpdates]
}