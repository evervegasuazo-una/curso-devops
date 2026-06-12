# Cambiar dueño para que el script pueda modificar el archivo
sudo chown devopslead linux-101/release-notes-updater.sh

# Agregar permisos de ejecucion
sudo chmod +x linux-101/release-notes-updater.sh

# Ejecutar el script
sudo -u devopslead ./linux-101/release-notes-updater.sh &

# Buscar el proceso
ps aux | grep release-notes-updater

# Ver prioridad actual, 0 es el valor esperado
ps -o pid,ni,pri,cmd -p <PID>

# Bajar prioridad al maximo
sudo renice 19 -p <PID>

# Terminar proceso
sudo kill <PID>