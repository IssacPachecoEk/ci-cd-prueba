# comandos para empaquetar las dependencias de la capa lambda
resource "null_resource" "build_layer" {
  triggers = {
    build_time = timestamp()
  }
  provisioner "local-exec" {
    command = "python -m venv venv"
  }
  provisioner "local-exec" {
    command = "venv\\Scripts\\activate.bat"
  }
  provisioner "local-exec" {
    command = "pip install pydantic-core --platform manylinux2014_x86_64 -t capa_lambda --only-binary=:all:"
  }
  provisioner "local-exec" {
    command = "pip install fastapi mangum -t capa_lambda"
  }
  provisioner "local-exec" {
  command     = "mkdir python\\lib\\python3.12\\site-packages"
  interpreter = ["cmd", "/C"]
  }
  provisioner "local-exec" {
    command     = "xcopy /y /s capa_lambda\\* python\\lib\\python3.12\\site-packages\\"
    interpreter = ["cmd", "/C"]
  }
  provisioner "local-exec" {
  command     = "powershell Compress-Archive -Path python -DestinationPath python.zip"
  interpreter = ["powershell", "-Command"]
  }
}
# creacion de la capa lambda
resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "${path.module}/../../python.zip"
  layer_name = "lambda_layer_fraternitas"

  compatible_runtimes = [var.runtime_version]
  depends_on = [null_resource.build_layer]
}
# comandos para empaquetar el codigo de la lambda
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../code/backend"
  output_path = "${path.module}/../../code/backend.zip"
  depends_on = [null_resource.build_layer]
}
# crear las funciones lambdas para el backend
resource "aws_lambda_function" "lambda_backend_fraternitas" {
  function_name     = "backend-${var.env_name}"
  role              = var.role_lambda_arn
  filename          = data.archive_file.lambda_zip.output_path
  source_code_hash  = data.archive_file.lambda_zip.output_base64sha256
  handler           = var.handler
  runtime           = var.runtime_version
  layers            = [aws_lambda_layer_version.lambda_layer.arn]
  ephemeral_storage {
    size = var.ephemeral_storage_size
  }
  vpc_config {
    subnet_ids         = var.subnets_for_lambda
    security_group_ids = [var.sg_for_lambda]
  }
  memory_size       = var.memory_size
  timeout           = var.timeout
  environment {
    variables = {}
  }
  logging_config {
    log_group             = "/aws/lambda/backend-${var.env_name}-${var.env_name}"
    log_format            = "JSON"
    application_log_level = "INFO"
  }
  tags = {
    Environment = var.env_name
    Name        = "backend-${var.env_name}"
    Service     = "lambda"
  }
  depends_on = [null_resource.build_layer]
}

# crear el grupo de logs para las funciones lambdas
resource "aws_cloudwatch_log_group" "shared_log_group" {
  name              = "/aws/lambda/backend-${var.env_name}-${var.env_name}"
  retention_in_days = var.retention_in_days
  tags = {
    Environment = var.env_name
    Name        = "backend-${var.env_name}"
    Service     = "lambda"
  }
}

output "output_arn_lambda_fraternitas" {
  value       = aws_lambda_function.lambda_backend_fraternitas.invoke_arn
  description = "ARN de la lambda para invocarlo desde el API Gateway"
}

output "output_name_lambda_fraternitas" {
  value       = "backend-${var.env_name}"
  description = "Nombre de la lambda para invocarlo desde el API Gateway"
}