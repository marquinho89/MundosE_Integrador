provider "aws" {
    region = "us-east-1"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}
data "aws_availability_zones" "us-east-1a" {
    state = "available"
}

resource "aws_instance" "jenkins" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "t2.micro"
  key_name = "jenkins_access"
  root_block_device {
    volume_type = "gp2"
    volume_size = "30"
    delete_on_termination = false
  }
  user_data = "${file("user_data.sh")}"

  tags = {
    Name = "Jenkins"
  }
  vpc_security_group_ids = [aws_security_group.instance.id]
}

resource "aws_security_group" "instance" {
	name = "terraform-tcp-security-group"

	ingress {
		from_port = 0
		to_port = 8080
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		from_port = 0
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

output "IPAddress" {
  value = "${aws_instance.jenkins.public_ip}"
}