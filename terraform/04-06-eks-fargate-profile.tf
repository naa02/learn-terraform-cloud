resource "aws_eks_fargate_profile" "kube-system" {
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = "kube-system"
  pod_execution_role_arn = aws_iam_role.eks_fargate_profile_role.arn

  # These subnets must have the following resource tag: 
  # kubernetes.io/cluster/<CLUSTER_NAME>
  subnet_ids = module.vpc.private_subnets

  selector {
    namespace = "kube-system"
  }
}

resource "aws_eks_fargate_profile" "environment" {
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = local.name
  pod_execution_role_arn = aws_iam_role.eks_fargate_profile_role.arn

  # These subnets must have the following resource tag: 
  # kubernetes.io/cluster/<CLUSTER_NAME>
  subnet_ids = module.vpc.private_subnets

  selector {
    namespace = "${local.name}*"
  }
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks_cluster.id
}

resource "null_resource" "k8s_patcher" {
  depends_on = [aws_eks_fargate_profile.kube-system]

  triggers = {
    endpoint = aws_eks_cluster.eks_cluster.endpoint
    ca_crt   = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    token    = data.aws_eks_cluster_auth.eks.token
  }

  provisioner "local-exec" {
    command = "curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl"
  }

  provisioner "local-exec" {
    command = <<EOH
cat >/tmp/ca.crt <<EOF
${base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)}
EOF
./kubectl \
  --server="${aws_eks_cluster.eks_cluster.endpoint}" \
  --certificate_authority=/tmp/ca.crt \
  --token="${data.aws_eks_cluster_auth.eks.token}" \
  patch deployment coredns \
  -n kube-system --type json \
  -p='[{"op": "remove", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"}]'
EOH
  }

  lifecycle {
    ignore_changes = [triggers]
  }
}