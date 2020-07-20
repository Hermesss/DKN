output "proxy1_ip_addr" {
  value = aws_instance.dockerweb[0].public_ip
}
output "proxy2_ip_addr" {
  value = aws_instance.dockerweb[1].public_ip
}