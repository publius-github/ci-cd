resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "jenkins" {
  ami = "ami-04bfee437f38a691e"

  # instance_type = "t3.large"
  instance_type = "t2.medium"
  iam_instance_profile = "${aws_iam_instance_profile.jenkins_profile.name}"
  root_block_device {
    volume_size = "15"
    volume_type = "standard"
  }

  tags = {
    Name = "cicd"
    role = "jenkins"
  }

  vpc_security_group_ids = ["${aws_security_group.jenkins.id}"]
  subnet_id              = "${aws_subnet.main.id}"
  private_ip             = "10.0.1.100"
  key_name               = "${aws_key_pair.auth.id}"

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /opt/cicd",
      "sudo chmod 777 -R /opt/cicd",
    ]

    connection {
      type        = "ssh"
      host        = "${aws_instance.jenkins.public_ip}"
      user        = "ec2-user"
      private_key = "${file(var.private_key_path)}"
    }
  }

  provisioner "file" {
    source      = "docker/jenkins"
    destination = "/opt/cicd/jenkins"

    connection {
      type        = "ssh"
      host        = "${aws_instance.jenkins.public_ip}"
      user        = "ec2-user"
      private_key = "${file(var.private_key_path)}"
    }
  }

  provisioner "file" {
    source      = "files"
    destination = "/opt/cicd/files"

    connection {
      type        = "ssh"
      host        = "${aws_instance.jenkins.public_ip}"
      user        = "ec2-user"
      private_key = "${file(var.private_key_path)}"
    }
  }

  provisioner "file" {
    source      = "docker"
    destination = "/opt/cicd/docker"

    connection {
      type        = "ssh"
      host        = "${aws_instance.jenkins.public_ip}"
      user        = "ec2-user"
      private_key = "${file(var.private_key_path)}"
    }
  }
}

resource "null_resource" "configure" {
  depends_on = ["aws_volume_attachment.ebs_att"]

  provisioner "remote-exec" {
    inline = [
      "sudo sh /opt/cicd/files/startup_script_jenkins.sh",
    ]

    connection {
      type        = "ssh"
      host        = "${aws_instance.jenkins.public_ip}"
      user        = "ec2-user"
      private_key = "${file(var.private_key_path)}"
    }
  }
}

data "aws_route53_zone" "primary" {
  name = "simple-testing-capabilities.co.uk."
}

resource "aws_route53_record" "jenkins" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "jenkins.simple-testing-capabilities.co.uk"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.jenkins.public_ip}"]
}