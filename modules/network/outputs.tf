output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPCのID"
}

output "public_subnet_id" {
  value       = aws_subnet.public_1a.id
  description = "パブリックサブネットのID"
}

output "private_1a_subnet_id" {
  value       = aws_subnet.private_1a.id
  description = "プライベートサブネット(1a)のID"
}

output "private_1c_subnet_id" {
  value       = aws_subnet.private_1c.id
  description = "プライベートサブネット(1c)のID"
}
