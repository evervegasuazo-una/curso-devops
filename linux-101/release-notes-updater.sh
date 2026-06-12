#!/bin/bash

while true
do
    echo "Archivo actualizado: $(date)" >> /srv/releases/release_notes.txt
    sleep 5
done