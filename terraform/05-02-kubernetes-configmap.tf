# Pull AWS Account ID
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

# Locals Block
locals {
  configmap_roles = [
    {
      rolearn = "${aws_iam_role.eks_fargate_profile_role.arn}"
      username = "system:node:{{SessionName}}"
      groups = ["system:bootstrappers", "system:nodes", "system:node-proxier"]
    },
    {
      rolearn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.master_role}"
      username = "${var.user_name}"
      groups = ["system:masters"]
    },
  ]
}

# Kubernetes Config Map
resource "kubernetes_config_map_v1" "aws_auth" {
  depends_on = [aws_eks_cluster.eks_cluster]
  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(local.configmap_roles)
  }
}