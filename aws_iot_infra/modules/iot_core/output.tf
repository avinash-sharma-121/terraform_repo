output "certificate_pem" {
  value = aws_iot_certificate.cert.certificate_pem
  sensitive = true
}