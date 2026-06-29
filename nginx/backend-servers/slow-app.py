from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import datetime
import time
import random

class SlowHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        # Simular procesamiento variable
        if '/slow' in self.path:
            delay = random.uniform(1, 5)  # 1-5 segundos de delay
            time.sleep(delay)
        elif '/fast' in self.path:
            delay = 0.1
            time.sleep(delay)
        else:
            delay = random.uniform(0.2, 2)  # Delay aleatorio
            time.sleep(delay)
        
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        
        response = {
            "server_id": f"backend-{self.server.server_port - 8000}",
            "port": self.server.server_port,
            "message": f"Respuesta desde servidor en puerto {self.server.server_port}",
            "timestamp": datetime.datetime.now().isoformat(),
            "path": self.path,
            "processing_time": f"{delay:.2f}s",
            "client_ip": self.headers.get('X-Real-IP', 'No disponible')
        }
        
        self.wfile.write(json.dumps(response, indent=2).encode())

if __name__ == '__main__':
    import sys
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8001
    server = HTTPServer(('0.0.0.0', port), SlowHandler)
    print(f"🐌 Backend con delays iniciado en puerto {port}")
    server.serve_forever()