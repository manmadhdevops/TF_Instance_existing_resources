output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.My_Instance.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.My_Instance.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.My_Instance.private_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.My_Instance.public_dns
}

output "instance_state" {
  description = "State of the EC2 instance"
  value       = aws_instance.My_Instance.instance_state
}

output "vpc_id" {
  description = "ID of the VPC where instance is deployed"
  value       = data.aws_vpc.selected.id
}

output "subnet_id" {
  description = "ID of the subnet where instance is deployed"
  value       = data.aws_subnet.selected.id
}

output "security_group_ids" {
  description = "List of attached security group IDs"
  value       = aws_instance.My_Instance.vpc_security_group_ids
}

output "arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.My_Instance.arn
}