data "aws_ecs_cluster" "main" {
  cluster_name = "simple-testing-capabilities"
}

resource "aws_ecs_task_definition" "task_simple_testing_capabilities" {
  family                   = "task-simple-testing-capabilities"
  # requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "${aws_iam_role.fargate-ecr-role.arn}"
  # network_mode             = "awsvpc"
  network_mode             = "bridge"
  cpu                      = "2048"
  memory                   = "4096"
  
  container_definitions = <<DEFINITION
[
  {
    "image": "${var.app_image_backend}",
    "name": "backend",
    "links": [
      "db"
    ],
    "portMappings": [
      {
        "containerPort": ${var.app_port_backend},
        "hostPort": ${var.app_port_backend}
      }
    ]
  },
  {
    "image": "${var.app_image_db}",
    "name": "db",
    "portMappings": [
      {
        "containerPort": ${var.app_port_db},
        "hostPort": ${var.app_port_db}
      }
    ]
  },
  {
    "image": "${var.app_image_frontend}",
    "name": "frontend",
    "links": [
      "backend"
    ],
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
