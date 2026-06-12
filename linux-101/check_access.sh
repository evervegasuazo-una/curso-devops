#!/bin/bash

# Validar ejecución como root
if [ "$EUID" -ne 0 ]; then
    echo "Only root can execute"
    exit 1
fi

# Validar argumento recibido
if [ $# -ne 1 ]; then
    echo "Error: not user provided"
    exit 1
fi

# Variables
USER_NAME="$1"
GROUP_NAME="release_team"
FILE="/srv/releases/release_notes.txt"
LOG_FILE="/var/log/access_attempts.log"

# Verificar si el usuario existe
if ! id "$USER_NAME" &>/dev/null; then
    echo "User not found"
    exit 1
fi

# Verificar si el usuario pertenence al grupo
if id -nG "$USER_NAME" | grep -qw "$GROUP_NAME"; then
    echo "Access granted"
    tail -n 10 "$FILE"
else
    echo "Access denied"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $USER_NAME" >> "$LOG_FILE"
fi