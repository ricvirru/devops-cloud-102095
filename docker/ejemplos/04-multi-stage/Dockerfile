# ---- etapa 1: build ----
# Esta etapa tiene TypeScript, los devDependencies y el código fuente completo.
# Todo esto NO va a existir en la imagen final.
FROM node:20 AS build
WORKDIR /app
COPY package*.json tsconfig.json ./
RUN npm install
COPY src ./src
RUN npm run build
# En este punto /app/dist tiene el JS ya compilado (helper.js, server.js)

# ---- etapa 2: runtime ----
# Arranca de una imagen limpia y liviana. Copia SOLO el resultado de la etapa
# anterior (--from=build) -- nunca instala TypeScript ni copia el código .ts.
FROM node:20-alpine AS runtime
WORKDIR /app
COPY --from=build /app/dist ./dist
EXPOSE 3000
CMD ["node", "dist/server.js"]
