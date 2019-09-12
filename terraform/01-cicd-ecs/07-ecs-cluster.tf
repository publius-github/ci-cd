data "aws_ecs_cluster" "main" {
  cluster_name = "tf-ecs-cluster"
}

resource "aws_ecs_task_definition" "task_backend" {
  family                   = "task_backend"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "${aws_iam_role.fargate-ecr-role.arn}"

  container_definitions = <<DEFINITION
[
  {
    "cpu": "1024"},
    "image": "${var.app_image_backend}",
    "memory": ${var.fargate_memory},
    "name": "backend",
    "networkMode": "host",
    "portMappings": [
      {
        "containerPort": ${var.app_port_backend},
        "hostPort": ${var.app_port_backend}
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "service_backend" {
  name            = "service_backend"
  cluster         = "${data.aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.task_backend.arn}"
  desired_count   = "1"
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.backend_target_group.id}"
    container_name   = "backend"
    container_port   = "${var.app_port_backend}"
  }

  depends_on = [
    "aws_alb_listener.listener_backend",
  ]
}

resource "aws_ecs_task_definition" "task_frontend" {
  family                   = "task_frontend"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "${aws_iam_role.fargate-ecr-role.arn}"

  container_definitions = <<DEFINITION
[
  {
    "cpu": "1024"},
    "image": "${var.app_image_frontend}",
    "memory": ${var.fargate_memory},
    "name": "frontend",
    "networkMode": "host",
    "portMappings": [
      {
        "containerPort": ${var.app_port_frontend},
        "hostPort": ${var.app_port_frontend}
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "service_frontend" {
  name            = "service_frontend"
  cluster         = "${data.aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.task_frontend.arn}"
  desired_count   = "1"
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.frontend_target_group.id}"
    container_name   = "frontend"
    container_port   = "${var.app_port_frontend}"
  }

  depends_on = [
    "aws_alb_listener.listener_frontend",
  ]
}

resource "aws_ecs_task_definition" "task_db" {
  family                   = "task_db"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "${aws_iam_role.fargate-ecr-role.arn}"

  container_definitions = <<DEFINITION
[
  {
    "cpu": "1024"},
    "image": "${var.app_image_db}",
    "memory": ${var.fargate_memory},
    "name": "db",
    "networkMode": "host",
    "portMappings": [
      {
        "containerPort": ${var.app_port_db},
        "hostPort": ${var.app_port_db}
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "service_db" {
  name            = "service_db"
  cluster         = "${data.aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.task_db.arn}"
  desired_count   = "1"
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.db_target_group.id}"
    container_name   = "db"
    container_port   = "${var.app_port_db}"
  }

  depends_on = [
    "aws_alb_listener.listener_db",
  ]
}
