DevOps: Arquitectura Multi-Tier en AWS


Este desafío tiene como objetivo la construcción de una aplicación web moderna de dos capas (Web y Aplicación) en la nube de AWS, utilizando Terraform para provisionar la infraestructura y Ansible para su configuración, asegurando el cumplimiento de prácticas de Alta Disponibilidad y Gestión de Estado Remoto.
Objetivos Principales del Desafío

    Terraform: Provisionar una infraestructura completa y segura en AWS.

    Ansible: Configurar de manera idempotente los servidores de la aplicación.

    Alta Disponibilidad: Desplegar recursos a través de múltiples Zonas de Disponibilidad (AZs).

    Best Practice: Manejo de Estado Remoto: Configurar y utilizar un backend de estado en S3 con bloqueo.

Fase 1: Configuración del Entorno y Manejo de Estado (Remote State)

El primer paso y el más retador es asegurar que el equipo pueda trabajar de forma colaborativa y segura.

1.1 Backend de Terraform: Usando un proyecto Terraform inicial (o manualmente, para mayor reto), provisionar un Bucket S3 que servirá como backend remoto para el estado.


1.2 Bloqueo de Estado (State Locking): Provisionar una tabla de Amazon DynamoDB para gestionar el bloqueo de estado y prevenir la corrupción del estado remoto por ejecuciones concurrentes.


1.3Configuración del backend: Configurar el bloque backend "s3" en el archivo main.tf del proyecto principal de la aplicación, apuntando al bucket S3 y a la tabla DynamoDB creados en los pasos anteriores.
Fase 2: Provisionamiento de Infraestructura con Terraform

Se debe crear una arquitectura multi-tier y fault-tolerant.

2.1 Red y Subredes: Provisionar un VPC con subredes públicas y privadas, distribuidas en al menos 2 Zonas de Disponibilidad (AZs).

2.2 Grupos de Seguridad: Crear grupos de seguridad restrictivos para cada capa (Web, App, DB), asegurando que solo el tráfico permitido pueda fluir entre ellas (por ejemplo, Web -> App en el puerto 8080).

2.3 Capa Web (Pública): Desplegar dos instancias EC2 (Web Servers), una en cada subred pública, para servir contenido estático o balancear el tráfico. Uso de count o for_each para la Alta Disponibilidad.

2.4 Capa de Aplicación (Privada): Desplegar dos instancias EC2 (Application Servers) en las subredes privadas. Estas no deben tener IP pública. Uso de Key Pair y Bastion Host (opcional) para acceso.

2.5Balanceo de Carga: Opcionalmente, provisionar un Application Load Balancer (ALB) para distribuir el tráfico a las instancias de la Capa Web.aws_lb, aws_lb_target_group

2.6Metadatos: Asignar tags específicos a cada instancia (ej: Tier: Web, Tier: App). Estos tags serán cruciales para el Inventario Dinámico de Ansible.tags en aws_instance
Fase 3: Configuración de Servidores con Ansible

El equipo debe configurar las instancias de forma automatizada y segura.

3.1 Inventario Dinámico: Configurar el inventario de Ansible para que no utilice un archivo hosts estático, sino que se conecte directamente a la API de AWS para descubrir las instancias usando los tags creados por Terraform. Plugin aws_ec2 o similar. Evitar el inventario manual.


3.2 Playbook Web Tier: Crear un playbook para la Capa Web que:

* Instale un servidor web (Nginx o Apache).
* Despliegue una página estática simple.
* Asegure que el servicio esté iniciado y habilitado (`state: started`, `enabled: yes`). | Playbooks, Módulos `apt`/`yum`, `service`. | Idempotencia y Handlers. |


3.3 Playbook App Tier: Crear un playbook para la Capa de Aplicación que:

    Instale el runtime necesario (p. ej., Python, Node.js).

    Despliegue una aplicación de ejemplo (p. ej., un servidor HTTP simple en Python). 

Criterios de Evaluación

El desafío se considerará exitoso si:

    Infraestructura (Terraform): Se aplica un terraform apply sin errores, y se demuestra que el estado se guarda en el bucket S3 y que el bloqueo de estado con DynamoDB funciona (p. ej., intentando una segunda ejecución simultánea).

    Red: Las instancias de la Capa Web son accesibles desde internet a través del ALB (si aplica), y las instancias de la Capa de Aplicación no tienen IP pública y solo son accesibles desde la Capa Web.

    Configuración (Ansible): Los playbooks se ejecutan exitosamente utilizando el Inventario Dinámico y se puede verificar que Nginx/Apache está corriendo en la Capa Web y la aplicación de ejemplo está corriendo en la Capa de Aplicación.

    Limpieza: El equipo es capaz de ejecutar un terraform destroy exitoso para eliminar todos los recursos provisionados.

¡Este es un reto completo que toca todos los puntos clave de la automatización DevOps en AWS!