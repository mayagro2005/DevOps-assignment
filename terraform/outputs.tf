output "app_url" {
  value = "http://${aws_instance.app.public_ip}:8080"
}
