output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.mario_vpc.id
}

output "eip" {
  description = "Elastic IP of the nat gateway"
  value       = aws_eip.mario_nat_eip.address
}
