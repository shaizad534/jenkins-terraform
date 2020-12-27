# Outputs.tf
output "instance_id" {
  description = " Instance ID of the instance"
  value       = aws_instance.jenkins.id
}

output "instance_IP" {
  description = " Public IP of the instance"
  value       = aws_instance.jenkins.public_ip
}

