data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "aws_opensearch" {
  statement {
    sid    = "AWSOpenSearchPermissions"
    effect = "Allow"

    actions = [
      "es:ESHttp*"
    ]

    resources = [
    "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.helm_config.opensearch_domain_name}/*"]
  }
}
