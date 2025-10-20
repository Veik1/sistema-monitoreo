# Sistema de Monitoreo Empresarial

Sistema de monitoreo completo y de nivel empresarial que combina **Prometheus**, **Grafana**, **Zabbix** y **AlertManager** para proporcionar observabilidad integral, visualización avanzada y gestión de alertas.

[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker)](https://www.docker.com/)
[![Prometheus](https://img.shields.io/badge/Prometheus-v2.54.1-E6522C?logo=prometheus)](https://prometheus.io/)
[![Grafana](https://img.shields.io/badge/Grafana-v11.2.2-F46800?logo=grafana)](https://grafana.com/)
[![Zabbix](https://img.shields.io/badge/Zabbix-v7.0-D20000?logo=zabbix)](https://www.zabbix.com/)

## Tabla de Contenidos

- [Características](#características)
- [Arquitectura](#arquitectura)
- [Componentes](#componentes)
- [Prerrequisitos](#prerrequisitos)
- [Instalación](#instalación)
- [Configuración](#configuración)
- [Uso](#uso)
- [Monitoreo Disponible](#monitoreo-disponible)
- [Alertas](#alertas)
- [Dashboards](#dashboards)
- [Mejores Prácticas](#mejores-prácticas)
- [Troubleshooting](#troubleshooting)
- [Contribuir](#contribuir)
- [Licencia](#licencia)

## Características

- **Monitoreo en tiempo real** de infraestructura y aplicaciones
- **Dashboards interactivos** con Grafana preconfigurando datasources automáticamente
- **Sistema de alertas robusto** con AlertManager y Zabbix
- **Monitoreo de contenedores Docker** con cAdvisor
- **Persistencia de datos** con volúmenes Docker
- **Seguridad mejorada** con health checks y opciones de seguridad
- **Redes aisladas** para mejor segmentación
- **Recording rules** para optimización de queries
- **Versiones específicas** para estabilidad y reproducibilidad
- **Auto-provisionamiento** de Grafana con datasources y dashboards

## Arquitectura

```
┌─────────────────────────────────────────────────────────────────┐
│                     Sistema de Monitoreo                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐    │
│  │  Prometheus  │────▶│ AlertManager │────▶│   Grafana    │    │
│  │   (Métricas) │     │   (Alertas)  │     │(Visualización)│    │
│  └──────┬───────┘     └──────────────┘     └──────┬───────┘    │
│         │                                           │             │
│         │ Scrape                          Datasources            │
│         ▼                                           ▼             │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐    │
│  │Node Exporter │     │   cAdvisor   │     │Zabbix Server │    │
│  │  (Sistema)   │     │(Contenedores)│     │  (Agentes)   │    │
│  └──────────────┘     └──────────────┘     └──────┬───────┘    │
│                                                     │             │
│                                              ┌──────▼───────┐    │
│                                              │  PostgreSQL  │    │
│                                              │  (Base Datos)│    │
│                                              └──────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

## Componentes

### Stack de Prometheus

| Componente | Versión | Puerto | Descripción |
|------------|---------|--------|-------------|
| **Prometheus** | v2.54.1 | 9090 | Motor de métricas y TSDB |
| **AlertManager** | v0.27.0 | 9093 | Gestión y enrutamiento de alertas |
| **Node Exporter** | v1.8.2 | 9100 | Métricas del sistema operativo |
| **cAdvisor** | v0.49.1 | 8081 | Métricas de contenedores Docker |
| **Grafana** | v11.2.2 | 3000 | Visualización y dashboards |

### Stack de Zabbix

| Componente | Versión | Puerto | Descripción |
|------------|---------|--------|-------------|
| **Zabbix Server** | 7.0 (Alpine) | 10051 | Backend de monitoreo |
| **Zabbix Web** | 7.0 (Alpine) | 8080/8443 | Interfaz web |
| **Zabbix Agent** | 7.0 (Alpine) | 10050 | Agente de monitoreo |
| **PostgreSQL** | 16.4 (Alpine) | 5432 | Base de datos |

## Prerrequisitos

- **Docker** >= 20.10 ([Guía de instalación](https://docs.docker.com/get-docker/))
- **Docker Compose** >= 2.0 ([Guía de instalación](https://docs.docker.com/compose/install/))
- **Mínimo 4GB RAM** disponible para contenedores
- **10GB de espacio en disco** para datos y logs

### Verificación de requisitos

```bash
# Verificar Docker
docker --version

# Verificar Docker Compose
docker-compose --version

# Verificar recursos disponibles
docker info | grep -E "CPUs|Total Memory"
```

## Instalación

### 1. Clonar o descargar el repositorio

```bash
git clone https://github.com/Veik1/sistema-monitoreo.git
cd sistema-monitoreo
```

### 2. Configurar variables de entorno

```bash
# Windows
copy .env.example .env

# Linux/Mac
cp .env.example .env
```

Edita el archivo `.env` y cambia las contraseñas por defecto:

```env
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=admin
POSTGRES_USER=zabbix
POSTGRES_PASSWORD=postgres
POSTGRES_DB=zabbix
ZBX_SERVER_NAME=Mi Sistema de Monitoreo
TZ=America/Buenos_Aires
```

### 3. Iniciar el sistema

```bash
docker-compose up -d
```

### 4. Verificar que los servicios estén corriendo

```bash
docker-compose ps
```

Todos los servicios deben mostrar estado **healthy** después de 1-2 minutos.

## Configuración

### Estructura de directorios

```
sistema-monitoreo/
├── docker-compose.yml          # Configuración de servicios
├── .env.example                # Plantilla de variables de entorno
├── .env                        # Variables de entorno (crear)
├── prometheus/
│   ├── prometheus.yml          # Configuración principal de Prometheus
│   ├── alerts/                 # Reglas de alertas
│   │   ├── node_exporter.yml   # Alertas del sistema
│   │   ├── containers.yml      # Alertas de contenedores
│   │   └── prometheus.yml      # Alertas de Prometheus
│   └── rules/                  # Recording rules
│       └── recording_rules.yml # Reglas de grabación
├── alertmanager/
│   └── alertmanager.yml        # Configuración de AlertManager
├── grafana/
│   ├── provisioning/
│   │   ├── datasources/        # Datasources automáticos
│   │   │   └── datasources.yml
│   │   └── dashboards/         # Configuración de dashboards
│   │       └── dashboards.yml
│   └── dashboards/             # Dashboards personalizados (JSON)
└── zabbix/
    ├── alertscripts/           # Scripts de alerta personalizados
    └── externalscripts/        # Scripts externos de Zabbix
```

### Personalización de Prometheus

Edita `prometheus/prometheus.yml` para añadir nuevos targets:

```yaml
scrape_configs:
  - job_name: 'mi-aplicacion'
    scrape_interval: 15s
    static_configs:
      - targets: ['mi-app:8080']
        labels:
          environment: 'production'
```

### Personalización de AlertManager

Edita `alertmanager/alertmanager.yml` para configurar notificaciones por email, Slack, etc.:

```yaml
receivers:
  - name: 'email-notifications'
    email_configs:
      - to: 'equipo@ejemplo.com'
        from: 'alertmanager@ejemplo.com'
        smarthost: 'smtp.gmail.com:587'
        auth_username: 'tu-email@gmail.com'
        auth_password: 'tu-app-password'
```

## Uso

### Acceso a las interfaces web

| Servicio | URL | Credenciales |
|----------|-----|--------------|
| **Grafana** | http://localhost:3000 | Ver archivo `.env` |
| **Prometheus** | http://localhost:9090 | Sin autenticación |
| **AlertManager** | http://localhost:9093 | Sin autenticación |
| **Zabbix** | http://localhost:8080 | Admin / zabbix |
| **cAdvisor** | http://localhost:8081 | Sin autenticación |

### Comandos útiles

```bash
# Ver logs de todos los servicios
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f prometheus

# Reiniciar un servicio
docker-compose restart prometheus

# Detener todos los servicios
docker-compose down

# Detener y eliminar volúmenes (¡PERDERÁS TODOS LOS DATOS!)
docker-compose down -v

# Ver estado de los servicios
docker-compose ps

# Recargar configuración de Prometheus (sin reiniciar)
curl -X POST http://localhost:9090/-/reload
```

## Monitoreo Disponible

### Métricas del Sistema (Node Exporter)

- Uso de CPU (por core y total)
- Uso de memoria (RAM, swap, cache)
- Uso de disco (espacio, I/O, inodos)
- Red (tráfico, errores, paquetes)
- Load average del sistema
- Procesos y contextos de cambio
- File descriptors y sockets

### Métricas de Contenedores (cAdvisor)

- Uso de CPU por contenedor
- Uso de memoria por contenedor
- Red por contenedor
- I/O de disco por contenedor
- Estado de contenedores

### Métricas de Prometheus

- Estado de targets
- Duración de scrapes
- Tamaño del TSDB
- Número de series temporales
- Performance de queries

## Alertas

### Alertas configuradas

#### Sistema (Node Exporter)

- **NodeDown**: Nodo no responde (>2min) - CRITICAL
- **HighCPUUsage**: CPU >80% (>5min) - WARNING
- **CriticalCPUUsage**: CPU >95% (>2min) - CRITICAL
- **HighMemoryUsage**: Memoria >80% (>5min) - WARNING
- **CriticalMemoryUsage**: Memoria >95% (>2min) - CRITICAL
- **DiskSpaceLow**: Disco <20% (>5min) - WARNING
- **DiskSpaceCritical**: Disco <10% (>2min) - CRITICAL
- **HighSystemLoad**: Load >0.8 por CPU (>10min) - WARNING
- **DiskWillFillIn4Hours**: Predicción de disco lleno - WARNING

#### Contenedores (cAdvisor)

- **ContainerDown**: Contenedor no visto (>1min) - WARNING
- **ContainerHighCPU**: CPU >80% (>5min) - WARNING
- **ContainerHighMemory**: Memoria >80% (>5min) - WARNING
- **ContainerFrequentRestarts**: >5 reinicios/hora - WARNING

#### Prometheus

- **PrometheusTargetDown**: Target no responde (>2min) - CRITICAL
- **PrometheusMultipleTargetsDown**: Múltiples targets caídos - CRITICAL
- **PrometheusHighMemory**: Memoria >8GB (>5min) - WARNING
- **PrometheusTSDBReloadsFailing**: Fallos en TSDB - CRITICAL
- **PrometheusHighCardinality**: Alta cardinalidad detectada - WARNING

### Severidades

- **critical**: Requiere atención inmediata
- **warning**: Requiere atención pronto
- **info**: Informativo

## Dashboards

### Dashboards recomendados de Grafana

Importa estos dashboards desde [Grafana.com](https://grafana.com/grafana/dashboards/):

- **Node Exporter Full**: ID `1860`
- **Docker Monitoring**: ID `893`
- **Prometheus Stats**: ID `3662`
- **cAdvisor**: ID `14282`
- **Zabbix**: Integrado con plugin `alexanderzobnin-zabbix-app`

### Importar dashboard

1. Ir a Grafana → Dashboards → Import
2. Ingresar el ID del dashboard
3. Seleccionar datasource "Prometheus"
4. Clic en "Import"

## Mejores Prácticas

### Seguridad

- Cambiar todas las contraseñas por defecto
- No exponer puertos innecesarios al exterior
- Usar HTTPS en producción (configurar reverse proxy)
- Implementar autenticación en Prometheus/AlertManager
- Revisar y actualizar imágenes regularmente

### Performance

- Ajustar `retention.time` según necesidad de retención
- Monitorear uso de recursos de Prometheus
- Usar recording rules para queries frecuentes
- Limitar cardinalidad de métricas
- Configurar scrape_interval apropiadamente

### Backups

```bash
# Backup de configuraciones
tar -czf backup-config-$(date +%Y%m%d).tar.gz \
  prometheus/ alertmanager/ grafana/ zabbix/ .env

# Backup de volúmenes
docker run --rm -v sistema-monitoreo_prometheus_data:/data \
  -v $(pwd):/backup alpine \
  tar -czf /backup/prometheus-data-$(date +%Y%m%d).tar.gz /data
```

### Monitoreo del monitoreo

- Configurar alertas para el stack de monitoreo
- Monitorear recursos de contenedores
- Revisar logs regularmente
- Verificar health checks

## Troubleshooting

### Problema: Contenedor no inicia

```bash
# Ver logs del contenedor
docker-compose logs nombre-del-servicio

# Ver eventos de Docker
docker events

# Verificar configuración
docker-compose config
```

### Problema: Prometheus no scrape targets

1. Verificar que el target esté accesible: `curl http://target:puerto/metrics`
2. Revisar configuración en `prometheus/prometheus.yml`
3. Verificar logs: `docker-compose logs prometheus`
4. Verificar targets en: http://localhost:9090/targets

### Problema: Grafana no muestra datos

1. Verificar datasource configurado correctamente
2. Comprobar que Prometheus tenga datos: http://localhost:9090/graph
3. Verificar que el rango de tiempo sea apropiado
4. Revisar queries en el dashboard

### Problema: AlertManager no envía notificaciones

1. Verificar configuración en `alertmanager/alertmanager.yml`
2. Probar envío manual desde la UI
3. Revisar logs: `docker-compose logs alertmanager`
4. Verificar que Prometheus apunte a AlertManager

### Problema: Zabbix no inicia

1. Esperar 2-3 minutos (inicialización de BD)
2. Verificar PostgreSQL: `docker-compose logs postgres-db`
3. Verificar conexión a BD en logs de Zabbix

### Problema: Permisos en volúmenes

```bash
# En Linux, puede ser necesario ajustar permisos
sudo chown -R 65534:65534 prometheus_data/
sudo chown -R 472:472 grafana_data/
```

## Contribuir

Las contribuciones son bienvenidas! Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT. Ver archivo `LICENSE` para más detalles.

---

## Recursos Adicionales

- [Documentación de Prometheus](https://prometheus.io/docs/)
- [Documentación de Grafana](https://grafana.com/docs/)
- [Documentación de Zabbix](https://www.zabbix.com/documentation/current/)
- [Documentación de AlertManager](https://prometheus.io/docs/alerting/latest/alertmanager/)
- [Best Practices de Prometheus](https://prometheus.io/docs/practices/naming/)

## Soporte

Si tienes problemas o preguntas:

1. Revisa la sección [Troubleshooting](#-troubleshooting)
2. Busca en [Issues](https://github.com/Veik1/sistema-monitoreo/issues)
3. Abre un nuevo Issue con detalles del problema

---

**Hecho para la comunidad de DevOps y SRE**

