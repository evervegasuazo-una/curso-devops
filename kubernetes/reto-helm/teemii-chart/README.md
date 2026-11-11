# Helm Chart de Teemii

Teemii (frontend + backend) en Kubernetes con Helm.

> Todos los comandos de esta guía se ejecutan desde `kubernetes/reto-helm/`.

## Índice

1. [Requisitos](#1-requisitos)
2. [Cambiar entre clústeres](#2-cambiar-entre-clústeres)
3. [Reiniciar de cero](#3-reiniciar-de-cero)
4. [Guía Kind](#4-guía-kind)
5. [Guía minikube](#5-guía-minikube)
6. [Pruebas](#6-pruebas)
7. [Limpiar](#7-limpiar)
8. [Cómo está hecho el chart](#8-cómo-está-hecho-el-chart)

## 1. Requisitos

| Herramienta | Versión probada                                                  |
| ----------- | ---------------------------------------------------------------- |
| Docker      | 29.x                                                             |
| kubectl     | 1.37                                                             |
| Helm        | 4.3                                                              |
| Kind        | 0.33 (nodo Kubernetes v1.37.0)                                   |
| minikube    | 1.39 (Kubernetes v1.37.0, driver `docker`, runtime `containerd`) |

## 2. Cambiar entre clústeres

```bash
# Ver contextos (el actual lleva *)
kubectl config get-contexts
kubectl config current-context

# Cambiar
kubectl config use-context <name>

# Ver qué clústeres existen
kind get clusters
minikube profile list
```

## 3. Reiniciar de cero

```bash
helm uninstall teemii -n teemii
kubectl delete namespace teemii
```

## 4. Guía Kind

### 4.1 Crear el clúster

`kind-config.yaml` publica en tu máquina el NodePort `30080` y los puertos `80`/`443` (Ingress).
Sin esos mapeos, Kind no expone nada fuera de Docker.

```bash
kind create cluster --config kind-config.yaml
kubectl config current-context   # kind-kind
```

### 4.2 Instalar

```bash
helm lint ./teemii-chart
helm install teemii ./teemii-chart -n teemii --create-namespace --wait --timeout 10m
```

### 4.3 Acceder

| Opción       | Comando                                                        | URL                                              |
| ------------ | -------------------------------------------------------------- | ------------------------------------------------ |
| NodePort     | (nada, lo publica `kind-config.yaml`)                          | [http://localhost:30080](http://localhost:30080) |
| Port-forward | `kubectl port-forward -n teemii svc/teemii-frontend 8080:8080` | [http://localhost:8080](http://localhost:8080)   |

### 4.4 Ingress (opcional)

```bash
# 1. Ingress controller (versión de ingress-nginx adaptada a Kind)
kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/deploy-ingress-nginx.yaml
kubectl wait -n ingress-nginx --for=condition=ready pod \
  -l app.kubernetes.io/component=controller --timeout=180s

# 2. Activar el Ingress del chart
helm upgrade teemii ./teemii-chart -n teemii --set ingress.enabled=true --wait
kubectl get ingress -n teemii

# 3. Resolver el host
echo "127.0.0.1 teemii.local" | sudo tee -a /etc/hosts
```

Abrir [http://teemii.local](http://teemii.local).

## 5. Guía minikube

### 5.1 Instalar

```bash
helm lint ./teemii-chart
helm install teemii ./teemii-chart -n teemii --create-namespace --wait --timeout 10m
kubectl get pods,svc,pvc -n teemii
```

### 5.2 Acceder con Port-forward

Ejecutar `kubectl port-forward -n teemii svc/teemii-frontend 8080:8080` y visitar [http://localhost:8080](http://localhost:8080)

### 5.3 Acceder con Ingress (opcional)

```bash
# 1. Ingress controller (crea el IngressClass "nginx" que usa el chart)
minikube addons enable ingress
kubectl wait -n ingress-nginx --for=condition=ready pod \
  -l app.kubernetes.io/component=controller --timeout=180s

# 2. Activar el Ingress del chart
helm upgrade teemii ./teemii-chart -n teemii --set ingress.enabled=true --wait
kubectl get ingress -n teemii     # ADDRESS = IP de minikube

# 3. Resolver el host
echo "$(minikube ip) teemii.local" | sudo tee -a /etc/hosts
```

Abrir [http://teemii.local](http://teemii.local).

## 6. Pruebas

```bash
kubectl get pods,svc,pvc -n teemii
helm list -n teemii
helm status teemii -n teemii
helm history teemii -n teemii
helm get values teemii -n teemii --all
```

## 7. Limpiar

```bash
helm uninstall teemii -n teemii
kubectl delete pvc -n teemii teemii-backend-data   # el PVC se conserva tras uninstall
```

## 8. Cómo está hecho el chart

### Estructura

```text
reto-helm/
├── kind-config.yaml            # clúster Kind con puertos 30080, 80 y 443 publicados y label ingress-ready
└── teemii-chart/
    ├── Chart.yaml
    ├── values.yaml             # imágenes, tags, puertos, persistencia, ingress
    ├── README.md
    └── templates/
        ├── _helpers.tpl        # nombres y labels comunes
        ├── NOTES.txt           # instrucciones tras el install
        ├── ingress.yaml        # opcional (ingress.enabled)
        ├── frontend/
        │   ├── configmap.yaml  # default.conf de nginx con la URL del backend parametrizada
        │   ├── deployment.yaml # init container que espera al backend
        │   └── service.yaml    # NodePort 8080 -> 80 (nodePort 30080)
        └── backend/
            ├── configmap.yaml  # variables de entorno (backend.env)
            ├── deployment.yaml # strategy Recreate (PVC ReadWriteOnce)
            ├── pvc.yaml        # /data persistente
            └── service.yaml    # ClusterIP 3000 (API) y 1555 (socket.io)
```

### Valores principales

| Clave                               | Default                               |
| ----------------------------------- | ------------------------------------- |
| `backend.image.repository` / `tag`  | `dokkaner/teemii-backend` / `latest`  |
| `backend.url`                       | `""` (Service del release)            |
| `backend.env`                       | `{}`                                  |
| `backend.persistence.enabled`       | `true`                                |
| `backend.persistence.storageClass`  | `""` (default del clúster)            |
| `backend.persistence.size`          | `1Gi`                                 |
| `frontend.image.repository` / `tag` | `dokkaner/teemii-frontend` / `latest` |
| `frontend.service.type`             | `NodePort`                            |
| `frontend.service.port`             | `8080`                                |
| `frontend.service.nodePort`         | `30080`                               |
| `frontend.waitForBackend.enabled`   | `true`                                |
| `ingress.enabled`                   | `false`                               |
| `ingress.className`                 | `nginx`                               |
| `ingress.host`                      | `teemii.local`                        |
