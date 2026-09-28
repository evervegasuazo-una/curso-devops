variable "aws_region" {
  description = "La región de AWS donde se despliega la arquitectura."
  default     = "us-east-1"
}

variable "azs" {
  description = "Zonas de disponibilidad."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "ami_id" {
  description = "ID de la AMI (Amazon Linux 2023)"
  default     = "ami-0354c98ae10b02961"
}

variable "cidr_vpc" {
  description = "CIDR block de la VPC"
  default     = "10.0.0.0/16"
}

variable "cidr_public_subnets" {
  description = "CIDR de las subredes públicas."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "cidr_private_subnets" {
  description = "CIDR de las subredes privadas."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "web_instance_type" {
  description = "Tipo de instancia de la capa Web."
  default     = "t3.micro"
}

variable "app_instance_type" {
  description = "Tipo de instancia de la capa App."
  default     = "t3.small"
}

variable "bastion_instance_type" {
  description = "Tipo de instancia de la capa Bastion."
  default     = "t3.micro"
}

variable "app_port" {
  description = "Puerto de la aplicación Node.js."
  default     = 8080
}

variable "db_port" {
  description = "Puerto de la capa de base de datos."
  default     = 3306
}

variable "public_key_path" {
  description = "Clave pública."
  default     = "../ssh-key.pub"
}
