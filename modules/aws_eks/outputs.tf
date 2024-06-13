output "endpoint" {
  value = aws_eks_cluster.clusterx.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.clusterx.certificate_authority[0].data
}

