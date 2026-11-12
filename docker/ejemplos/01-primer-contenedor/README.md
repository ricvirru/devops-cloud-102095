# Ejemplo 1 — Tu primer contenedor

Objetivo: descargar una imagen desde Docker Hub, levantar un contenedor a partir de
ella, y usar los comandos básicos para entrar y observarlo. No hace falta ningún
archivo propio para este ejemplo — todo se hace con la imagen pública `nginx`.

## 1. Descargar la imagen

```bash
docker pull nginx:alpine
```

## 2. Levantar un contenedor a partir de la imagen

```bash
docker run -d --name mi-primer-nginx -p 8080:80 nginx:alpine
```

Confirmá que está corriendo:

```bash
docker ps
```

## 3. Acceder a la aplicación

Abrí `http://localhost:8080` en el navegador, o:

```bash
curl http://localhost:8080
```

## 4. Acceder _al contenedor_ (no a la app, a la terminal de adentro)

```bash
docker exec -it mi-primer-nginx sh
```

```sh
ls /usr/share/nginx/html      # acá vive el index.html que viste en el navegador
cat /usr/share/nginx/html/index.html
ps aux                        # procesos corriendo dentro del contenedor
exit                          # salir de la shell (el contenedor sigue vivo)
```

## 5. Ver los logs

```bash
docker logs mi-primer-nginx
docker logs -f mi-primer-nginx   # -f para seguir en vivo (hacé otro curl en otra terminal y mirá cómo aparece la línea de acceso)
```

## 6. Inspeccionar el contenedor

```bash
docker inspect mi-primer-nginx
```

## 7. Detener y eliminar

```bash
docker stop mi-primer-nginx
docker rm mi-primer-nginx
```

O, para hacer ambas cosas de una, un contenedor que ya está corriendo y te interesa
solo probar algo rápido:

```bash
docker run --rm -it nginx:alpine sh
```
