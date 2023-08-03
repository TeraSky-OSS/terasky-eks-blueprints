locals {
  name = "aws-for-fluent-bit"
  argocd_gitops_config = {
    enable             = true
    serviceAccountName = local.name
  }

  helm_config = merge(
    {
      name            = local.name
      chart           = local.name
      repository      = "https://aws.github.io/eks-charts"
      version         = "0.1.24"
      namespace       = "logging"
      description     = "Fluent Bit Helm Chart deployment configuration"
      service_account = local.name
      #      create_service_account_secret_token = true

      values = [templatefile("${path.module}/values.yaml", {
        service_account_name = local.name
        opensearch_endpoint  = var.helm_config.opensearch_endpoint
        aws_region           = data.aws_region.current.name
        opensearch_index     = try(var.helm_config.opensearch_index, "aws-fluent-bit")
      })]
    },
    var.helm_config
  )

  irsa_config = {
    kubernetes_namespace                = local.helm_config["namespace"]
    kubernetes_service_account          = local.name
    create_kubernetes_namespace         = try(local.helm_config["create_namespace"], true)
    create_kubernetes_service_account   = true
    create_service_account_secret_token = try(local.helm_config["create_service_account_secret_token"], false)
    irsa_iam_policies                   = [aws_iam_policy.aws_opensearch.arn]
  }
}