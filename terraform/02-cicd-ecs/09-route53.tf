resource "aws_route53_zone" "private" {
  name = "example.com"

  vpc {
    vpc_id = "${data.aws_vpc.main.id}"
  }
}

resource "aws_route53_record" "frontend" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "frontend.example.com"
  type    = "A"

  alias {
    name                   = "${aws_alb.alb_frontend.dns_name}"
    zone_id                = "${aws_alb.alb_frontend.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "backend" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "backend.example.com"
  type    = "A"

  alias {
    name                   = "${aws_alb.alb_backend.dns_name}"
    zone_id                = "${aws_alb.alb_backend.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "db" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "db.example.com"
  type    = "A"

  alias {
    name                   = "${aws_alb.alb_db.dns_name}"
    zone_id                = "${aws_alb.alb_db.zone_id}"
    evaluate_target_health = true
  }
}