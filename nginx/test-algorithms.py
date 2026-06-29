#!/usr/bin/env python3
import requests
import time
import json
from collections import Counter
import threading

def test_algorithm(name, num_requests=30):
    print(f"\n🔬 Probando {name} con {num_requests} peticiones")
    print("=" * 50)
    
    servers_hit = []
    response_times = []
    
    for i in range(num_requests):
        start_time = time.time()
        try:
            response = requests.get('http://localhost:8080', timeout=10)
            end_time = time.time()
            
            data = response.json()
            server_id = data.get('server_id', 'unknown')
            servers_hit.append(server_id)
            response_times.append(end_time - start_time)
            
            print(f"Petición {i+1:2d}: {server_id} ({end_time - start_time:.3f}s)")
            
        except Exception as e:
            print(f"Error en petición {i+1}: {e}")
        
        time.sleep(0.2)  # Pequeña pausa entre peticiones
    
    # Estadísticas
    server_counts = Counter(servers_hit)
    print(f"\n📊 Distribución de peticiones:")
    for server, count in server_counts.items():
        percentage = (count / len(servers_hit)) * 100
        print(f"  {server}: {count} peticiones ({percentage:.1f}%)")
    
    avg_response_time = sum(response_times) / len(response_times)
    print(f"⏱️  Tiempo promedio de respuesta: {avg_response_time:.3f}s")

if __name__ == "__main__":
    test_algorithm("Algoritmo actual")