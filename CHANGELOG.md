# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [2.0.0] - 2025-10-19

### Añadido
- **AlertManager v0.27.0** para gestión centralizada de alertas
- **cAdvisor v0.49.1** para monitoreo de contenedores Docker
- **Zabbix Agent v7.0** para monitoreo del propio servidor
- Sistema completo de alertas con 20+ reglas predefinidas:
  - Alertas de sistema (CPU, memoria, disco, red)
  - Alertas de contenedores
  - Alertas de Prometheus y servicios
- Recording rules para optimización de queries
- Health checks en todos los servicios
- Redes Docker separadas (monitoring y zabbix)
- Configuración de seguridad mejorada (`no-new-privileges`)
- Auto-provisioning de datasources en Grafana
- Auto-provisioning de dashboards en Grafana
- Plugin de Zabbix para Grafana
- Directorios para scripts personalizados de Zabbix
- Archivo `.env.example` con documentación completa
- `.gitignore` mejorado
- `Makefile` con comandos útiles
- Documentación exhaustiva en README

- CHANGELOG estructurado

### Cambiado
- **Prometheus**: Actualizado a v2.54.1 (desde latest)
- **Grafana**: Actualizado a v11.2.2 (desde latest)
- **Zabbix Server**: Actualizado a v7.0-alpine (desde latest)
- **Zabbix Web**: Actualizado a v7.0-alpine (desde latest)
- **PostgreSQL**: Actualizado a v16.4-alpine (desde v16)
- **Node Exporter**: Actualizado a v1.8.2 (desde latest)
- Configuración de Prometheus mejorada con:
  - External labels
  - Configuración de AlertManager
  - Múltiples scrape configs
  - Metric relabeling
  - Configuración de retención optimizada
- Configuración de docker-compose con version explícita (3.8)
- Volúmenes con driver explícito
  - Depends_on con health checks
  - Variables de entorno con valores por defecto

### Mejorado
- Arquitectura del sistema más robusta y escalable
- Mejor separación de responsabilidades con redes dedicadas
- Performance optimizado con recording rules
- Documentación profesional con badges y diagramas
- Troubleshooting exhaustivo
- Guías de mejores prácticas
- Instrucciones de instalación paso a paso
- Sistema de backups documentado

### Seguridad
- Contraseñas configurables vía variables de entorno
- Archivo .env excluido de git
- Opciones de seguridad de contenedores
- Recomendaciones de seguridad en documentación

### Documentación
- README completamente reescrito con:
  - Tabla de contenidos
  - Badges informativos
  - Diagrama de arquitectura
  - Tablas de componentes y versiones
  - Sección de troubleshooting
  - Guía de contribución
  - Recursos adicionales
- Comentarios mejorados en archivos de configuración
- Ejemplos de personalización

## [1.0.0] - 2024-XX-XX

### Añadido
- Versión inicial del sistema
- Stack básico de Prometheus + Grafana + Zabbix
- Docker Compose básico
- Configuración inicial de servicios

---

**Leyenda de Cambios:**
- Añadido: Nuevas características
- Cambiado: Cambios en funcionalidad existente
- Mejorado: Mejoras sin cambios funcionales
- Seguridad: Mejoras de seguridad
- Corregido: Corrección de errores
- Documentación: Solo cambios en documentación
- Deprecado: Características que serán removidas
- Removido: Características removidas
