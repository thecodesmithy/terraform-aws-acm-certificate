resource "aws_acm_certificate" "this" {
  domain_name       = var.dns_record
  validation_method = "DNS"
}

resource "aws_route53_record" "validation" {
  for_each = {
    for opt in aws_acm_certificate.this.domain_validation_options : opt.domain_name => {
      record_name  = opt.resource_record_name
      record_value = opt.resource_record_value
      record_type  = opt.resource_record_type
    }
  }

  allow_overwrite = true

  name    = each.value.record_name
  records = [each.value.record_value]
  type    = each.value.record_type
  ttl     = 60
  zone_id = var.route53_zone
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn = aws_acm_certificate.this.arn

  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
