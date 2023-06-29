variable "env" {
  type        = string
  description = "production environment"
  default     = "prod"
}
variable "region" {
  type        = string
  description = "aws region"
  default     = "us-east-1"
}
variable "vpc_id" {
  type    = string
  default = ""
}
variable "cluster_name" {
  type    = string
  default = "prod"
}
variable "cluster_version" {
  type    = string
  default = "1.26"
}
variable "cidr_block" {
  type        = string
  description = "CIDR of VPC"
  default     = "11.0.0.0/16"
}
variable "public_subnets_ids" {
  type        = list(string)
  description = "Public Subnet ids"
  default     = []
}

variable "private_subnets_ids" {
  type        = list(string)
  description = "Private Subnet ids"
  default     = []
}

# variable "azs" {
#   type        = list(string)
#   description = "Availability Zones"
#   default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
# }
variable "disk_size" {
  type    = number
  default = 500
}
