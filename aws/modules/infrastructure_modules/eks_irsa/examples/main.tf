variable "aws_account_id" {
  type    = string
  default = "640853641954"
}

data "aws_iam_policy_document" "external_dns" {
  statement {
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]

    resources = [
      "*",
    ]
  }
}

module "external_dns_irsa_iam_role" {
  source = "../"

  cluster_name            = "foo"
  cluster_oidc_issuer_url = "https://foo.com"
  aws_account_id          = var.aws_account_id
  namespace               = "foo-ns"
  service_account_name    = "foo-sa"
  resource_description    = "for external-dns to list zones and records and update the records"
  policy                  = data.aws_iam_policy_document.external_dns.json
}
