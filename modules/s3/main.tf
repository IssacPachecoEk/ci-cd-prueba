# se define el nombre del s3 para almacenar el archivo terraform.tfstate
resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name
  tags   = var.common_tag
}
#se declara el versionamiento de los objetos del bucket para terraform.tfstate
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = var.bucket_versioning_enabled
  }
}
# declaro el acceso publico al bucket como bloqueado
resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = var.bucket_block_public_acls
  block_public_policy     = var.bucket_block_public_policy
  ignore_public_acls      = var.bucket_ignore_public_acls
  restrict_public_buckets = var.bucket_restrict_public_buckets
}
# declaro el control de la propiedad del bucket
resource "aws_s3_bucket_ownership_controls" "bucket_ownership_controls" {
  bucket = aws_s3_bucket.main.id
  rule {
    object_ownership = var.bucket_object_ownership
  }
}

#subir el archivo index.html del frontend al bucket
resource "aws_s3_object" "object" {
  bucket     = aws_s3_bucket.main.bucket
  key        = "index.html"
  source     = "${path.module}/../../code/frontend"
  depends_on = [aws_s3_bucket.main]
}