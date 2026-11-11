El objetivo es crear un **Helm Chart** que permita desplegar toda la infraestructura de Teemii en un clúster local (como **Kind**) con un solo comando.

### 1. La Arquitectura del Chart

Basándote en su `docker-compose.yaml`, identifica los componentes. Tu Chart debe manejar:

- **Frontend (React/Vite):** El punto de entrada del usuario.
- **Backend (Node.js):** El cerebro que procesa la lógica y conexión a APIs.
- **Database (Redis/PostgreSQL):** El almacenamiento persistente.

### 2. Estructura de Archivos sugerida

Para este reto, organiza tu carpeta de la siguiente manera:

```text
teemii-chart/
├── Chart.yaml          # Metadatos del proyecto
├── values.yaml         # ¡Aquí va la magia! Define puertos, imágenes y tags
├── templates/          # Los archivos YAML de Kubernetes con placeholders
│   ├── frontend/       # deployment.yaml, service.yaml
│   ├── backend/        # deployment.yaml, service.yaml, configmap.yaml
│   └── database/       # statefulset.yaml (o deployment simple), service.yaml
└── README.md           # Instrucciones de uso
```

### 3. Puntos clave para el diseño (El "Pensamiento Helm")

Para que el reto sea efectivo, intenta implementar estas lógicas:

- **Variables Dinámicas:** No escribas a fuego (hardcode) las URLs. Usa `{{ .Values.backend.url }}` para que el frontend sepa dónde hablar con el backend.
- **Persistencia:** En un clúster local como Kind, investiga cómo usar un `PersistentVolumeClaim` (PVC) para que no pierdas tus mangas descargados si reinicias el pod.
- **Secretos:** No pongas las contraseñas de la base de datos en texto plano. Usa un `kind: Secret`.
- **Ingress (Opcional):** Si quieres nota máxima, intenta configurar un Ingress para acceder a `teemii.local` en lugar de usar `port-forward`.

### 4. ¿Cómo desplegarlo en Kind?

Una vez que tengas tus archivos listos, el flujo de despliegue que debes seguir en tu reto es este:

1. Crear el clúster:

   ```bash
   kind create cluster --name teemii-lab
   ```

2. Cargar imágenes (opcional):

   Si construyes las imágenes localmente, recuerda que Kind no las ve a menos que hagas:

   ```bash
   kind load docker-image teemii-frontend:latest --name teemii-lab
   ```

3. Instalar el Chart:

   Desde la raíz de tu carpeta:

   ```bash
   helm install mi-teemii ./teemii-chart
   ```

4. Verificar:

   ```bash
   kubectl get pods
   ```

### Una idea Pro para tu reto

Si quieres llevar el reto al siguiente nivel, piensa en la **dependencia**: ¿Cómo te aseguras de que el Backend no intente conectar con la Base de Datos antes de que esta esté lista? (Pista: Investiga los **Init Containers**).
