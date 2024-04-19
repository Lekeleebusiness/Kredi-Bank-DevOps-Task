# create security group for the database
resource "aws_security_group" "database_security_group" {
  name        = "database security group"
  description = "enable mysql access on port 3306"
  vpc_id      = var.vpc_id

  ingress {
    description      = "mysql access"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = var.cluster_sg_id  
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "kredi-prod-database-sg"
  }
}


# create the subnet group for the rds instance
resource "aws_db_subnet_group" "database_subnet_group" {
  name         = "kredi-prod-database-subnets"
  subnet_ids   = [var.database_subnet_1_id, var.database_subnet_2_id]
  description  = "subnets for database instance"

  tags   = {
    Name = "kredi-prod-database-subnets"
  }
}


# create the rds instance
resource "aws_db_instance" "db_instance" {
  engine                  = "mysql"
  engine_version          = "8.0.31"
  multi_az                = false
  identifier              = "kredi-prod-rds-instance"
  username                = local.db_creds.DATABASE_USER_NAME
  password                = local.db_creds.DATABASE_USER_PASSWORD
  instance_class          = "db.t3.micro"
  allocated_storage       = 200
  db_subnet_group_name    = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.database_security_group.id]
  db_name                 = "users"
  skip_final_snapshot     = true
}

data "aws_secretsmanager_secret_version" "cred" {
  secret_id = "db_credentials"
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.cred.secret_string)
}