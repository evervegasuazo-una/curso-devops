// Servidor HTTP sin dependencias: sólo hace falta el runtime de Node.js.
const http = require("http");
const fs = require("fs");
const os = require("os");

const PORT = process.env.PORT || 8080;

http
  .createServer((req, res) => {
    if (req.url === "/health") {
      res.writeHead(200, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ status: "ok", host: os.hostname() }));
      return;
    }

    fs.readFile(__dirname + "/public/index.html", (err, content) => {
      if (err) {
        res.writeHead(500);
        res.end("Error al leer index.html");
        return;
      }
      res.writeHead(200, {
        "Content-Type": "text/html; charset=utf-8",
        "X-Container": os.hostname(),
      });
      res.end(content);
    });
  })
  .listen(PORT, "0.0.0.0", () => {
    console.log("TicoMarket escuchando en el puerto: " + PORT);
  });
