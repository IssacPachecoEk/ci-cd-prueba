# crea la zona de la ruta
resource "aws_route53_zone" "route53_zone" {
  name = var.domain_name
  tags = {
    Name = var.domain_name
  }
}
# recurso princiap para la DNS y su asociación con el ALB y el certificado
resource "aws_route53_record" "main" {
  zone_id    = aws_route53_zone.route53_zone.zone_id
  name       = "${var.subdomain_name}.${var.domain_name}"
  type       = var.record_type
  ttl        = var.ttl_time
  records    = [module.cloudfront.cloudfront_distribution_domain_name]
  depends_on = [module.cloudfront.main]
}
# se valida el certificado por dns
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Environment = var.env_name
  }
}
# crear atachar el certificado a la DNS para validacion
resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_type
  zone_id = aws_route53_zone.main.zone_id
  records = [aws_acm_certificate.cert.domain_validation_options[0].resource_record_value]
  ttl     = var.ttl_time
}
# se crea el registro de la DNS para el api gateway
resource "aws_route53_record" "custom_domain" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.custom_domain.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.custom_domain.cloudfront_zone_id
    evaluate_target_health = false
  }
}

