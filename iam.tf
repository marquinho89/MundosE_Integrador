resource "aws_iam_role" "ec2-admin-role" {
  name               = "ec2-role"
  assume_role_policy = "${file("policy.json")}"

  tags = {
    tag-key = "ec2-admin-role"
  }
}

resource "aws_iam_policy" "ec2-admin-policy" {
  name        = "ec2-admin-policy"
  description = "Policy para poder conectarme a mi perfil AWS"
  policy      = "${file("policy-admin-ec2.json")}"
}

#Este es el attach de la policy ec2-admin-role y ec2-admin-policy
resource "aws_iam_role_policy_attachment" "ec2-attach-policy-to-role" {
  role       = "${aws_iam_role.ec2-admin-role.name}"
  policy_arn = "${aws_iam_policy.ec2-admin-policy.arn}"
}

#Instance profile para instancia EC2
resource "aws_iam_instance_profile" "ec2-admin-profile" {
  name = "ec2-admin-profile"
  role = aws_iam_role.ec2-admin-role.name
}