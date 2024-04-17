variable "vpc_cidr_block" {
  description = "cidr block for vpc"
}

variable "public_1_cidr_block" {
  description = "cidr block for first public subnet"
}

variable "public_2_cidr_block" {
  description = "cidr block for second public subnet"
}

variable "private_1_cidr_block" {
  description = "cidr block for first private subnet "
}

variable "private_2_cidr_block" {
  description = "cidr block for second private subnet"
}

variable "database_cidr_block_1" {
   description = "cidr block for first database subnet"
}

variable "database_cidr_block_2" {
  description = "cidr block for second database subnet"
}
