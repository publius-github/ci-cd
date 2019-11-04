resource "aws_ecs_service" "service_db" {
  name            = "service_db"
  cluster         = "${data.aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.task_simple_testing_capabilities.arn}"
  desired_count   = "1"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.ecs_tasks.id}"]
    subnets         = ["${aws_subnet.fargate_subnet_private.*.id}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.db_target_group.id}"
    container_name   = "db"
    container_port   = "${var.app_port_db}"
  }

  depends_on = [
    "aws_alb_listener.listener_db",
  ]
}

### ALB db

resource "aws_alb" "alb_db" {
  name            = "alb-db"
  subnets         = ["${aws_subnet.fargate_subnet_public.*.id}"]
  security_groups = ["${aws_security_group.lb.id}"]
}

resource "aws_alb_target_group" "db_target_group" {
  name        = "db-target-group"
  port        = "${var.app_port_db}"
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.fargate_vpc.id}"
  target_type = "ip"
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "listener_db" {
  load_balancer_arn = "${aws_alb.alb_db.id}"
  port              = "${var.app_port_db}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.db_target_group.id}"
    type             = "forward"
  }
}

output "alb_db" {
  value = "${aws_alb.alb_db.dns_name}"
}
