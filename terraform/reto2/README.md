# Reto DevOps: Docker + Terraform + Ansible + AWS

La app de TicoMarket corre dentro de un contenedor Docker, sobre una instancia EC2
creada con Terraform y configurada con Ansible. No se entra por SSH a instalar nada.

## Estructura

```
reto-2/
├── fase1/                Dockerfile y app (Node.js sin dependencias)
├── fase2/                Terraform: VPC, Security Group, key pair y EC2
├────────/backend-s3      Backend para el estado de terraform
├── fase3/ansible/        Roles de Ansible e inventario dinámico
└── pruebas/              Capturas de pantalla
```

## Requisitos

```bash
ssh-keygen -t rsa -C "ever.vega.suazo@una.cr" -f ./ssh-key

sudo apt install python3-venv
python3 -m venv ~/.venv/reto2 && source ~/.venv/reto2/bin/activate
pip install ansible boto3 botocore
ansible-galaxy collection install amazon.aws community.docker
```

## Fase 1 - Docker

La imagen usa `node:22-alpine`, corre como usuario sin privilegios.

Para probar localmente:

```bash
cd fase1
docker build -t ticomarket:latest .
docker images ticomarket
docker run --rm -p 8080:8080 ticomarket:latest
curl localhost:8080/health
```

## Fase 2 - Terraform

Crear bucket s3 para estado terraform.

```bash
cd fase2/backend-s3
terraform init
terraform plan
terraform apply
```

```bash
cd fase2
cp terraform.tfvars.example terraform.tfvars # Crear archivo de variables
curl -s ifconfig.me # Actualizar IP en terraform.tfvars
terraform init
terraform workspace new develop # Crear terraform workspace
terraform workspace select develop
terraform plan
terraform apply
```

## Fase 3 - Ansible

```bash
cd fase3/ansible
ansible-playbook playbooks/site.yml
```

## Pruebas

```bash
cd fase2
terraform output app_url
curl "$(terraform output -raw app_url)"
curl "$(terraform output -raw app_url)/health"

cd fase3/ansible
ansible-inventory --graph             # debe listar el grupo env_develop
ansible-playbook playbooks/site.yml   # la segunda corrida sale toda en "ok"
```

## Ambiente staging

```bash
cd fase2
terraform workspace new staging
terraform workspace select staging
terraform apply

cd fase3/ansible
ansible-playbook playbooks/site.yml -e target=env_staging
```

## Limpieza

```bash
cd fase2
terraform workspace select develop && terraform destroy
terraform workspace select default
terraform workspace delete develop

# Si se creó el ambiente staging:
terraform workspace select staging && terraform destroy
terraform workspace select default
terraform workspace delete staging
```
