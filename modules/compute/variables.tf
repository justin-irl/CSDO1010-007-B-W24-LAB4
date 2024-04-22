#-----compute/variables.tf-----
#===============================
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ssh_key_public" {
  type    = string
  default = "/Users/replicamask/.ssh/id_rsa.pub"
}

variable "ssh_key_private" {
  type    = string
  default = "/Users/replicamask/.ssh/id_rsa"
}

variable "security_group" {
  type        = string
  description = "ID of the security group"
}

variable "subnets" {
  type        = string
  description = "List of subnet IDs"
}
