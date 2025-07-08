# Terraform configuration for AWS Security Groups
# This file defines the security groups for Swiftlets EC2 deployment

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Variables
variable "vpc_id" {
  description = "VPC ID where the security groups will be created"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH into instances"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Change this to your IP for better security
}

# Security group for Swiftlets web server
resource "aws_security_group" "swiftlets_web" {
  name        = "swiftlets-web-sg"
  description = "Security group for Swiftlets web server"
  vpc_id      = var.vpc_id

  # HTTP access from anywhere
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access (restricted)
  ingress {
    description = "SSH from allowed IPs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "swiftlets-web-sg"
    Application = "Swiftlets"
    Environment = "production"
  }
}

# Security group for internal communication (if using multiple instances)
resource "aws_security_group" "swiftlets_internal" {
  name        = "swiftlets-internal-sg"
  description = "Security group for internal Swiftlets communication"
  vpc_id      = var.vpc_id

  # Allow communication between Swiftlets instances
  ingress {
    description     = "Internal HTTP"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.swiftlets_web.id]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "swiftlets-internal-sg"
    Application = "Swiftlets"
    Environment = "production"
  }
}

# Security group for database (if needed)
resource "aws_security_group" "swiftlets_db" {
  name        = "swiftlets-db-sg"
  description = "Security group for Swiftlets database"
  vpc_id      = var.vpc_id

  # PostgreSQL access from web servers only
  ingress {
    description     = "PostgreSQL from web servers"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.swiftlets_web.id]
  }

  # MySQL/MariaDB access from web servers only
  ingress {
    description     = "MySQL from web servers"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.swiftlets_web.id]
  }

  # No outbound traffic needed for DB
  egress {
    description = "Deny all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["127.0.0.1/32"]
  }

  tags = {
    Name        = "swiftlets-db-sg"
    Application = "Swiftlets"
    Environment = "production"
  }
}

# Outputs
output "web_security_group_id" {
  value       = aws_security_group.swiftlets_web.id
  description = "ID of the web security group"
}

output "internal_security_group_id" {
  value       = aws_security_group.swiftlets_internal.id
  description = "ID of the internal security group"
}

output "db_security_group_id" {
  value       = aws_security_group.swiftlets_db.id
  description = "ID of the database security group"
}