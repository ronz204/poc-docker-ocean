# 🐳 Docker Ocean - Proof of Concept

Proyecto de prueba de concepto para arquitectura Docker multi-entorno con Bun + Elysia y PostgreSQL.

## 📋 Tabla de Contenidos

- [Descripción](#-descripción)
- [Tecnologías](#-tecnologías)
- [Arquitectura Docker](#-arquitectura-docker)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Entornos](#-entornos)
- [Comandos Disponibles](#-comandos-disponibles)
- [Configuración](#-configuración)

---

## 📝 Descripción

Este proyecto implementa una arquitectura Docker modular utilizando Docker Compose con configuración multi-archivo. Permite gestionar diferentes entornos (desarrollo y producción) con configuraciones optimizadas para cada uno, manteniendo una base compartida.

---

## 🛠️ Tecnologías

- **Runtime**: [Bun](https://bun.sh/) 1.3.5
- **Framework**: [Elysia](https://elysiajs.com/)
- **Base de Datos**: PostgreSQL 15 Alpine
- **Contenedores**: Docker + Docker Compose
- **Build Tool**: Make

---

## 🏗️ Arquitectura Docker

### Archivos de Configuración

#### Nivel Raíz
- **`compose.base.yml`**: Define recursos compartidos (volumes, networks)
- **`compose.dev.yml`**: Orquestador del entorno de desarrollo
- **`compose.prod.yml`**: Orquestador del entorno de producción

#### Servicios (Include)
- **`server/compose.base.yml`**: Configuración base del servicio Elysia
- **`server/compose.dev.yml`**: Override para desarrollo
- **`server/compose.prod.yml`**: Override para producción
- **`docker/database/compose.dev.yml`**: PostgreSQL para desarrollo
- **`docker/database/compose.prod.yml`**: PostgreSQL para producción

### Recursos Compartidos

```yaml
# Volume persistente para PostgreSQL
ocean-data:
  driver: local
  name: ocean-data

# Red interna para comunicación entre servicios
ocean-network:
  driver: bridge
  name: ocean-network
```

### Dockerfile Multi-Stage

El proyecto utiliza un Dockerfile optimizado con las siguientes etapas:

| Stage | Base | Propósito |
|-------|------|-----------|
| `base` | `oven/bun:1.3.5-alpine` | Imagen base con Bun |
| `dependencies` | `base` | Instalación de dependencias |
| `development` | `dependencies` | Ejecución en desarrollo con Bun |
| `building` | `dependencies` | Compilación del binario |
| `production` | `alpine:3.23` | Imagen optimizada con binario standalone |

**Optimizaciones de producción:**
- Usuario no-root (`oceanuser:oceangroup`)
- Imagen Alpine minimalista
- Binario compilado standalone
- Solo librerías esenciales (`libstdc++`, `libgcc`)

---

## 📁 Estructura del Proyecto

```
poc-docker-ocean/
├── compose.base.yml          # Volumes y networks compartidos
├── compose.dev.yml           # Orquestador desarrollo
├── compose.prod.yml          # Orquestador producción
├── Makefile                  # Comandos de gestión
├── README.md                 # Este archivo
│
├── docker/
│   └── database/
│       ├── compose.dev.yml   # PostgreSQL desarrollo
│       └── compose.prod.yml  # PostgreSQL producción
│
└── server/
    ├── compose.base.yml      # Config base Elysia
    ├── compose.dev.yml       # Override desarrollo
    ├── compose.prod.yml      # Override producción
    ├── dockerfile            # Multi-stage build
    ├── package.json
    ├── tsconfig.json
    └── source/
        └── Entrypoint.ts
```

---

## 🚀 Entornos

### 🛠️ Desarrollo

#### Características
- **Project name**: `ocean-dev`
- **Container name**: `elysia-dev`
- **Build target**: `development`
- **Runtime**: Bun directo (hot reload nativo)
- **Restart policy**: `unless-stopped`
- **Port**: `3000:3000`
- **NODE_ENV**: `development`

#### Optimizaciones
- ✅ Hot reload automático con Bun
- ✅ Logs detallados
- ✅ Sin health checks (debug más sencillo)
- ✅ Usuario Bun estándar

#### Base de Datos
- **Image**: `postgres:15-alpine`
- **Container**: `postgres`
- **Database**: `oceandb`
- **User**: `oceanuser`
- **Password**: `oceanpass123`
- **Volume**: `ocean-data` (persistente)

#### Comandos
```bash
make up-dev      # Levantar entorno
make build-dev   # Rebuild y levantar
make down-dev    # Detener y limpiar
```

---

### 🚀 Producción

#### Características
- **Project name**: `ocean-prod`
- **Container name**: `elysia-prod`
- **Build target**: `production`
- **Runtime**: Binario compilado standalone
- **Restart policy**: `unless-stopped`
- **Port**: `3000:3000`
- **NODE_ENV**: `production`

#### Optimizaciones
- ✅ Health check con reintentos
- ✅ Imagen Alpine minimalista
- ✅ Usuario no-root (`oceanuser`)
- ✅ Binario compilado (sin Bun runtime)
- ✅ Solo librerías esenciales

#### Health Check
```yaml
test: curl -f http://localhost:3000/health
interval: 30s
timeout: 10s
retries: 3
start_period: 10s
```

#### Base de Datos
- **Image**: `postgres:15-alpine`
- **Container**: `postgres`
- **Database**: `oceandb`
- **User**: `oceanuser`
- **Password**: `oceanpass123`
- **Volume**: `ocean-data` (persistente)

#### Comandos
```bash
make up-prod      # Levantar entorno
make build-prod   # Rebuild y levantar
make down-prod    # Detener y limpiar
```

---

## 📋 Comandos Disponibles

| Comando | Descripción |
|---------|-------------|
| `make up-dev` | Levanta el entorno de desarrollo |
| `make up-prod` | Levanta el entorno de producción |
| `make build-dev` | Reconstruye y levanta desarrollo |
| `make build-prod` | Reconstruye y levanta producción |
| `make down-dev` | Detiene y elimina contenedores dev |
| `make down-prod` | Detiene y elimina contenedores prod |

---

## ⚙️ Configuración

### Variables de Entorno

Las variables de entorno para PostgreSQL se pueden personalizar:

```bash
POSTGRES_DB=oceandb
POSTGRES_USER=oceanuser
POSTGRES_PASSWORD=oceanpass123
```

### Servicios

#### Elysia Server
- **Puerto**: 3000
- **Network**: ocean-network
- **Health endpoint**: `/health` (solo prod)

#### PostgreSQL
- **Puerto interno**: 5432
- **Network**: ocean-network
- **Volume**: ocean-data (persistente entre reinicios)

---

## 🔄 Diferencias entre Entornos

| Aspecto | Development | Production |
|---------|-------------|------------|
| **Project Name** | `ocean-dev` | `ocean-prod` |
| **Container** | `elysia-dev` | `elysia-prod` |
| **Build Target** | `development` | `production` |
| **Runtime** | Bun 1.3.5 | Binario standalone |
| **Base Image** | `oven/bun:1.3.5-alpine` | `alpine:3.23` |
| **Hot Reload** | ✅ Sí (Bun nativo) | ❌ No |
| **Health Check** | ❌ No | ✅ Sí |
| **User** | `bun` | `oceanuser` (non-root) |
| **Image Size** | ~90MB | ~30MB |
| **Restart Policy** | `unless-stopped` | `unless-stopped` |

---

## 💡 Notas Importantes

- **Volumen persistente**: La base de datos usa `ocean-data` que persiste entre reinicios
- **Network aislada**: Todos los servicios se comunican a través de `ocean-network`
- **Gestión independiente**: Los entornos dev y prod son completamente independientes
- **Health checks**: Solo producción implementa health checks para monitoreo
- **Usuarios no-root**: Producción usa usuarios sin privilegios por seguridad

---

## 📚 Documentación Adicional

- [Detalles de Entornos](docker/ENVIRONMENTS.md)
- [Archivos Docker Antiguos](prompts/OLD_DOCKER_FILES.MD)

---

**Desarrollado con 🐳 Docker + ⚡ Bun + 🦊 Elysia**