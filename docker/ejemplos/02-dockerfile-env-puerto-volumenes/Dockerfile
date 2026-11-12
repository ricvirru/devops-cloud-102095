# Imagen base liviana con Node ya instalado
FROM node:20-alpine

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Variables de entorno por defecto — se pueden sobreescribir con -e al correr el contenedor
ENV APP_MESSAGE="Hola Coderhouse"
ENV APP_PORT=3000

# Copiamos el código de la app
COPY app/ .

# Documenta qué puerto usa el contenedor (no lo publica por sí solo, ver -p en docker run)
EXPOSE 3000

# Comando que se ejecuta al iniciar el contenedor
CMD ["node", "server.js"]
