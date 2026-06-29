#!/bin/bash

switch_to() {
    echo "🔄 Cambiando a algoritmo: $1"
    cp nginx-config/$1.conf nginx-config/nginx.conf
    docker compose exec nginx nginx -s reload
    echo "✅ Algoritmo $1 activado"
    echo ""
}

case $1 in
    "round-robin"|"rr")
        switch_to "round-robin"
        ;;
    "weighted"|"w")
        switch_to "weighted"
        ;;
    "least-conn"|"lc")
        switch_to "least-conn"
        ;;
    "ip-hash"|"ih")
        switch_to "ip-hash"
        ;;
    *)
        echo "Uso: $0 [round-robin|weighted|least-conn|ip-hash]"
        echo "Aliases: rr, w, lc, ih"
        exit 1
        ;;
esac