# Etapa 1: Usar uma imagem base com o Nginx
FROM nginx:alpine

# Etapa 2: Copiar os arquivos de build do Flutter para o Nginx
COPY build/web /usr/share/nginx/html

# Etapa 3: Expor a porta 80 para acessar o app no navegador
EXPOSE 80

# Etapa 4: Rodar o Nginx para servir os arquivos
CMD ["nginx", "-g", "daemon off;"]
