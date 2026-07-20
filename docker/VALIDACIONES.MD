# Validaciones

Se deben ver los contenedores:
`docker ps -a`

Revisar logs de cada servicio:
`docker logs teemii-backend`
`docker logs teemii-frontend`

Verificar que el back no esta expuesto y no responde a peticiones:
`curl -I http://localhost:3000`

Verificar que el backend es accesible desde la red interna:
`docker exec teemii-frontend curl -I http://teemii-backend:3000/api/v1/mangas`

Verificar que el front responde a peticiones:
`curl -I http://localhost:8080`

Debe cargar la interfaz web al abrir `http://localhost:8080` en el navegador