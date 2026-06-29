# Clase 3: Algoritmos de Balanceeo en Nginx

Este directorio contiene la configuración completa para la Clase 3 sobre algoritmos de load balancing en Nginx.

## 🚀 Inicio Rápido

### 1. Levantar el entorno
```bash
docker compose up -d
```

### 2. Verificar que funciona
```bash
curl http://localhost/algorithm
```

### 3. Probar algoritmos
```bash
# Hacer scripts ejecutables
chmod +x switch-algorithm.sh
chmod +x *.py

# Cambiar a weighted round robin
./switch-algorithm.sh weighted

# Probar distribución
python3 test-algorithms.py
```

## 📁 Estructura del Proyecto

```
clase-3/
├── nginx-config/
│   ├── round-robin.conf     # Round Robin (default)
│   ├── weighted.conf        # Weighted Round Robin (5:3:2)
│   ├── least-conn.conf      # Least Connections
│   ├── ip-hash.conf         # IP Hash (sticky sessions)
│   ├── realistic.conf       # Configuración con timeouts
│   └── nginx.conf           # Configuración activa
├── backend-servers/
│   ├── slow-app.py          # Backend con delays simulados
│   ├── heavy-app.py         # Backend con procesamiento pesado
│   └── Dockerfile
├── test-algorithms.py       # Prueba algoritmo activo
├── stress-test.py           # Prueba de estrés concurrente
├── compare-algorithms.py    # Compara todos los algoritmos
├── switch-algorithm.sh      # Cambiar algoritmos en tiempo real
└── docker-compose.yml
```

## 🔧 Scripts de Utilidad

### Cambiar Algoritmos
```bash
./switch-algorithm.sh rr          # Round Robin
./switch-algorithm.sh weighted    # Weighted
./switch-algorithm.sh lc          # Least Connections  
./switch-algorithm.sh ih          # IP Hash
```

### Pruebas de Rendimiento
```bash
python3 test-algorithms.py       # Prueba algoritmo actual
python3 stress-test.py           # Prueba de estrés
python3 compare-algorithms.py    # Compara todos
```

## 📊 Algoritmos Disponibles

### Round Robin
- Distribución secuencial entre servidores
- Ideal para servidores con capacidades similares

### Weighted Round Robin  
- Pesos: backend1=5, backend2=3, backend3=2
- Ideal para servidores con diferentes capacidades

### Least Connections
- Envía a servidor con menos conexiones activas
- Ideal para peticiones de duración variable

### IP Hash
- Sticky sessions basadas en IP del cliente
- Ideal para mantener sesiones de usuario

## 🧪 Ejercicios Sugeridos

1. **Probar cada algoritmo:**
   ```bash
   for algo in rr weighted lc ih; do
     ./switch-algorithm.sh $algo
     python3 test-algorithms.py
   done
   ```

2. **Modificar pesos:**
   - Editar `nginx-config/weighted.conf`
   - Probar configuraciones como 10:1:1

3. **Stress test:**
   ```bash
   python3 stress-test.py
   ```

4. **Monitorear logs:**
   ```bash
   docker-compose exec nginx tail -f /var/log/nginx/access.log
   ```

## 🔍 Verificar Estado

```bash
# Ver algoritmo activo
curl http://localhost/algorithm

# Ver logs de nginx
docker-compose logs nginx

# Ver logs detallados
docker-compose exec nginx tail -f /var/log/nginx/access.log

# Estado de contenedores
docker-compose ps
```

## 🛠️ Troubleshooting

### Si no funciona el cambio de algoritmo:
```bash
# Verificar sintaxis nginx
docker-compose exec nginx nginx -t

# Recargar manualmente
docker-compose exec nginx nginx -s reload

# Reiniciar completamente
docker-compose restart nginx
```

### Si los backends no responden:
```bash
# Ver logs de backends
docker-compose logs backend1
docker-compose logs backend2
docker-compose logs backend3

# Verificar conectividad
docker-compose exec nginx ping backend1
```