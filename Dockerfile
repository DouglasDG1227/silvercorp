# Etapa 1: Build da aplicação
FROM node:20 AS build

# Define o diretório de trabalho
WORKDIR /app

# Copia os arquivos de dependências primeiro (para melhor cache)
COPY package*.json ./

# Instala as dependências
RUN npm install

# Copia o restante do código
COPY . .

# Faz o build da aplicação
RUN npm run build

# Etapa 2: Servir o build com Nginx
FROM nginx:stable-alpine

# Remove o site padrão do nginx
RUN rm -rf /usr/share/nginx/html/*

# Copia o build da etapa anterior para o nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Copia um arquivo de configuração customizado para o nginx (opcional)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expõe a porta 80
EXPOSE 80

# Comando para rodar o nginx
CMD ["nginx", "-g", "daemon off;"]
