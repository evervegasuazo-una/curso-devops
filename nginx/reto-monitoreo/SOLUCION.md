# Solución: Monitoreo de Nginx con Prometheus + Grafana

## Levantar todo el stack (nginx + backends + monitoreo)

`docker compose up -d`

## Ver que todos los servicios estén sanos

`docker compose ps`

## Acceder

Nginx: http://localhost:8080    
stub_status: http://localhost:8080/stub_status 
nginx-exporter: http://localhost:9113/metrics 
Grafana: http://localhost:3000 (admin/admin)
Prometheus: http://localhost:9090    

## Prueba estres

Test para saturar worker_connections:
`ab -n 1000 -c 500 http://localhost:8080/`

Actualizar el nginx y ejecutar la prueba de nuevo:
`docker compose exec nginx nginx -s reload`

```conf
worker_processes auto;

events {
    worker_connections 1024;

}
```

# Bajar todos los servicios
docker compose down