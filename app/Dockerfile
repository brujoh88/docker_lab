FROM node:slim

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar dependencias
RUN npm install --only=production

# Copiar código fuente
COPY . .

# Crear usuario no-root para seguridad
RUN addgroup -gid 1001 -system nodejs
#Crea un usuario del sistema llamado nodejs
#con UID 1001 y lo asigna al grupo nodejs. Esto es una buena práctica
#para ejecutar aplicaciones dentro de contenedores Docker,
#ya que evita el uso del usuario root y mejora la seguridad.
RUN adduser --system --uid 1001 --ingroup nodejs nodejs


# Cambiar ownership del directorio
RUN chown -R nodejs:nodejs /app
USER nodejs

# Exponer puerto
EXPOSE 3000

# Comando de inicio
CMD ["node", "server.js"]
