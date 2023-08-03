module "helm_addon" {
  source            = "../helm-addon"
  manage_via_gitops = var.manage_via_gitops
  helm_config       = local.helm_config
  addon_context     = var.addon_context
  irsa_config       = local.irsa_config
}

resource "aws_iam_policy" "aws_opensearch" {
  name        = "${var.addon_context.eks_cluster_id}-aws-opensearch-irsa"
  description = "IAM Policy for AWS OpenSearch"
  policy      = data.aws_iam_policy_document.aws_opensearch.json
  tags        = var.addon_context.tags
}
