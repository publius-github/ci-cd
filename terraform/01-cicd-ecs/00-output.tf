output "alb_backend" {
  value = "${aws_alb.alb_backend.dns_name}"
}

output "alb_frontend" {
  value = "${aws_alb.alb_frontend.dns_name}"
}

output "alb_db" {
  value = "${aws_alb.alb_db.dns_name}"
}