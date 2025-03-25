resource "aws_iam_role_policy" "policy_lambda_fraternitas" {
  name = var.name_policy
  role = aws_iam_role.role_lambda_fraternitas.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
          Action = var.iam_action_permission
          Resource = var.iam_resource_permission
          Effect   = "Allow"
        }
      ]
  })
}

resource "aws_iam_role" "role_lambda_fraternitas" {
  name = var.name_role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
          Service = var.iam_role_services
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

output "arn_role_lambda_fraternitas" {
  value       = aws_iam_role.role_lambda_fraternitas.arn
  description = "ARN del rol de IAM para la función Lambda"
}