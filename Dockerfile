# Etapa 1: Build da aplicação
FROM node:20 AS build

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia apenas os arquivos de dependências primeiro (para aproveitar cache)
COPY package*.json ./

# Instala dependências
RUN npm install

# Copia o restante do código da aplicação
COPY . .

# Gera os arquivos de produção
RUN npm run build


# Etapa 2: Servir os arquivos com Nginx
FROM nginx:stable-alpine

# Remove arquivos padrão do Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copia os arquivos de build para o diretório padrão do Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Copia configuração customizada do Nginx (opcional, se você tiver um nginx.conf)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expõe a porta 80 para o container
EXPOSE 80

# Comando de inicialização
CMD ["nginx", "-g", "daemon off;"]
