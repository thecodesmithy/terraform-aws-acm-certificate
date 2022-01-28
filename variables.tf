variable "route53_zone" {
  type        = string
  description = "The Route53 zone ID for storing DNS validation entries for this certificate"
}

variable "dns_record" {
  type        = string
  description = "The primary domain name for this certificate"
}
