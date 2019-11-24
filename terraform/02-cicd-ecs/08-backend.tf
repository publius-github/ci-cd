resource "aws_ecs_service" "service_backend" {
  name            = "service_backend"
  cluster         = "${data.aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.task_simple_testing_capabilities_backend.arn}"
  desired_count   = "1"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.ecs_tasks.id}"]
    subnets         = "${aws_subnet.fargate_subnet_private.*.id}"
    assign_public_ip = "true"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.backend_target_group.id}"
    container_name   = "backend"
    container_port   = "${var.app_port_backend}"
  }

  depends_on = [
    "aws_alb_listener.listener_backend",
  ]
}

### ALB backend

resource "aws_alb" "alb_backend" {
  name            = "alb-backend"
  subnets         = "${aws_subnet.fargate_subnet_public.*.id}"
  security_groups = ["${aws_security_group.lb.id}"]
}

resource "aws_alb_target_group" "backend_target_group" {
  name        = "backend-target-group"
  port        = "${var.app_port_backend}"
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.fargate_vpc.id}"
  target_type = "ip"
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "listener_backend" {
  load_balancer_arn = "${aws_alb.alb_backend.id}"
  port              = "${var.app_port_backend}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.backend_target_group.id}"
    type             = "forward"
  }
}

output "alb_backend" {
  value = "${aws_alb.alb_backend.dns_name}"
}
