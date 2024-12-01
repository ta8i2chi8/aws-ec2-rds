variable "pj_name" {
  type        = string
  description = "PJ名"
}

variable "vpc_cidr" {
  type        = string
  description = "VPCのCIDR"
}

variable "public_subnet_cidr" {
  type        = string
  description = "パブリックサブネットのCIDR"
}

variable "private_1a_subnet_cidr" {
  type        = string
  description = "プライベートサブネット(1a)のCIDR"
}

variable "private_1c_subnet_cidr" {
  type        = string
  description = "プライベートサブネット(1c)のCIDR"
}
