# Reto: La Caja Fuerte de DevOps

## Historia

La compañía ficticia CloudCorp tiene un servidor Linux donde se guarda un archivo secreto llamado `release_notes.txt` con información sensible del próximo despliegue.
Solo un usuario especial llamado `devopslead` puede acceder al archivo.
Pero el equipo de desarrollo necesita un script que simule la generación de estos archivos y un proceso que monitoree quién intenta acceder.
Tu misión es configurar todo el entorno y hacer que funcione con las reglas de seguridad pedidas.

## Objetivos del reto

### Gestión de usuarios y grupos

- Crear el usuario `devopslead` con un home `/home/devopslead`.

- Crear un grupo `release_team` y agregar a `devopslead` y otros 2 usuarios ficticios.

- Crear un usuario `intruder` que no debe poder leer el archivo secreto.

### Permisos

- Crear la carpeta `/srv/releases` propiedad de `devopslead:release_team` con permisos:
  - Solo lectura y escritura para el dueño.

  - Solo lectura para el grupo.

  - Nada para otros.

- Dentro, crear el archivo `release_notes.txt` con texto ficticio.

- Asegurarse de que `intruder` no pueda leerlo.

### Procesos

- Crear un proceso (puede ser un script en loop infinito) que simule la actualización del `release_notes.txt` cada cierto tiempo.

- Usar `ps`, `top` o `htop` para identificarlo.

- Cambiarle la prioridad con `renice` para bajarle la prioridad de ejecución.

### Bash scripting

- Escribir un script llamado `check_access.sh` que:
  - Reciba como argumento un nombre de usuario.

  - Verifique si ese usuario pertenece a `release_team`.

  - Si pertenece, muestre `"Access granted"` y el contenido del `release_notes.txt`.

  - Si no, muestre `"Access denied"` y registre en `/var/log/access_attempts.log` la fecha, hora y usuario.

- El script debe validar que se ejecute como `root` o con permisos adecuados.

### Extra (para subir nota)

- Configurar un cron job que ejecute `check_access.sh intruder` cada 2 minutos para simular intentos no autorizados.

- Que los estudiantes monitoricen con `tail -f` el log para ver los intentos.

## Criterios de éxito

- Los permisos están configurados correctamente y `intruder` no puede leer el archivo.

- El script `check_access.sh` funciona para usuarios autorizados y no autorizados.

- El proceso de actualización del archivo existe y se puede detectar y modificar con `renice`.

- El log de accesos no autorizados se registra con fecha, hora y usuario.

- (Extra) El cron job genera entradas automáticas en el log.
