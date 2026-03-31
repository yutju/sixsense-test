# dns.tf

# 1. 정식 인증서 발급
resource "aws_acm_certificate" "cert" {
  domain_name       = "sixsense.kro.kr"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# 2. 인증서 발급 완료될 때까지 테라폼 대기시키기
resource "aws_acm_certificate_validation" "cert_val" {
  certificate_arn = aws_acm_certificate.cert.arn
}