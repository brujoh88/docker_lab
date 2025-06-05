FROM nginx:alpine

# Copiar configuración personalizada
COPY nginx.conf /etc/nginx/nginx.conf

# Crear directorio para archivos estáticos
RUN mkdir -p /var/www/static

# Crear usuario nginx si no existe
RUN addgroup -g 101 -S nginx || true
RUN adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx || true

# Permisos
RUN chown -R nginx:nginx /var/cache/nginx
RUN chown -R nginx:nginx /var/log/nginx
RUN chown -R nginx:nginx /etc/nginx/conf.d
RUN touch /var/run/nginx.pid
RUN chown -R nginx:nginx /var/run/nginx.pid

# Exponer puerto
EXPOSE 80

# Comando por defecto
CMD ["nginx", "-g", "daemon off;"]