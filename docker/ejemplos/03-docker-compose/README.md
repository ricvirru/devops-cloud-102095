# Ejemplo 3 — Docker Compose: app + Postgres

Objetivo: levantar una app conectada a una base de datos usando `docker-compose.yml`,
y después armar exactamente lo mismo a mano, comando por comando, para que quede
clara la equivalencia (compose no hace nada "mágico" — declara lo mismo que harías
con `docker run`, `docker network` y `docker volume`).

## Archivos

```
03-docker-compose/
├── docker-compose.yml
└── app/
    ├── Dockerfile
    ├── package.json
    └── server.js
```

## Parte A — Con Docker Compose

### 1. Levantar todo

```bash
cd 03-docker-compose
docker compose up -d --build
```

### 2. Ver estado y logs

```bash
docker compose ps
docker compose logs -f app
```

### 3. Probar la app

```bash
curl http://localhost:3000
curl http://localhost:3000
curl http://localhost:3000
```

### 4. Confirmar que los datos persisten

```bash
docker compose down        # baja los contenedores, el volumen db_data queda
docker compose up -d       # los levanta de nuevo
curl http://localhost:3000 # el contador sigue donde quedó, no vuelve a 1
```

Para borrar también los datos:

```bash
docker compose down -v
```

### Nota sobre `depends_on` + `healthcheck`

`depends_on` por sí solo solo controla el **orden de arranque** (que `db` arranque
antes que `app`), no espera a que Postgres esté realmente listo para aceptar
conexiones. Por eso el `docker-compose.yml` agrega un `healthcheck` en `db` y
`depends_on: db: condition: service_healthy` en `app` — así Compose espera a que
Postgres responda `pg_isready` antes de arrancar la app.

## Parte B — Lo mismo, pero a mano

Esto es exactamente lo que Compose hizo por vos arriba, escrito como comandos
sueltos. Primero bajá todo lo de la Parte A (`docker compose down -v`) para no
pisar nombres.

```bash
# 1. Red propia para que los contenedores se vean por nombre
docker network create appnet

# 2. Volumen para los datos de Postgres
docker volume create db_data

# 3. Base de datos
docker run -d --name db \
  --network appnet \
  -e POSTGRES_USER=coder \
  -e POSTGRES_PASSWORD=coder123 \
  -e POSTGRES_DB=clase_docker \
  -v db_data:/var/lib/postgresql/data \
  postgres:16-alpine

# 4. Imagen de la app (reusamos el mismo Dockerfile)
docker build -t compose-demo-app ./app

# 5. Esperá unos segundos a que Postgres termine de inicializar, luego:
docker run -d --name app \
  --network appnet \
  -p 3000:3000 \
  -e DB_HOST=db \
  -e DB_PORT=5432 \
  -e DB_USER=coder \
  -e DB_PASSWORD=coder123 \
  -e DB_NAME=clase_docker \
  compose-demo-app

curl http://localhost:3000
```

Compará: mismo puerto expuesto (`-p 3000:3000` ↔ `ports:`), mismo volumen
(`-v db_data:...` ↔ `volumes:`), mismas variables de entorno
(`-e DB_HOST=db...` ↔ `environment:`), misma red para que `app` encuentre a `db`
por nombre (`--network appnet` ↔ `networks:`). La diferencia es que acá tuviste
que escribir y ordenar cada paso vos mismo, y repetirlo cada vez; con
`docker-compose.yml` queda declarado una sola vez y versionado en el repo.

Limpieza de la parte B:

```bash
docker rm -f app db
docker network rm appnet
docker volume rm db_data
```
