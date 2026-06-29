#!/usr/bin/env python3
import requests
import threading
import time
from collections import Counter

def make_requests(thread_id, num_requests, results):
    """Función para hacer peticiones desde un hilo"""
    servers_hit = []
    
    for i in range(num_requests):
        try:
            response = requests.get('http://localhost/slow', timeout=15)
            data = response.json()
            server_id = data.get('server_id', 'unknown')
            servers_hit.append(server_id)
            print(f"Hilo {thread_id}, Petición {i+1}: {server_id}")
        except Exception as e:
            print(f"Hilo {thread_id}, Error: {e}")
        time.sleep(0.1)
    
    results[thread_id] = servers_hit

def stress_test(num_threads=5, requests_per_thread=10):
    """Ejecutar prueba de estrés con múltiples hilos"""
    print(f"🚀 Iniciando stress test: {num_threads} hilos, {requests_per_thread} peticiones c/u")
    
    results = {}
    threads = []
    
    # Crear hilos
    start_time = time.time()
    for i in range(num_threads):
        thread = threading.Thread(
            target=make_requests, 
            args=(i, requests_per_thread, results)
        )
        threads.append(thread)
        thread.start()
    
    # Esperar que terminen todos los hilos
    for thread in threads:
        thread.join()
    
    end_time = time.time()
    
    # Consolidar resultados
    all_servers = []
    for thread_results in results.values():
        all_servers.extend(thread_results)
    
    server_counts = Counter(all_servers)
    total_requests = sum(server_counts.values())
    
    print(f"\n📊 Resultados del stress test:")
    print(f"⏱️  Tiempo total: {end_time - start_time:.2f}s")
    print(f"📝 Total peticiones: {total_requests}")
    print(f"📊 Distribución:")
    
    for server, count in server_counts.items():
        percentage = (count / total_requests) * 100
        print(f"  {server}: {count} peticiones ({percentage:.1f}%)")

if __name__ == "__main__":
    stress_test()