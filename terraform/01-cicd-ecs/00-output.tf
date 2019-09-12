output "alb_hostname" {
  value = "${aws_alb.alb_backend.dns_name}"
}

output "alb_hostname" {
  value = "${aws_alb.alb_frontend.dns_name}"
}

output "alb_hostname" {
  value = "${aws_alb.alb_db.dns_name}"
}