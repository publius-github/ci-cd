output "alb_hostname" {
  value = "${aws_alb.main.dns_name}"
}

output "ecr" {
  value = "${aws_alb.main.dns_name}"
}
