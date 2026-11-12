import http from "http";
import { saludo } from "./helper";

const PORT = process.env.PORT ? Number(process.env.PORT) : 3000;

const server = http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "text/plain; charset=utf-8" });
  res.end(`${saludo("Coderhouse")}\nRuta pedida: ${req.url}\n`);
});

server.listen(PORT, () => {
  console.log(`Servidor (compilado) escuchando en el puerto ${PORT}`);
});
