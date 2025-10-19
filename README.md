# Sistema de Monitoreo Híbrido: Prometheus, Grafana y Zabbix

Este proyecto implementa un sistema de monitoreo dual utilizando Docker. Combina las fortalezas de **Prometheus** (para métricas y series temporales) y **Zabbix** (para monitoreo de estado y alertas complejas).

## Componentes

- **Prometheus**: Recolecta y almacena métricas de servicios.
- **Grafana**: Visualiza las métricas de Prometheus en dashboards.
- **Node Exporter**: Expone métricas del hardware y SO del host para Prometheus.
- **Zabbix Server**: Backend que procesa y almacena los datos de los agentes Zabbix.
- **Zabbix Web**: Interfaz web para la configuración y visualización de Zabbix.
- **PostgreSQL**: Base de datos para Zabbix.

## Prerrequisitos

- **Docker**: [Instrucciones de instalación](https://docs.docker.com/get-docker/)
- **Docker Compose**: [Instrucciones de instalación](https://docs.docker.com/compose/install/)

## Uso

### Iniciar los servicios

Para iniciar todos los contenedores en segundo plano, ejecuta:

```bash
docker-compose up -d
```
La primera vez, Zabbix puede tardar unos minutos en inicializar la base de datos.

### Acceder a los servicios

- **Grafana**:
  - **URL**: [http://localhost:3000](http://localhost:3000)
  - Las credenciales de acceso son las que definiste en el archivo `.env`.

- **Prometheus**:
  - **URL**: [http://localhost:9090](http://localhost:9090)
  - Para verificar los objetivos, ve a **Status > Targets**.

- **Zabbix**:
  - **URL**: [http://localhost:8080](http://localhost:8080)
  - **Usuario por defecto**: `Admin`
  - **Contraseña por defecto**: `zabbix`

### Detener los servicios

Para detener todos los contenedores:

```bash
docker-compose down
```
Para detener y eliminar los volúmenes de datos (¡se perderán todos los datos!):
```bash
docker-compose down -v
```

## Notas sobre Compatibilidad

- El dashboard de Grafana para **Node Exporter** está optimizado para Linux. En Windows o macOS, es normal que algunos paneles aparezcan vacíos.
- Para monitorear un host con **Zabbix**, necesitarás instalar un [Agente de Zabbix](https://www.zabbix.com/download_agents) en la máquina objetivo y configurarla en la interfaz web de Zabbix para que apunte a la IP de tu servidor Zabbix.

