resource "aws_ecs_service" "service_frontend" {
  name            = "service_frontend"
  cluster         = "${data.aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.task_simple_testing_capabilities_frontend.arn}"
  desired_count   = "1"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.ecs_tasks.id}"]
    subnets         = "${aws_subnet.fargate_subnet_private.*.id}"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.frontend_target_group.id}"
    container_name   = "frontend"
    container_port   = "${var.app_port_frontend}"
  }

  depends_on = [
    "aws_alb_listener.listener_frontend",
  ]
}

### ALB FRONTEND

resource "aws_alb" "alb_frontend" {
  name            = "alb-frontend"
  subnets         = "${aws_subnet.fargate_subnet_public.*.id}"
  security_groups = ["${aws_security_group.lb.id}"]
}

resource "aws_alb_target_group" "frontend_target_group" {
  name        = "frontend-target-group"
  port        = "${var.app_port_frontend}"
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.fargate_vpc.id}"
  target_type = "ip"
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "listener_frontend" {
  load_balancer_arn = "${aws_alb.alb_frontend.id}"
  port              = "${var.app_port_frontend}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.frontend_target_group.id}"
    type             = "forward"
  }
}

output "dns_frontend" {
  value = "${aws_route53_record.frontend.name}"
}
