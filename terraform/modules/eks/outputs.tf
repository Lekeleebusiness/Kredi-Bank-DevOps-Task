output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_sg_id" {
  value = [aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id]
}

output "cluster_autoscaler_iam_role_arn" {
  description = "Cluster Autoscaler IAM Role ARN"
  value = aws_iam_role.cluster_autoscaler_iam_role.arn
}