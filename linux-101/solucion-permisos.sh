#!/bin/bash

# Crear usuarios
sudo useradd -m devopslead
sudo useradd dev1
sudo useradd dev2
sudo useradd intruder

# Crear contraseñas
sudo passwd devopslead
sudo passwd dev1
sudo passwd dev2
sudo passwd intruder

# Crear grupo
sudo groupadd release_team

# Agregar usuarios a grupo
sudo usermod -aG release_team devopslead
sudo usermod -aG release_team dev1
sudo usermod -aG release_team dev2

# ----------------------------------------------------------------

# Crear carpeta
sudo mkdir /srv/releases 

# Cambiar dueño y grupo
sudo chown devopslead:release_team /srv/releases

# Cambiar permisos carpeta
sudo chmod 750 /srv/releases

# ----------------------------------------------------------------

# Iniciar sesion como devopslead
su - devopslead

# Crear el archivo
echo "Secure release notes" > /srv/releases/release_notes.txt

# Cambiar grupo del archivo
chgrp release_team /srv/releases/release_notes.txt

# Cambiar permisos archivo
chmod 640 /srv/releases/release_notes.txt

# ----------------------------------------------------------------

# Eliminar archivo y carpeta
sudo rm -rf /srv/releases/

# Eliminar usuarios y sus home directories
sudo userdel -r devopslead
sudo userdel dev1
sudo userdel dev2
sudo userdel intruder

# Eliminar grupo
sudo groupdel release_team
