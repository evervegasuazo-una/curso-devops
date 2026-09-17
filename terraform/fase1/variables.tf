variable "aws_region" {
  description = "La región de AWS donde se crea el bucket del estado"
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nombre del bucket S3 del estado remoto. Debe ser único a nivel global"
  default     = "terraform-workshop-evega-una"
}
