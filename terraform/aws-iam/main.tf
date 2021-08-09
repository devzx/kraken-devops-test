data "aws_caller_identity" "this" {}

/* Referenced https://aws.amazon.com/premiumsupport/knowledge-center/iam-assume-role-cli/ */
resource "aws_iam_role" "this" {
  name = var.resource_prefix_enabled ? format("%s-role", var.name) : var.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "self" {
  name = var.resource_prefix_enabled ? format("%s-policy", var.name) : var.name
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = aws_iam_role.this.arn
      },
    ]
  })
}

resource "aws_iam_group" "self" {
  name = var.resource_prefix_enabled ? format("%s-group", var.name) : var.name
}

resource "aws_iam_group_policy_attachment" "self" {
  group      = aws_iam_group.self.name
  policy_arn = aws_iam_policy.self.arn
}

resource "aws_iam_user" "self" {
  name = var.resource_prefix_enabled ? format("%s-user", var.name) : var.name
}

resource "aws_iam_group_membership" "self" {
  name  = var.resource_prefix_enabled ? format("%s-group-membership", var.name) : var.name
  users = [aws_iam_user.self.name]
  group = aws_iam_group.self.name
}