# Editar tabla de cron jobs
sudo crontab -e

# Agregar cron job al final (usar ruta relativa)
*/2 * * * * <PATH>/curso-devops/linux-101/check_access.sh intruder

# Eliminar cron job
sudo crontab -l | grep -v "check_access.sh intruder" | sudo crontab -