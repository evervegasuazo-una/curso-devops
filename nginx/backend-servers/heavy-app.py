from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import datetime
import time

class HeavyHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        # Simular procesamiento pesado
        if '/compute' in self.path:
            # Simular cálculo intensivo
            start = time.time()
            result = sum(i*i for i in range(100000))  # Cálculo intensivo
            processing_time = time.time() - start
        else:
            processing_time = 0.1
            time.sleep(processing_time)
        
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        
        response = {
            "server_id": "backend-heavy",
            "server_type": "heavy-compute",
            "port": 8001,
            "message": "Servidor con procesamiento pesado",
            "timestamp": datetime.datetime.now().isoformat(),
            "path": self.path,
            "processing_time": f"{processing_time:.3f}s",
            "cpu_intensive": True
        }
        
        self.wfile.write(json.dumps(response, indent=2).encode())

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 8001), HeavyHandler)
    print("🏋️ Heavy Backend Server iniciado en puerto 8001")
    server.serve_forever()