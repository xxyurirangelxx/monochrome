# Node Alpine -- multi-arch (amd64 + arm64)
FROM node:lts-alpine

WORKDIR /app

# wget é necessário para o healthcheck do Docker
RUN apk add --no-cache wget

# Copiar arquivos de pacotes primeiro para cache
COPY package.json package-lock.json ./

# Instalar dependências
RUN npm install

# Copiar o restante do projeto
COPY . .

# Build do projeto
RUN npm run build

# Expor porta do Vite preview
EXPOSE 8080

# Executar o projeto buildado
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0", "--port", "8080"]
