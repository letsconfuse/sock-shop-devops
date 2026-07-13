output "instance_public_ip" {
  description = "Public IP address of the Kubernetes node"
  value       = aws_eip.k8s_node.public_ip
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.k8s_node.id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.sock_shop.id
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.k8s_node_sg.id
}
