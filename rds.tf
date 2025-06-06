terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

########################
# Variables
########################

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-2"
}

variable "vpc_id" {
  description = "EKS VPC ID HERE"
  type        = string
}

variable "private_subnet_ids" {
  description = "EKS PRIVATE SUBNET ID HERE"
  type        = list(string)
}

variable "eks_security_group_ids" {
  description = "Security group IDs (EKS nodes, control plane)"
  type        = list(string)
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "demoapp"
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
  default     = "demouser"
}

variable "db_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}

########################
# RDS Subnet Group
########################

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "demo-rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "Demo RDS Subnet Group"
  }
}

########################
# RDS Security Group
########################

resource "aws_security_group" "rds_sg" {
  name        = "demo-rds-sg"
  description = "Allow EKS nodes to access RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.eks_security_group_ids
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow EKS to RDS - Demo"
  }
}

########################
# RDS Instance
########################

resource "aws_db_instance" "postgres" {
  identifier                  = "demo-postgres-db"
  engine                      = "postgres"
  engine_version              = "15.13"
  instance_class              = "db.t3.small"  # Performance/cost balance
  allocated_storage           = 20
  db_name                     = var.db_name
  username                    = var.db_username
  password                    = var.db_password
  db_subnet_group_name        = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids      = [aws_security_group.rds_sg.id]
  skip_final_snapshot         = true
  publicly_accessible         = false
  multi_az                    = false
  auto_minor_version_upgrade  = true
  backup_retention_period     = 1

  tags = {
    Name = "Demo Ecom RDS"
  }
}
