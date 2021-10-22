resource "aws_acm_certificate" "main" {
  domain_name = "*.${var.domain_name}"
  # domain_name       = var.domain_name
  validation_method = var.validation_method

  tags = merge(local.tags, { Name = replace(local.name, "rtype", "acm") })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "www_dns" {
  zone_id         = var.zone_id
  name            = "www.${var.domain_name}"
  type            = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
  depends_on = [aws_acm_certificate.main]
}

resource "aws_route53_record" "dns_validation" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = var.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_acm_certificate_validation" "dns_validation" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [ for record in aws_route53_record.dns_validation : record.fqdn]
}