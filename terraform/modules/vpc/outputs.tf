output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_1" {
  value = aws_subnet.public_1.id
}

output "public_subnet_2" {
  value = aws_subnet.public_2.id
}

output "private_subnet_1" {
  value = aws_subnet.private_1.id
}

output "private_subnet_2" {
  value = aws_subnet.private_2.id
}

output "database_subnet_1" {
  value = aws_subnet.database_1.id
}

output "database_subnet_2" {
  value = aws_subnet.database_2.id
}


