# Solución: Teemii en Kubernetes + Observabilidad (Loki, Prometheus, Grafana)

Migración del `docker/docker-compose.yml` de Teemii a Kubernetes y monitoreo con
Prometheus + Grafana más loki + Promtail para logs.

## Estructura

Los manifiestos no llevan `namespace`: se indica por comando con `-n`.

```
kubernetes/reto-observabilidad/
├── teemii/
│   ├── backend.yaml             # PVC teemii-data-pvc + Deployment + Service (ClusterIP :3000)
│   └── frontend.yaml            # Deployment + Service NodePort (8080 -> 80, nodePort 30080)
└── monitoring/
    ├── prometheus.yaml          # ServiceAccount + ClusterRole + config con kubernetes_sd_configs + Deployment + Service
    ├── node-exporter.yaml       # DaemonSet (métricas de cada nodo)
    ├── kube-state-metrics.yaml  # estado de pods / deployments / nodos
    ├── loki.yaml                # almacenamiento de logs
    ├── promtail.yaml            # DaemonSet que lee /var/log/pods y envía a Loki
    └── grafana.yaml             # datasources (Prometheus + Loki) + dashboard
```

## Desplegar

```bash
# Namespace
kubectl create namespace teemii

# 1. Teemii
kubectl apply -n teemii -f kubernetes/reto-observabilidad/teemii/

# 2. Observabilidad
kubectl apply -n teemii -f kubernetes/reto-observabilidad/monitoring/

# 3. Permisos a nivel cluster: el ClusterRoleBinding necesita el namespace del
#    ServiceAccount y -n no lo rellena, por eso se crea por comando
kubectl create clusterrolebinding prometheus-crb \
  --clusterrole=prometheus-cr --serviceaccount=teemii:prometheus-sa
kubectl create clusterrolebinding kube-state-metrics-crb \
  --clusterrole=kube-state-metrics-cr --serviceaccount=teemii:kube-state-metrics-sa
kubectl create clusterrolebinding promtail-crb \
  --clusterrole=promtail-cr --serviceaccount=teemii:promtail-sa

# Verificar
kubectl get pods,svc,pvc -n teemii
```

## Acceder con port-forward

```bash
kubectl port-forward -n teemii svc/teemii-frontend 8080:8080
kubectl port-forward -n teemii svc/grafana-svc 3000:3000
kubectl port-forward -n teemii svc/prometheus-svc 9090:9090
```

- Teemii: http://localhost:8080
- Grafana: http://localhost:3000
- Prometheus: http://localhost:9090

## Limpiar

```bash
# 1. Teemii
kubectl delete -n teemii -f kubernetes/reto-observabilidad/teemii/

# 2. Observabilidad (también borra los ClusterRole, que vienen en estos manifiestos)
kubectl delete -n teemii -f kubernetes/reto-observabilidad/monitoring/

# 3. Permisos a nivel cluster: los ClusterRoleBinding se crearon por comando y no pertenecen al namespace, así que no se borran con él
kubectl delete clusterrolebinding prometheus-crb kube-state-metrics-crb promtail-crb

# Namespace
kubectl delete namespace teemii
```
