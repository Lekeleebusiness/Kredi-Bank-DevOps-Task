variable "vpc_id" {
   description = "The id of the vpc is used here"
}

variable "cluster_sg_id" {
  description = "security group for the eks cluster"
}

variable "database_subnet_1_id" {
  description = "first database subnet"
}

variable "database_subnet_2_id" {
  description = "second database subnet"
}