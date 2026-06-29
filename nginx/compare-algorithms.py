#!/usr/bin/env python3
import subprocess
import requests
import time
from collections import Counter

def test_distribution(algorithm_name, config_file, num_requests=50):
    print(f"\n🧪 Probando {algorithm_name}")
    print("-" * 40)
    
    # Cambiar configuración
    subprocess.run([
        'cp', f'nginx-config/{config_file}', 'nginx-config/nginx.conf'
    ], check=True)
    
    # Recargar nginx
    subprocess.run([
        'docker-compose', 'exec', 'nginx', 'nginx', '-s', 'reload'
    ], check=True)
    
    time.sleep(2)  # Esperar que se aplique el cambio
    
    # Hacer peticiones
    servers_hit = []
    response_times = []
    
    for i in range(num_requests):
        start = time.time()
        try:
            response = requests.get('http://localhost', timeout=10)
            end = time.time()
            
            data = response.json()
            server_id = data.get('server_id', 'unknown')
            servers_hit.append(server_id)
            response_times.append(end - start)
            
        except Exception as e:
            print(f"Error: {e}")
        
        time.sleep(0.1)
    
    # Mostrar resultados
    server_counts = Counter(servers_hit)
    total = sum(server_counts.values())
    
    print("📊 Distribución:")
    for server, count in sorted(server_counts.items()):
        percentage = (count / total) * 100
        print(f"  {server}: {count:2d} peticiones ({percentage:5.1f}%)")
    
    avg_time = sum(response_times) / len(response_times)
    print(f"⏱️  Tiempo promedio: {avg_time:.3f}s")

def main():
    algorithms = [
        ("Round Robin", "round-robin"),
        ("Weighted (5:3:2)", "weighted"),
        ("Least Connections", "least-conn"),
        ("IP Hash", "ip-hash")
    ]
    
    print("🚀 Comparativa de Algoritmos de Load Balancing")
    print("=" * 60)
    
    for name, config in algorithms:
        test_distribution(name, config)
        time.sleep(3)  # Pausa entre pruebas

if __name__ == "__main__":
    main()