# Solucion Docker Manual

## 1. Crear red aislada tipo bridge

`docker network create --driver bridge teemii-network`

## 2. Crear volumen para backend

`docker volume create teemii-data`

## 3. Levantar backend sin puertos publicados y volumen teemii-data montado en /data

```docker run -d \
 --name teemii-backend \
 --network teemii-network \
 -v teemii-data:/data \
 dokkaner/teemii-backend
```

## 4. Levantar frontend con mapeo de puerto 8080 del host al 80 del contenedor y variables

```docker run -d \
 --name teemii-frontend \
 --network teemii-network \
 -p 8080:80 \
 -e VITE_APP_TITLE=Teemii \
 -e VITE_APP_PORT=80 \
 dokkaner/teemii-frontend
```
