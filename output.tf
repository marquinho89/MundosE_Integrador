output "IPAddress" {
  value = "${aws_instance.jenkins.public_ip}"
}