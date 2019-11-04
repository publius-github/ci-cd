
resource "aws_route53_zone" "primary" {
  name = "simple-testing-capabilities.co.uk."
}

resource "aws_route53_record" "frontend" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "frontend.simple-testing-capabilities.co.uk"
  type    = "A"

  alias {
    name                   = "${aws_alb.alb_frontend.dns_name}"
    zone_id                = "${aws_alb.alb_frontend.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "backend" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "backend.simple-testing-capabilities.co.uk"
  type    = "A"

  alias {
    name                   = "${aws_alb.alb_backend.dns_name}"
    zone_id                = "${aws_alb.alb_backend.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "db" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "db.simple-testing-capabilities.co.uk"
  type    = "A"

  alias {
    name                   = "${aws_alb.alb_db.dns_name}"
    zone_id                = "${aws_alb.alb_db.zone_id}"
    evaluate_target_health = true
  }
}