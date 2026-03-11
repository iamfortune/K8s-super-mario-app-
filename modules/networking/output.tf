output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.mario_vpc.id
}

output "eip" {
  description = "Elastic IP of the nat gateway"
  value       = aws_eip.mario_nat_eip.address
}

output "private_subnet_id" {
  description = "The private subnet id"
  value       = aws_subnet.mario_private_subnet[*].id
}

output "public_subnet_id" {
  description = "The public subnet id"
  value       = aws_subnet.mario_public_subnet[*].id
}

