variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type for the Kubernetes node"
  type        = string
  default     = "t2.micro" # Free tier eligible
}

variable "key_name" {
  description = "Name of the SSH key pair to access the instance"
  type        = string
  default     = "sock-shop-key"
}
