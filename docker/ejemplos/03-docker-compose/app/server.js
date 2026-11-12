// App que se conecta a una base Postgres en OTRO contenedor, usando el nombre
// de servicio (DB_HOST) como hostname -- esto es lo que resuelve la red de
// Docker (ya sea creada por docker-compose o a mano con "docker network create").
//
// Cada request inserta una fila en la tabla "visitas" y devuelve el total.

const http = require("http");
const { Client } = require("pg");

const PORT = process.env.PORT || 3000;

const DB_CONFIG = {
  host: process.env.DB_HOST,
  port: process.env.DB_PORT || 5432,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
};

async function initTable(client) {
  await client.query(`
    CREATE TABLE IF NOT EXISTS visitas (
      id SERIAL PRIMARY KEY,
      creado_en TIMESTAMP DEFAULT NOW()
    );
  `);
}

const server = http.createServer(async (req, res) => {
  const client = new Client(DB_CONFIG);
  try {
    await client.connect();
    await initTable(client);
    await client.query("INSERT INTO visitas DEFAULT VALUES");
    const { rows } = await client.query("SELECT COUNT(*) FROM visitas");

    res.writeHead(200, { "Content-Type": "text/plain; charset=utf-8" });
    res.end(
      `Conectado a Postgres en host="${DB_CONFIG.host}"\n` +
        `Total de visitas registradas: ${rows[0].count}\n`
    );
  } catch (err) {
    // Si esto falla justo al arrancar, probablemente Postgres todavia no
    // termino de inicializar -- por eso el docker-compose.yml usa un
    // healthcheck en vez de confiar solo en "depends_on".
    res.writeHead(500, { "Content-Type": "text/plain; charset=utf-8" });
    res.end(`Error conectando a la base (${DB_CONFIG.host}): ${err.message}\n`);
  } finally {
    await client.end().catch(() => {});
  }
});

server.listen(PORT, () => {
  console.log(`App escuchando en el puerto ${PORT}, DB_HOST=${DB_CONFIG.host}`);
});
