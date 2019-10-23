resource "aws_security_group" "jenkins" {
  name        = "jenkins"
  description = "Allow inbound traffic for jenkins"
  vpc_id      = "${aws_vpc.main.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${var.ip_white_list}"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = "${var.ip_white_list}"
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = "${var.ip_white_list}"
  }

  ingress {
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = "${var.ip_white_list}"
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = "${var.ip_white_list}"
  }

  tags = {
    Name = "jenkins"
  }
}

resource "aws_security_group" "application" {
  name        = "application"
  description = "Allow inbound traffic for application"
  vpc_id      = "${aws_vpc.main.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${var.ip_white_list}"
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = "${var.ip_white_list}"
  }

  ingress {
    from_port   = 50504
    to_port     = 50504
    protocol    = "tcp"
    cidr_blocks = "${var.ip_white_list}"
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = "${var.ip_white_list}"
  }

  tags = {
    Name = "application"
  }
}
