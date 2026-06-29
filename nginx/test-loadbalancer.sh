#!/bin/bash

echo "🔄 Probando Load Balancer - 10 peticiones"
echo "========================================="

for i in {1..10}
do
    echo "Petición $i:"
    curl -s http://localhost 
    echo ""
    sleep 1
done