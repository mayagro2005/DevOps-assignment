output "app_url" {
  value = "http://${aws_instance.app.public_ip}:8080"
  description = "Public IP of the EC2 instance"
}

