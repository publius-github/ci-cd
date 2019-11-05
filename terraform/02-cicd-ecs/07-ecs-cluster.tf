data "aws_ecs_cluster" "main" {
  cluster_name = "simple-testing-capabilities"
}

resource "aws_ecs_task_definition" "task_simple_testing_capabilities_backend" {
  family                   = "task-simple-testing-capabilities-backend"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "${aws_iam_role.fargate-ecr-role.arn}"
  network_mode             = "awsvpc"
  cpu                      = "2048"
  memory                   = "4096"
  
  container_definitions = <<DEFINITION
[
  {
    "image": "${var.app_image_backend}",
    "name": "backend",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "ecs-log-streaming",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "fargate-task-1"
      }
    },
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

resource "aws_ecs_task_definition" "task_simple_testing_capabilities_frontend" {
  family                   = "task-simple-testing-capabilities"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "${aws_iam_role.fargate-ecr-role.arn}"
  network_mode             = "awsvpc"
  cpu                      = "2048"
  memory                   = "4096"
  
  container_definitions = <<DEFINITION
[
  {
    "image": "${var.app_image_frontend}",
    "name": "frontend",
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

resource "aws_ecs_task_definition" "task_simple_testing_capabilities_db" {
  family                   = "task-simple-testing-capabilities-db"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "${aws_iam_role.fargate-ecr-role.arn}"
  network_mode             = "awsvpc"
  cpu                      = "2048"
  memory                   = "4096"
  
  container_definitions = <<DEFINITION
[
  {
    "image": "${var.app_image_db}",
    "name": "db",
    "environment": [
      {
      "name": "ALLOW_EMPTY_PASSWORD",
      "value": "yes"
      }
    ],
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
