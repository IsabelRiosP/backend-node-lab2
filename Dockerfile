# Stage 1: instalar dependencias y ejecutar pruebas

# Usar imagen base para app node, llamarla "build"
FROM node:20-alpine AS build

# Definir directorio de trabajo para la aplicacion
WORKDIR /app

# Instalar dependencias
COPY package*.json ./
RUN npm install

# Copiar el resto de la aplicacion
COPY . .

# Correr pruebas
RUN npm run test
RUN npm run test:cov

# Construir la aplicacion
RUN npm run build

# Stage 2: Usar dependencias resueltas y codigo probado en "build"
FROM node:20-alpine

WORKDIR /app

COPY --from=build /app/*.json ./
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules

# Exponer el puerto donde correra la aplicacion
EXPOSE 4000

# Ejecutar la aplicacion
CMD [ "npm", "run", "start:prod" ]
