### ALB BACKEND

resource "aws_alb" "alb_backend" {
  name            = "alb-backend"
  subnets         = ["${aws_subnet.fargate_subnet_public.*.id}"]
  security_groups = ["${aws_security_group.lb.id}"]
}

resource "aws_alb_target_group" "backend_target_group" {
  name        = "backend-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.fargate_vpc.id}"
  target_type = "ip"
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "listener_backend" {
  load_balancer_arn = "${aws_alb.alb_backend.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.backend_target_group.id}"
    type             = "forward"
  }
}

### ALB DB 

resource "aws_alb" "alb_db" {
  name            = "alb-db"
  subnets         = ["${aws_subnet.fargate_subnet_public.*.id}"]
  security_groups = ["${aws_security_group.lb.id}"]
}

resource "aws_alb_target_group" "db_target_group" {
  name        = "db-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.fargate_vpc.id}"
  target_type = "ip"
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "listener_db" {
  load_balancer_arn = "${aws_alb.alb_db.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.db_target_group.id}"
    type             = "forward"
  }
}

### ALB FRONTEND

resource "aws_alb" "alb_frontend" {
  name            = "alb-frontend"
  subnets         = ["${aws_subnet.fargate_subnet_public.*.id}"]
  security_groups = ["${aws_security_group.lb.id}"]
}

resource "aws_alb_target_group" "frontend_target_group" {
  name        = "frontend-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.fargate_vpc.id}"
  target_type = "ip"
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "listener_frontend" {
  load_balancer_arn = "${aws_alb.alb_frontend.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.frontend_target_group.id}"
    type             = "forward"
  }
}
