# Ejemplo 4 — Multi-stage build

Objetivo: ver en la práctica por qué conviene separar "lo que compila" de "lo que
corre". La app está escrita en TypeScript; el Dockerfile multi-stage la compila en
una etapa y arma la imagen final solo con el JavaScript resultante — sin
TypeScript, sin devDependencies, sin el código fuente `.ts`.

## Archivos

```
04-multi-stage-build/
├── Dockerfile                  <- multi-stage (2 etapas)
├── Dockerfile.sin-multistage   <- la misma app, en una sola etapa (para comparar)
├── package.json
├── tsconfig.json
└── src/
    ├── server.ts
    └── helper.ts
```

## 1. Build con multi-stage

```bash
cd 04-multi-stage-build
docker build -t multistage-demo:1.0 .
```

Mirá el `Dockerfile`: tiene dos bloques `FROM`.

- **Etapa `build`** (`FROM node:20 AS build`): instala TypeScript (`npm install`,
  incluye devDependencies), copia `src/` y corre `npm run build`, que compila a
  `dist/`.
- **Etapa `runtime`** (`FROM node:20-alpine AS runtime`): arranca de una imagen
  nueva y liviana, y copia únicamente `/app/dist` desde la etapa anterior con
  `COPY --from=build`. Nunca instala TypeScript ni copia los `.ts`.

## 2. Correrlo y acceder

```bash
docker run -d --name multistage-demo -p 8080:3000 multistage-demo:1.0
curl http://localhost:8080
docker logs multistage-demo
```

## 3. Confirmar que la imagen final no tiene nada de la etapa de build

```bash
docker exec -it multistage-demo sh
```

Dentro del contenedor:

```sh
ls /app              # solo vas a ver "dist", nada de src/ ni node_modules
which tsc             # no existe -- TypeScript nunca llegó a esta imagen
cat dist/server.js    # el JS ya compilado
exit
```

## 4. Comparar tamaños contra la versión sin multi-stage

```bash
docker build -f Dockerfile.sin-multistage -t multistage-demo:sin-multistage .
docker images | grep multistage-demo
```

Vas a ver que `multistage-demo:1.0` (multi-stage, corre sobre `node:20-alpine`) pesa
sensiblemente menos que `multistage-demo:sin-multistage` (que arrastra `node:20`
completo + TypeScript + devDependencies + código fuente). Esa diferencia es
exactamente lo que se gana con multi-stage: menos superficie de ataque, menos
cosas innecesarias en producción, y transferencias más rápidas al desplegar.

## Limpieza

```bash
docker rm -f multistage-demo
docker rmi multistage-demo:1.0 multistage-demo:sin-multistage
```
