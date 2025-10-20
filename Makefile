# Makefile para Sistema de Monitoreo

.PHONY: help start stop restart logs clean backup restore health

# Variables
COMPOSE := docker-compose
BACKUP_DIR := ./backups
TIMESTAMP := $(shell date +%Y%m%d_%H%M%S)

help: ## Mostrar esta ayuda
	@echo "Sistema de Monitoreo - Comandos disponibles:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

start: ## Iniciar todos los servicios
	@echo "Iniciando servicios..."
	$(COMPOSE) up -d
	@echo "Servicios iniciados. Ejecuta 'make health' para verificar el estado."

stop: ## Detener todos los servicios
	@echo "Deteniendo servicios..."
	$(COMPOSE) down
	@echo "Servicios detenidos."

restart: ## Reiniciar todos los servicios
	@echo "Reiniciando servicios..."
	$(COMPOSE) restart
	@echo "Servicios reiniciados."

logs: ## Ver logs de todos los servicios
	$(COMPOSE) logs -f

logs-prometheus: ## Ver logs de Prometheus
	$(COMPOSE) logs -f prometheus

logs-grafana: ## Ver logs de Grafana
	$(COMPOSE) logs -f grafana

logs-zabbix: ## Ver logs de Zabbix
	$(COMPOSE) logs -f zabbix-server zabbix-web

health: ## Verificar el estado de los servicios
	@echo "Verificando estado de los servicios..."
	@$(COMPOSE) ps

clean: ## Detener y eliminar contenedores y volúmenes (¡ELIMINA DATOS!)
	@echo "¿Estás seguro? Esto eliminará TODOS LOS DATOS. [y/N] " && read ans && [ $${ans:-N} = y ]
	$(COMPOSE) down -v
	@echo "Contenedores y volúmenes eliminados."

backup: ## Crear backup de configuraciones
	@echo "Creando backup..."
	@mkdir -p $(BACKUP_DIR)
	@tar -czf $(BACKUP_DIR)/config-backup-$(TIMESTAMP).tar.gz \
		prometheus/ alertmanager/ grafana/ zabbix/ .env 2>/dev/null || true
	@echo "Backup creado en: $(BACKUP_DIR)/config-backup-$(TIMESTAMP).tar.gz"

backup-volumes: ## Crear backup de volúmenes de datos
	@echo "Creando backup de volúmenes..."
	@mkdir -p $(BACKUP_DIR)
	@$(COMPOSE) run --rm -v sistema-monitoreo_prometheus_data:/data \
		-v $(shell pwd)/$(BACKUP_DIR):/backup alpine \
		tar -czf /backup/prometheus-data-$(TIMESTAMP).tar.gz /data
	@$(COMPOSE) run --rm -v sistema-monitoreo_grafana_data:/data \
		-v $(shell pwd)/$(BACKUP_DIR):/backup alpine \
		tar -czf /backup/grafana-data-$(TIMESTAMP).tar.gz /data
	@echo "Backups de volúmenes creados en: $(BACKUP_DIR)/"

update: ## Actualizar imágenes de contenedores
	@echo "Actualizando imágenes..."
	$(COMPOSE) pull
	@echo "Imágenes actualizadas. Ejecuta 'make restart' para aplicar cambios."

reload-prometheus: ## Recargar configuración de Prometheus sin reiniciar
	@echo "Recargando configuración de Prometheus..."
	@curl -X POST http://localhost:9090/-/reload || echo "Error: asegúrate de que Prometheus está corriendo"

validate: ## Validar configuración de docker-compose
	@echo "Validando configuración..."
	$(COMPOSE) config --quiet
	@echo "Configuración válida."

env-setup: ## Crear archivo .env desde .env.example
	@if [ -f .env ]; then \
		echo "El archivo .env ya existe. ¿Sobrescribir? [y/N] " && read ans && [ $${ans:-N} = y ] && cp .env.example .env; \
	else \
		cp .env.example .env; \
		echo "Archivo .env creado. Edítalo antes de iniciar los servicios."; \
	fi

prune: ## Limpiar recursos no utilizados de Docker
	@echo "Limpiando recursos de Docker..."
	docker system prune -f
	@echo "Recursos limpiados."
