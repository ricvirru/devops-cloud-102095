// Servidor HTTP mínimo, sin dependencias externas (solo módulos nativos de Node),
// para que el ejemplo sea fácil de leer y buildear rápido.
//
// Lee dos variables de entorno:
//   APP_MESSAGE -> mensaje de saludo que devuelve
//   APP_PORT    -> puerto interno en el que escucha (también se usa en el Dockerfile)
//
// Cada visita queda registrada en /app/data/visitas.log, una carpeta pensada
// para montarse como volumen (bind mount o volumen nombrado) desde afuera.

const http = require("http");
const fs = require("fs");
const path = require("path");

const PORT = process.env.APP_PORT || 3000;
const MESSAGE = process.env.APP_MESSAGE || "Hola Mundo";
const DATA_DIR = "/app/data";
const LOG_FILE = path.join(DATA_DIR, "visitas.log");

if (!fs.existsSync(DATA_DIR)) {
  fs.mkdirSync(DATA_DIR, { recursive: true });
}

let visitas = 0;

const server = http.createServer((req, res) => {
  visitas++;
  const linea = `${new Date().toISOString()} - visita #${visitas} - ${req.method} ${req.url}\n`;

  try {
    fs.appendFileSync(LOG_FILE, linea);
  } catch (err) {
    console.error("No se pudo escribir el log:", err.message);
  }

  res.writeHead(200, { "Content-Type": "text/plain; charset=utf-8" });
  res.end(`${MESSAGE}\nVisita numero: ${visitas}\nEscucho en el puerto: ${PORT}\n`);
});

server.listen(PORT, () => {
  console.log(`Servidor escuchando en el puerto ${PORT} (APP_MESSAGE="${MESSAGE}")`);
});
