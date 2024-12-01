variable "pj_name" {
  type        = string
  description = "PJ名"
}

variable "vpc_id" {
  type        = string
  description = "VPCのID"
}

variable "private_1a_subnet_id" {
  type        = string
  description = "プライベートサブネット(1a)のID"
}

variable "private_1c_subnet_id" {
  type        = string
  description = "プライベートサブネット(1c)のID"
}

variable "security_group_ingress_rules" {
  type = object({
    referenced_security_group_id = string
    from_port                    = string
    to_port                      = string
  })
  description = "セキュリティグループのインバウンドルール"
}

variable "rds_username" {
  description = "RDSのユーザー名"
  type        = string
}

variable "rds_password" {
  description = "RDSのパスワード"
  type        = string
  sensitive   = true
}
