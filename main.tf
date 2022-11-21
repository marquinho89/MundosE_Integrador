provider "aws" {
    region = "${var.aws_region}"
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
    delete_on_termination = true
  }
  user_data = "${file("user_data.sh")}"

  tags = {
    Name = "Jenkins"
  }
  #Asigno el Security groups
  vpc_security_group_ids = [aws_security_group.instance.id]
  #Asigno instance profile a la intancia EC2
  iam_instance_profile = "${aws_iam_instance_profile.ec2-admin-profile.name}"
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