variable "cluster_name" {
  description = "The name of the EKS Cluster"
  default = "kredi-cluster"
}

variable "cluster_version" {
  description = "The version for the EKS Cluster"
}

variable "cluster_service_ipv4_cidr" {
  description = "service ipv4 cidr for the kubernetes cluster"
  default = "172.20.0.0/16"
}

variable "private_subnet_1_id" {
  description = "first private subnet of vpc"
}

variable "private_subnet_2_id" {
  description = "second private subnet of vpc"
}


