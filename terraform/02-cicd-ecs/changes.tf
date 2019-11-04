# 08-frontend.tf
resource "aws_ecs_service" "service_frontend" {
  name            = "service_frontend"
  cluster         = "${data.aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.task_simple_testing_capabilities.arn}"
  desired_count   = "1"
  launch_type     = "FARGATE"
  network_configuration {
    security_groups = ["${aws_security_group.ecs_tasks.id}"]
    subnets         = ["${aws_subnet.fargate_subnet_private.*.id}"]
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
  subnets         = ["${aws_subnet.fargate_subnet_public.*.id}"]
  security_groups = ["${aws_security_group.lb.id}"]
}

resource "aws_alb_target_group" "frontend_target_group" {
  name        = "frontend-target-group"
  port        = "${var.app_port_frontend}"
  protocol    = "HTTP"
  vpc_id      = "${data.aws_vpc.main.id}"
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

output "alb_frontend" {
  value = "${aws_alb.alb_frontend.dns_name}"
}


# 04-security_groups.tf

resource "aws_security_group" "lb" {
  name        = "tf-ecs-alb"
  description = "controls access to the ALB"
  vpc_id      = "${data.aws_vpc.main.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 3000
    to_port     = 3000
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 50504
    to_port     = 50504
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 6379
    to_port     = 6379
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Traffic to the ECS Cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "tf-ecs-tasks"
  description = "allow inbound access from the ALB only"
  vpc_id      = "${data.aws_vpc.main.id}"

  ingress {
    protocol        = "tcp"
    from_port       = "50504"
    to_port         = "50504"
    security_groups = ["${aws_security_group.lb.id}"]
  }

  ingress {
    protocol        = "tcp"
    from_port       = "3000"
    to_port         = "3000"
    security_groups = ["${aws_security_group.lb.id}"]
  }

  ingress {
    protocol        = "tcp"
    from_port       = "6379"
    to_port         = "6379"
    security_groups = ["${aws_security_group.lb.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# 03-network.tf

data "aws_availability_zones" "available" {}

# resource "aws_vpc" "fargate_vpc" {
#   cidr_block           = "172.17.0.0/16"
#   instance_tenancy     = "default"
#   enable_dns_hostnames = "true"
#   enable_dns_support   = "true"

#   tags = {
#     Name = "fargate_vpc"
#   }
# }

data "aws_vpc" "main" {
  id = "vpc-08811fe72a777ecf0"
  cidr_block = "10.0.0.0/16"
}

# Create var.az_count private subnets, each in a different AZ
resource "aws_subnet" "fargate_subnet_private" {
  count             = "${var.az_count}"
  cidr_block        = "${cidrsubnet(data.aws_vpc.main.cidr_block, 10, count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id            = "${data.aws_vpc.main.id}"

  tags = {
    Name = "fargate_subnet_private"
  }
}

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "fargate_subnet_public" {
  count                   = "${var.az_count}"
  cidr_block              = "${cidrsubnet(data.aws_vpc.main.cidr_block, 10, var.az_count + count.index)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id                  = "${data.aws_vpc.main.id}"
  map_public_ip_on_launch = true

  tags = {
    Name = "fargate_subnet_public"
  }
}

# IGW for the public subnet
# resource "aws_internet_gateway" "gw" {
#   vpc_id = "${data.aws_vpc.main.id}"
# }

data "aws_internet_gateway" "default" {
  tags = {
    Name = "main"
  }
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = "${data.aws_vpc.main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${data.aws_internet_gateway.default.id}"
}

# Create a NAT gateway with an EIP for each private subnet to get internet connectivity
resource "aws_eip" "gw" {
  count      = "${var.az_count}"
  vpc        = true
}

resource "aws_nat_gateway" "gw" {
  count         = "${var.az_count}"
  subnet_id     = "${element(aws_subnet.fargate_subnet_public.*.id, count.index)}"
  allocation_id = "${element(aws_eip.gw.*.id, count.index)}"
}

# Create a new route table for the private subnets
# And make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  count  = "${var.az_count}"
  vpc_id = "${data.aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.gw.*.id, count.index)}"
  }
}

# Explicitely associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
  count          = "${var.az_count}"
  subnet_id      = "${element(aws_subnet.fargate_subnet_private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}


# route 53

