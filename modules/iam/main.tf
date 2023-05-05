/* Role Creation */
resource "aws_iam_role" "role" {
  name = var.role_name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_policy" "policy" {
  name        = var.policy_name
  path        = "/"
  description = var.description

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = var.policy
}


resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
resource "aws_iam_instance_profile" "test_profile" {
  name = aws_iam_role.role.name
  role = aws_iam_role.role.name
}
