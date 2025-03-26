resource "aws_iam_role_policy_attachment" "lambda_policy_basic_execution_role" {
  role       = aws_iam_role.role_lambda_fraternitas.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_lambda_role" {
  role       = aws_iam_role.role_lambda_fraternitas.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
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
          Service = "lambda.amazonaws.com"
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