# Reto: Arquitectura Multi-Tier en AWS

## Estructura

```
reto/
├── fase1/ Bucket S3 del estado remoto
├── fase2/ VPC, subredes, security groups, EC2, ALB
└── fase3/ Ansible: inventario dinámico y playbooks 
```

## Generar llave para conexión ssh

```bash
ssh-keygen -t rsa -C "ever.vega.suazo@una.cr" -f ./ssh-key
```

## Fase 1 - Estado remoto

```bash
cd fase1
terraform init
terraform plan
terraform apply
```

El reto pide una tabla DynamoDB para el bloqueo (punto 1.2), pero desde
Terraform 1.11 `dynamodb_table` está deprecado y la consola avisa de que hay
que usar el bloqueo nativo de S3. Por eso `provider.tf` usa `use_lockfile = true`.

## Fase 2 - Infraestructura

```bash
cd fase2
terraform init
terraform plan
terraform apply
```

## Fase 3 - Ansible

El plugin de inventario dinámico necesita `boto3`:

```bash
sudo apt install python3-venv
python3 -m venv ~/.venv/reto && source ~/.venv/reto/bin/activate
pip install ansible boto3 botocore
ansible-galaxy collection install amazon.aws
```

```bash
cd fase3/ansible
ansible-inventory --graph # debe listar tier_Web, tier_App y tier_Bastion
ansible-playbook playbooks/site.yml # Aplicar playbook
```

## Verificación

```bash
# El estado está en S3
aws s3 ls s3://terraform-workshop-evega-una/

# La aplicación responde por el ALB
curl "$(terraform output -raw alb_url)"
curl "$(terraform output -raw alb_url)/health"
curl "$(terraform output -raw alb_url)/web-status.html"

# La capa App no tiene IP pública
terraform output app_public_ips
```

## Limpieza

```bash
cd fase2
terraform destroy

aws s3 rm s3://terraform-workshop-evega-una --recursive
cd fase1
terraform destroy
```