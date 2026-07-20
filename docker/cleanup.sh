#!/bin/bash

# Elimina los contenedores, redes y volúmenes creados por cualquiera de los dos metodos

echo "Limpieza iniciada"

docker rm -f teemii-frontend teemii-backend 2>/dev/null
docker network rm teemii-network 2>/dev/null
docker volume rm teemii-data 2>/dev/null

echo "Limpieza completada"
