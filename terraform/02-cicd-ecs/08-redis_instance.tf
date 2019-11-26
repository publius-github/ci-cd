data "aws_vpc" "main" {
  id = "vpc-060fd8927b2af183e"
}
data "aws_iam_instance_profile" "jenkins" {
  name = "jenkins_profile"
}
data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = ["main"]       # insert value here
  }
}
data "aws_security_group" "selected" {
  id = "sg-05a82db4486783c3b"
}

resource "aws_instance" "redis" {
  ami = "ami-04bfee437f38a691e"
  instance_type = "t2.micro"
  iam_instance_profile = "${data.aws_iam_instance_profile.jenkins.name}"
  root_block_device {
    volume_size = "15"
    volume_type = "standard"
  }

  tags = {
    Name = "redis"
  }

  vpc_security_group_ids = ["${data.aws_security_group.selected.id}"]
  subnet_id              = "${data.aws_subnet.selected.id}"
  user_data = <<-EOF
    #!/bin/bash
    sudo amazon-linux-extras install -y docker
    sudo systemctl enable docker
    sudo systemctl start docker
    $(aws ecr get-login --no-include-email --region us-east-1)
    docker run -d -p 6379:6379 -e ALLOW_EMPTY_PASSWORD=yes 803808824931.dkr.ecr.us-east-1.amazonaws.com/cicd-redis:latest
	EOF
}

resource "aws_route53_record" "redis" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "db.simple-testing-capabilities.co.uk"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.redis.public_ip}"]
}

output "dns_redis" {
  value = "${aws_route53_record.redis.name}"
}
