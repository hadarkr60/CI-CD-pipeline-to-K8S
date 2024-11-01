output "vpc_id" {
  value = aws_vpc.dev_vpc.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gw.id
}

output "ssm_vpc_endpoint_id" {
  description = "ID of the VPC endpoint for SSM"
  value       = aws_vpc_endpoint.ssm_endpoint.id
}

output "ec2messages_vpc_endpoint_id" {
  description = "ID of the VPC endpoint for EC2 Messages"
  value       = aws_vpc_endpoint.ec2messages_endpoint.id
}

output "ssmmessages_vpc_endpoint_id" {
  description = "ID of the VPC endpoint for SSM Messages"
  value       = aws_vpc_endpoint.ssmmessages_endpoint.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private_rt.id
}

output "private_subnet_cidr" {
  description = "CIDR block of the private subnet"
  value       = var.private_subnet_cidr  
}

output "public_subnet_cidr_1" {
  description = "CIDR block of the first public subnet"
  value       = var.public_subnet_cidr_1  
}

output "public_subnet_cidr_2" {
  description = "CIDR block of the second public subnet"
  value       = var.public_subnet_cidr_2  
}
