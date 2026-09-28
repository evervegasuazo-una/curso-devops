variable "aws_region" {
  description = "La región de AWS donde se despliega TicoMarket."
  default     = "us-east-1"
}

variable "az" {
  description = "Zona de disponibilidad de la instancia."
  default     = "us-east-1a"
}

variable "ami_id" {
  description = "ID de la AMI (Amazon Linux 2023)"
  default     = "ami-0354c98ae10b02961"
}

variable "instance_type" {
  description = "Tipo de instancia EC2. Mismo tamaño en develop y staging."
  default     = "t3.micro"
}

variable "cidr_vpc" {
  description = "CIDR block de la VPC"
  default     = "10.0.0.0/16"
}

variable "cidr_public_subnet" {
  description = "CIDR de la subred pública donde vive el host Docker."
  default     = "10.0.1.0/24"
}

variable "app_port" {
  description = "Puerto público de la app (el contenedor publica 8080 en este puerto)."
  type        = number 
}

variable "app_name" {
  description = "Nombre de la app."
  type        = string 
}

variable "allowed_ssh_cidrs" {
  description = "Desde dónde se permite SSH."
  type        = list(string)

  validation {
    condition     = length(var.allowed_ssh_cidrs) > 0
    error_message = "Definir al menos un CIDR."
  }
}

variable "public_key_path" {
  description = "Ruta a la clave pública SSH."
  type        = string
}

variable "root_volume_size" {
  description = "Tamaño del disco raíz en GB. Docker necesita espacio para construir la imagen."
  default     = 16
}

variable "bucket_name" {
  description = "Nombre del bucket S3 del estado remoto."
  type        = string
}