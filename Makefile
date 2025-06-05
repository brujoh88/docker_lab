.PHONY: help build up down logs clean test scale restart

help: ## Mostrar ayuda
	@echo "Comandos disponibles:"
	@echo "  build   - Construir imágenes"
	@echo "  up      - Iniciar servicios"
	@echo "  down    - Detener servicios"
	@echo "  logs    - Ver logs"
	@echo "  clean   - Limpiar contenedores y volúmenes"
	@echo "  test    - Ejecutar pruebas básicas"
	@echo "  test-scale  - Ver estado de contenedores"
	@echo "  scale   - Escalar aplicación a 3 instancias"
	@echo "  restart - Detener e iniciar servicios"
	@echo "  status  - Ver estado de contenedores"	

build: ## Construir todas las imágenes
	docker-compose build

up: ## Iniciar todos los servicios
	docker-compose up -d

down: ## Detener todos los servicios
	docker-compose down

logs: ## Ver logs de todos los servicios
	docker-compose logs -f

clean: ## Limpiar contenedores, imágenes y volúmenes
	docker-compose down -v
	docker system prune -f

test: ## Ejecutar pruebas básicas
	@echo "Esperando que los servicios estén listos..."
	@sleep 10
	@echo "Probando endpoints..."
	@echo "=== Endpoint principal ==="
	@curl -s http://localhost:8080/ | jq '.' || echo "Error: Aplicación no responde"
	@echo ""
	@echo "=== Health check ==="
	@curl -s http://localhost:8080/health | jq '.' || echo "Error: Health check falló"
	@echo ""
	@echo "=== Usuarios ==="
	@curl -s http://localhost:8080/users | jq '.' || echo "Error: Endpoint users no responde"

scale: ## Escalar aplicación a 3 instancias
	@echo "Escalando aplicación a 3 instancias..."
	docker-compose up --scale app=3 -d
	@echo "Esperando que las instancias estén listas..."
	@sleep 5
	@echo "Verificando instancias activas:"
	@docker-compose ps app

restart: ## Detener e iniciar servicios
	$(MAKE) down
	$(MAKE) up

status: ## Ver estado de contenedores
	@echo "=== Estado de contenedores ==="
	@docker-compose ps
	@echo ""
	@echo "=== Contenedores de la aplicación ==="
	@docker ps --filter "name=app" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

test-scale: ## Probar balanceador de carga con múltiples requests
	@echo "Realizando múltiples requests para ver diferentes contenedores..."
	@bash -c 'for i in {1..10}; do \
		echo "Request $$i:"; \
		curl -s http://localhost:8080/ | jq -r ".container_id"; \
		sleep 1; \
	done'