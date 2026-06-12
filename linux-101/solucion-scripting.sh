# Agregar permisos de ejecucion
sudo chmod +x linux-101/check_access.sh

# Ejecutar el script
sudo ./linux-101/check_access.sh &

# Ver logs
tail -f /var/log/access_attempts.log