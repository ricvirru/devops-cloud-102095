# Ejemplo 2 — Dockerfile propio: variables de entorno, puerto y volúmenes

Objetivo: escribir un Dockerfile desde cero para una app chiquita, y usar ese mismo
contenedor para ver en la práctica: `ENV`, `EXPOSE`/`-p`, bind mounts y volúmenes
nombrados.

La app (`app/server.js`) es un servidor HTTP sin dependencias: devuelve un mensaje
configurable y guarda cada visita en `/app/data/visitas.log`.

## Archivos

```
02-dockerfile-env-puerto-volumenes/
├── Dockerfile
├── .dockerignore
└── app/
    └── server.js
```

## 1. Build de la imagen

```bash
cd 02-dockerfile-env-puerto-volumenes
docker build -t env-demo:1.0 .
```

## 2. Correrlo con los valores por defecto

```bash
docker run -d --name env-demo -p 8080:3000 env-demo:1.0
curl http://localhost:8080
```

## 3. Sobreescribir las variables de entorno con `-e`

```bash
docker run -d --name env-demo-custom -p 8081:3000 \
  -e APP_MESSAGE="Hola clase de Docker" \
  env-demo:1.0

curl http://localhost:8081
```

El valor de `-e` pisa al `ENV` del Dockerfile. Confirmalo también mirando la
variable desde adentro del contenedor:

```bash
docker exec env-demo-custom printenv APP_MESSAGE
```

## 4. Bind mount — ver el log reflejado en tu máquina en vivo

```bash
mkdir -p data-bind

docker run -d --name env-demo-bind -p 8082:3000 \
  -v "$(pwd)/data-bind:/app/data" \
  env-demo:1.0

curl http://localhost:8082
curl http://localhost:8082
cat data-bind/visitas.log
```

El archivo `visitas.log` aparece directamente en tu carpeta `data-bind/`, porque
`-v "$(pwd)/data-bind:/app/data"` apunta a una carpeta específica de tu máquina
(bind mount). Ideal para desarrollo: podés editar o inspeccionar esos archivos sin
entrar al contenedor.

## 5. Volumen nombrado — para datos persistentes gestionados por Docker

```bash
docker volume create datos-app

docker run -d --name env-demo-vol -p 8083:3000 \
  -v datos-app:/app/data \
  env-demo:1.0

curl http://localhost:8083

docker volume inspect datos-app
docker exec env-demo-vol cat /app/data/visitas.log
```

A diferencia del bind mount, no elegís vos la carpeta del host: Docker la gestiona
en su propio almacenamiento (`docker volume inspect` te muestra dónde). Es la
opción recomendada para datos que tienen que sobrevivir aunque borres el
contenedor — por ejemplo, el datafile de una base de datos.

Probalo: borrá el contenedor y levantá uno nuevo con el mismo volumen — los datos
siguen ahí.

```bash
docker rm -f env-demo-vol
docker run -d --name env-demo-vol-2 -p 8083:3000 -v datos-app:/app/data env-demo:1.0
docker exec env-demo-vol-2 cat /app/data/visitas.log
```

## 6. Logs y limpieza

```bash
docker logs env-demo
docker logs env-demo-custom
docker rm -f env-demo env-demo-custom env-demo-bind env-demo-vol-2
docker volume rm datos-app
```
