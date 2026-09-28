Reto DevOps: Terraform + Ansible + Docker + AWS 

# Reto DevOps: Terraform + Ansible + Docker + AWS 

2026-09-21 

## 🎯 Objetivo del reto 

Al terminar, cada estudiante habrá construido —con sus propias manos, no copiando y pegando— un flujo mínimo pero real de infraestructura como código: una app corriendo en un contenedor, levantada en un servidor en AWS que **ellos mismos aprovisionaron con Terraform** , y **configurada automáticamente con Ansible** (sin entrar por SSH a instalar cosas a mano). 

No es un tutorial que se resuelve copiando comandos. Van a tener que leer documentación, romper cosas y volver a intentar. Esa fricción es el punto: es la primera vez que sienten cómo se conectan estas cuatro piezas entre sí. 

## 🧱 El caso: TicoMarket 

"TicoMarket" es una tienda en línea pequeña que hasta ahora corre su app en la laptop del dueño. Les acaba de llegar un cliente nuevo y necesitan un servidor de verdad, ya, sin gastar de más y sin depender de que alguien entre a mano cada vez que hay que instalar algo. 

Te contratan como el/la primer(a) practicante de DevOps. Tu tarea: dejar el servidor listo de forma que **cualquier compañero del equipo pueda reconstruirlo desde cero con dos comandos** , sin tener que recordar qué se instaló ni en qué orden. 

## 🧭 Arquitectura a construir 

#### `flowchart LR` 

```
    Dev["Tu máquina"] -->|"terraform apply"| AWS["AWS"]
    AWS --> EC2["EC2 (t2.micro)\n+ Security Group"]
    Dev -->|"ansible-playbook"| EC2
    EC2 -->|"instala"| Docker["Docker Engine"]
    Docker -->|"corre"| App["Contenedor\ncon tu app"]
```

Page 1 of 4 

Reto DevOps: Terraform + Ansible + Docker + AWS 

En corto: **Terraform crea el servidor** , **Ansible lo configura** (instala Docker y deja el contenedor corriendo), y todo vive en **AWS** . Nada se hace a mano por SSH. 

## 🧱 Fases del reto 

### Fase 1 — Docker (la app en una caja) 

- Toma cualquier app simple (puede ser la que ya tienen de otro curso, o algo de una línea tipo Flask/Express "Hola TicoMarket"). 

- Escribe un `Dockerfile` propio (no vale usar solo una imagen pública sin tocarla). 

- La imagen debe construir y correr localmente, exponiendo un puerto, antes de pasar a la Fase 2. 

- **Regla:** si el Dockerfile pesa más de 500MB, hay algo que optimizar (imagen base mal elegida, capas de más). 

### Fase 2 — Terraform (el servidor) 

- Con Terraform, crea en AWS: 

   - Una instancia EC2 `t2.micro` (elegible en free tier). 

   - Un Security Group que solo abra los puertos que realmente necesitas (SSH desde tu IP + el puerto de tu app). 

   - Una llave SSH (puede ser una que ya tengan, referenciada por nombre). 

- `terraform plan` y `terraform apply` deben correr sin errores y sin tocar nada a mano 

- en la consola de AWS después. 

- **Regla:** todo recurso creado debe poder destruirse con `terraform destroy` sin dejar nada huerfáno. 

### Fase 3 — Ansible (la configuración) 

- Escribe un playbook que, contra la IP que te dio Terraform: 

1. Instale Docker en la instancia. 

2. Copie o construya tu imagen (o la traiga desde Docker Hub si la subiste ahí). 

3. Levante el contenedor con la app corriendo. 

- Debe ser **idempotente** : correrlo dos veces seguidas no debe romper nada ni duplicar el contenedor. 

Page 2 of 4 

Reto DevOps: Terraform + Ansible + Docker + AWS 

**Regla:** cero comandos manuales por SSH. Si tuviste que entrar a arreglar algo a mano, eso tiene que volver al playbook. 

### Fase 4 — Integración (que todo hable entre sí) 

- Usa el `local-exec` o el inventory dinámico de Terraform para que la IP de salida alimente automáticamente el inventory de Ansible (sin copiar y pegar la IP a mano). 

- Reto final: desde cero ( `terraform destroy` primero), levantar todo el ambiente con **dos comandos** : uno de Terraform y uno de Ansible. 

- Verifica que la app responde desde el navegador usando la IP pública de la instancia. 

## 📦 Entregables 

1. Repositorio (Git) con: `Dockerfile` , código Terraform ( `.tf` ), playbook(s) de Ansible. 

2. Un `README.md` corto que explique cómo levantar todo desde cero (los dos comandos de la Fase 4). 

3. Una captura de pantalla de la app respondiendo desde la IP pública de AWS. 

4. Un `terraform destroy` exitoso al final (evidencia de que no dejaron recursos corriendo). 

## ✅ Criterios de evaluación 

|Criterio|Qué se revisa|Puntos|
|---|---|---|
|Docker|Dockerfile propio, imagen liviana, corre local|20|
|Terraform|Infra se crea y destruye limpio, sin recursos<br>huerfanos|25|
|Ansible|Playbook idempotente, cero pasos manuales por<br>SSH|25|
|Integración|Todo se levanta con los dos comandos de la Fase 4|20|
|Documentación|README claro, cualquiera del equipo podría<br>seguirlo|10|



Page 3 of 4 

Reto DevOps: Terraform + Ansible + Docker + AWS 

Aprueban con 70/100. No hay penalización por buscar ayuda en documentación oficial o foros — sí la hay por copiar el repo de un compañero sin entenderlo (se nota en la revisión oral de 5 minutos al final). 

## 🚀 Reto extra (opcional, para los que quieran más) 

Para quien termine antes y quiera más nivel, sin que sea obligatorio para aprobar: 

- Agregar un segundo ambiente (staging) usando **workspaces de Terraform** , sin duplicar el código `.tf` . 

- Mover las variables sensibles (llaves, IPs permitidas) a un archivo `.tfvars` que no se sube al repo. 

- Usar **Ansible roles** en vez de un solo playbook plano, para separar "instalar Docker" de "desplegar la app". 

- Agregar un `health check` simple: que Ansible verifique que el contenedor realmente responde antes de dar el playbook por exitoso. 

## 💡 Tips y errores comunes 

- **Cuida el bolsillo:** usar siempre `t2.micro` , cada quien en su propia cuenta free tier, y correr `terraform destroy` al terminar cada sesión de práctica. Dejar una instancia prendida toda la semana es el error número uno. 

- **Nunca subir credenciales de AWS al repo.** Usar variables de entorno o el archivo `~/.aws/credentials` , y agregar `*.tfstate` y `.tfvars` al `.gitignore` . 

- Si Ansible no puede conectarse por SSH, casi siempre es el Security Group (puerto 22 cerrado) o la llave equivocada — revisar ahí antes que nada. 

- `terraform plan` es tu amigo: córranlo antes de cada `apply` para ver qué va a cambiar. 

- Tiempo estimado: 6 a 10 horas repartidas en una a dos semanas, trabajando en pareja o solos. 

Page 4 of 4 

