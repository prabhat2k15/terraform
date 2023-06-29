terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.16"
    }
  }
  required_version = ">=1.2.0"
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "ec2_example" {

  ami                         = var.ami #"ami-007855ac798b5175e"
  instance_type               = var.instance_type
  # key_name                    = aws_key_pair.deployer.key_name
  key_name               = var.key_name
  vpc_security_group_ids      = ["${aws_security_group.sg.id}"] #[aws_security_group.main.id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true

  user_data = file("${var.user_data_file_name}")


  tags = {
    Name = "${terraform.workspace}-${var.instance_name}" #"app_server"
    Env  = var.env           #"dev"
    description = "Created by Terraform on ${timestamp()}"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCanjXVnNpNs8WouofxwjZtaZhc+fS/h9dvlqDw26PnFPTtF1f1SYyqcj5K2g48dYEc2dXd4wjCEEgYq9T9/yt/j8VSrmPEIt54maf8oJ2RyVk8WfGBrQsm5woFxeULl5Lpyk2o2fDX7zEGwcGXa9gbcmS7/k2hIdC5Rzo4R6jLxNL0NV/Mz7oLEY0DYIfcURH8lkQFCaFtmQLnsxCrnaUZr3pT6ioYKca/dL84tUJ12qLfDWA3Zt5MXqPfB+A3EmBYgVyM5scpLuMKIrjhWfA9A5hifkD3HBttYkh9NqSBBJEm7Q1FQExN1gj0b6FbnVi3HAEoKISDw0DpBO9U6tdfUCkOYqsaVcOSkvRKe5d0SAU1b57mXXUmdKsVD1VUzmPNBLwBL2X8bBBjpOre9ke2NE1SouLSCWtPtkhbiluKlb3h3w671AoB0+cjNEjgsYWP43daMHvuka3g+H1Tpv8kQ4lesNyIVIWuEOFvNqMTdrx6Dv+r1PomtHW+pj/neuE= prabhatkumar@Prabhats-MacBook-Air.local"
}


variable "access_key" {
  default     = ""
  description = "IAM access key"
  type        = string
}
variable "secret_key" {
  default     = ""
  description = "IAM secret_key"
  type        = string
}
variable "ami" {
  default     = "ami-007855ac798b5175e"
  description = "aws AMI id"
  type        = string
}
variable "instance_type" {
  default     = "t2.micro"
  description = ""
  type        = string
}
variable "subnet_id" {
  default     = ""
  description = ""
  type        = string
}
variable "user_data_file_name" {
  default     = "user_data.sh"
  description = ""
  type        = string
}
variable "instance_name" {
  default     = "App-server"
  description = ""
  type        = string
}
variable "env" {
  default     = "dev"
  description = ""
  type        = string
}
variable "vpc_id" {
  default     = ""
  description = ""
  type        = string
}
variable "key_name" {
  default     = "aws_key"
  description = ""
  type        = string
}
variable "public_key" {
  default     = ""
  description = ""
  type        = string
}
