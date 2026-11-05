output "primary_vpc_id" {
  value = aws_vpc.primary.id 
}

output "secondary_vpc_id" {
  value = aws_vpc.secondary.id
}

output "vpc_peering_connection_id" {
  value = aws_vpc_peering_connection.primary_secondary.id
}

output "primary_instance_public_ip" {
  value = aws_instance.primary.public_ip
}

output "secondary_instance_public_ip" {
  value = aws_instance.secondary.public_ip
}

output "primary_instance_private_ip" {
  value = aws_instance.primary.private_ip
}

output "secondary_instance_private_ip" {
  value = aws_instance.secondary.private_ip
}
