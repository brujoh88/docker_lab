# Docker Lab - Virtualización vs Containerización

## 📋 Descripción del Proyecto

Este proyecto implementa una aplicación web escalable usando Docker para demostrar las ventajas de la containerización frente a la virtualización tradicional. La aplicación consta de un backend Node.js, un balanceador de carga Nginx y una base de datos MySQL, todos orquestados con Docker Compose.

## 🎯 Objetivos

- Demostrar escalado horizontal de aplicaciones containerizadas
- Implementar balanceado de carga con Nginx
- Comparar eficiencia de recursos entre virtualización y containerización
- Proporcionar un ejemplo práctico de arquitectura multi-contenedor

## 🏗️ Arquitectura

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│     Cliente     │────│  Nginx (Puerto   │────│   Node.js App   │
│   (Browser)     │    │     8080)        │    │   (Puerto 3000) │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │                        │
                                │                        │
                                └────────────────────────┼─────────┐
                                                         │         │
                                                  ┌─────────────────┐
                                                  │  MySQL Database │
                                                  │   (Puerto 3306) │
                                                  └─────────────────┘
```

### Componentes

1. **Aplicación Node.js**: Backend API con Express.js
2. **Nginx**: Proxy reverso y balanceador de carga
3. **MySQL**: Base de datos con datos de prueba
4. **Docker Network**: Red personalizada para comunicación entre contenedores

## 🚀 Inicio Rápido

### Prerrequisitos

- Docker Engine 20.x o superior
- Docker Compose 1.29 o superior
- Make (opcional, para comandos automatizados)

### Instalación y Ejecución

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/brujoh88/docker-lab
   cd docker-lab
   ```

2. **Construir y ejecutar los servicios**
   ```bash
   # Usando Make (recomendado)
   make build
   make up
   
   # O usando Docker Compose directamente
   docker-compose build
   docker-compose up -d
   ```

3. **Verificar que los servicios estén funcionando**
   ```bash
   make test
   # O manualmente
   curl http://localhost:8080/
   ```

## 📖 Comandos Disponibles

### Usando Make

```bash
make help          # Mostrar todos los comandos disponibles
make build         # Construir todas las imágenes
make up            # Iniciar todos los servicios
make down          # Detener todos los servicios
make logs          # Ver logs de todos los servicios
make clean         # Limpiar contenedores y volúmenes
make test          # Ejecutar pruebas básicas
make scale         # Escalar aplicación a 3 instancias
make restart       # Detener e iniciar servicios
make status        # Ver estado de contenedores
make test-scale    # Probar balanceador de carga
```

### Usando Docker Compose

```bash
# Servicios básicos
docker-compose up -d
docker-compose down
docker-compose logs -f

# Escalado
docker-compose up --scale app=3 -d
docker-compose ps
```

## 🔍 Endpoints de la API

| Endpoint | Método | Descripción |
|----------|--------|-------------|
| `/` | GET | Información general de la aplicación |
| `/health` | GET | Estado de salud del servicio |
| `/users` | GET | Lista de usuarios desde la base de datos |

### Ejemplo de Respuestas

**GET /** 
```json
{
  "message": "Docker Lab - Aplicación funcionando correctamente",
  "timestamp": "2025-06-03T10:30:00.000Z",
  "container_id": "abc123def456",
  "hostname": "abc123def456",
  "version": "1.0.0",
  "status": "active"
}
```

**GET /health**
```json
{
  "status": "healthy",
  "database": "connected",
  "uptime": 125.456,
  "memory": {
    "rss": 45678912,
    "heapTotal": 20971520,
    "heapUsed": 15728640
  },
  "container_id": "abc123def456",
  "hostname": "abc123def456"
}
```

## ⚖️ Escalado y Balanceado de Carga

### Escalar la Aplicación

```bash
# Escalar a 3 instancias
make scale

# Verificar instancias activas
docker-compose ps app
```

### Probar Balanceado de Carga

```bash
# Realizar múltiples requests para ver diferentes container IDs
make test-scale

# O manualmente
for i in {1..10}; do
  echo "Request $i:"
  curl -s http://localhost:8080/ | jq -r ".container_id"
  sleep 1
done
```

## 📊 Métricas de Rendimiento

### Consumo de Recursos

| Servicio | Memoria RAM | CPU | Tiempo de Inicio |
|----------|-------------|-----|------------------|
| Node.js App | ~22 MiB | <1% | 2-3 segundos |
| Nginx | ~4 MiB | <1% | 1-2 segundos |
| MySQL | ~360 MiB | <5% | 10-15 segundos |
| **Total** | **~385 MiB** | **<7%** | **15-20 segundos** |

### Comparación con Virtualización Tradicional

| Métrica | Containerización | Virtualización |
|---------|------------------|----------------|
| Memoria RAM | 385 MiB | ~6 GB (3 VMs) |
| Tiempo de inicio | 15-20 segundos | 3-5 minutos |
| Escalado | 8-12 segundos | 3-5 minutos |
| Eficiencia | 97% menos memoria | 6 GB (100%) |

## 🛠️ Configuración

### Variables de Entorno

Las siguientes variables se pueden configurar en `docker-compose.yml`:

```yaml
environment:
  - NODE_ENV=production
  - DB_HOST=mysql
  - DB_USER=root
  - DB_PASSWORD=password
  - DB_NAME=testdb
```

### Personalización de Red

La red Docker personalizada está configurada con:
- Subnet: 172.20.0.0/16
- Driver: bridge
- DNS interno habilitado

## 🐛 Resolución de Problemas

### Problemas Comunes

1. **Los servicios no se conectan**
   ```bash
   # Verificar que los contenedores estén en la misma red
   docker network ls
   docker network inspect docker-lab_app-network
   ```

2. **La base de datos no está lista**
   ```bash
   # Verificar health check de MySQL
   docker-compose logs mysql
   ```

3. **Nginx no encuentra los backends**
   ```bash
   # Verificar configuración DNS
   docker-compose exec nginx nslookup app
   ```

### Logs de Debugging

```bash
# Ver logs de todos los servicios
make logs

# Ver logs de un servicio específico
docker-compose logs app
docker-compose logs nginx
docker-compose logs mysql
```

## 📁 Estructura del Proyecto

```
docker-lab/
├── app/
│   ├── Dockerfile
│   ├── package.json
│   └── server.js
├── nginx/
│   ├── Dockerfile
│   └── nginx.conf
├── mysql/
│   └── init.sql
├── docker-compose.yml
├── Makefile
└── README.md
```

## 👥 Autores

- **Gustavo Hernan Tiseira** - Desarrollo de la aplicación Node.js y configuración de base de datos
- **Daiana Anahi Trejo** - Configuración de Docker Compose, setup de Nginx y documentación


## 🎓 Contexto Académico

Este proyecto fue desarrollado como Trabajo Integrador para la materia "Arquitectura y Sistemas Operativos" de la Tecnicatura Universitaria en Programación.

**Profesor**: Diego Lobos  
**Tutor**: Martín Aristiaran  
**Fecha de Entrega**: 05/06/2025

## 🔗 Referencias

- [Docker Documentation](https://docs.docker.com/get-started/)
- [Docker Compose Overview](https://docs.docker.com/compose/)
- [NGINX Load Balancing](https://docs.nginx.com/nginx/admin-guide/load-balancer/)
- [Node.js Documentation](https://nodejs.org/en/docs/)
- [Express.js Documentation](https://expressjs.com/)

---

## 🔗 link del video demostración
- [YouTube] ( https://youtu.be/S0fjS1JK7b4 )