## Desafío: Migración de Docker Compose a Kubernetes y Observabilidad con el *Stack* **LPG**

### **Objetivo del Reto**

El objetivo principal es tomar la configuración de **Docker Compose** de la aplicación **Teemii** y realizar su despliegue en un *cluster* de **Kubernetes**. Una vez desplegada, el reto es establecer un *stack* de **Observabilidad** robusto utilizando el patrón **LPG (Loki, Prometheus, Grafana)**, sustituyendo o complementando Loki con **Promtail** para la ingesta de *logs* en un contexto *Kubernetes*.

### **Fase 1: Preparación y Migración a Kubernetes**

El punto de partida es el archivo `docker-compose.yaml` de Teemii.

#### 🎯 **Tareas Clave:**

1. **Creación de Imágenes:** Asegúrate de que las imágenes de `teemii-frontend` y `teemii-backend` puedan ser accedidas por Kubernetes. Si estás usando la directiva `build` en tu Compose, necesitarás **construir las imágenes** localmente y **subirlas a un registro de contenedores** (como Docker Hub o un registro privado) al que tu *cluster* K8s tenga acceso.

2. **Definición de *Manifests* de K8s:** Traduce la configuración de Compose a objetos nativos de Kubernetes.

#### 💡 **Pistas y Consejos (*Hints*):**

- **Servicios:** Los servicios de Compose (`teemii-frontend`, `teemii-backend`) se deben convertir en `Deployments` de Kubernetes para la gestión de réplicas y en `Services` para la comunicación interna y exposición.

- **Redes:** La red (`teemii-network`) en K8s se gestiona automáticamente. Simplemente asegúrate de que los `Deployments` y `Services` estén en el mismo *namespace* o úsalos por su nombre de *service* para la comunicación interna.

- **Puertos y Exposición:** La exposición del puerto `8080` (del *frontend*) requerirá un `Service` de tipo `NodePort` o, idealmente, un `Ingress` para un acceso más controlado y en producción.

- **Volúmenes:** El volumen persistente (`teemii-data`) para el *backend* debe ser un `PersistentVolumeClaim` (PVC) asociado a un `Deployment` (montado en `/data`) para asegurar la persistencia de los datos del *backend*.

- **Variables de Entorno:** Las `environment` de Compose se definen en la sección `spec.containers.env` de los `Deployments`.

### **Fase 2: Implementación del *Stack* de Observabilidad**

Una vez Teemii esté funcionando correctamente en Kubernetes, integra las herramientas de monitoreo.

#### 🎯 **Tareas Clave:**

1. **Despliegue de Prometheus:** Configura Prometheus para que descubra y extraiga métricas de tu *cluster* y de los *pods* de Teemii (si la aplicación expone métricas).

2. **Despliegue de Grafana:** Instala Grafana y conéctalo como fuente de datos a Prometheus (y a Loki, si lo integras).

3. **Implementación de *Logs* (*Log Aggregation*):** Configura **Promtail** para recolectar los *logs* de los contenedores de Teemii y enviarlos a un sistema de gestión de *logs* (idealmente **Loki**, aunque no esté explícitamente en la lista, es la mejor práctica para usar con Promtail).

#### 💡 **Pistas y Consejos (*Hints*):**

- **Automatización de Despliegue (Opcional):** Considera usar **Helm Charts** para desplegar componentes complejos como Prometheus y Grafana de forma rápida y estandarizada.

- **Descubrimiento de Servicios (Prometheus):** Prometheus necesita **descubrimiento de servicios** (`service discovery`) de Kubernetes para saber dónde están sus objetivos. La configuración `kubernetes_sd_configs` es clave.

- **Métricas de K8s:** Para monitorear el *cluster* en sí, asegúrate de desplegar un `kube-state-metrics` y un `Node Exporter` para obtener métricas de los recursos (*pods*, *nodes*, *deployments*).

- **Recolección de *Logs* (Promtail):** Promtail generalmente se despliega como un `DaemonSet` en Kubernetes. Esto asegura que haya una instancia de Promtail ejecutándose en *cada nodo* para recolectar los *logs* de todos los *pods* locales.

## **Preguntas a Responder y Entregables**

Al finalizar el reto, debes ser capaz de:

1. Mostrar los manifiestos YAML (`Deployment`, `Service`, `PVC`, etc.) utilizados para desplegar Teemii.

2. Confirmar que la aplicación es accesible a través del puerto `8080` de su nuevo *endpoint* de Kubernetes.

3. Demostrar un *dashboard* de Grafana que muestre métricas relevantes de los *pods* de Teemii (uso de CPU/Memoria, latencia, etc., según lo que expongas).

4. Mostrar *logs* del *frontend* y *backend* de Teemii dentro de Grafana, utilizando Promtail como recolector, esto si es que esas apps devuelven logs.
