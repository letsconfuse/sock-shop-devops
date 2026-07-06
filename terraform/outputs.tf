output "instance_public_ip" {
  description = "Public IP address of the Kubernetes node"
  value       = aws_instance.k8s_node.public_ip
}

output "instance_id" {
  description = "ID of the Kubernetes node"
  value       = aws_instance.k8s_node.id
}
