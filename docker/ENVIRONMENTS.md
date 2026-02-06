### Entornos Docker

Este proyecto utiliza Docker Compose con configuración multi-archivo para gestionar diferentes entornos.

### 🏗️ Arquitectura de Archivos

### Archivo Base
- **`compose.yml`**: Configuración compartida entre todos los entornos. Define volumes, networks y hace include de los servicios base (server + database).

### Servicios Base (Include)
- **`server/compose.yml`**: Configuración base del servicio Elysia (puerto 3000, network, restart policy).
- **`docker/database/compose.yml`**: Configuración de PostgreSQL compartida entre entornos.

### Entornos (Overrides)
- **`docker/compose.dev.yml`**: Sobrescribe configuración para desarrollo.
- **`docker/compose.prod.yml`**: Sobrescribe configuración para producción.

---

### 🛠️ Entorno de Desarrollo

### Características
- **Container name**: `elysia-dev`
- **Build target**: `development`
- **Hot reload**: Activado mediante volumen montado de código fuente
- **Restart policy**: `no` (para debugging más fácil)
- **Variables**: `NODE_ENV=development`

### Optimizaciones dev
- Monta `server/source` como volumen read-only
- No reinicia automáticamente el contenedor
- Ideal para desarrollo local con cambios en tiempo real

### Uso
```bash
make dev        # Levantar entorno
make build-dev  # Rebuild contenedor
```

---

### 🚀 Entorno de Producción

### Características
- **Container name**: `elysia-prod`
- **Build target**: `production`
- **Hot reload**: Desactivado (imagen optimizada)
- **Restart policy**: `always` (alta disponibilidad)
- **Variables**: `NODE_ENV=production`
- **Health checks**: Configurado con endpoint `/health`

### Optimizaciones prod
- Health check cada 30s con 3 reintentos
- Reinicia automáticamente en caso de fallo
- Sin volúmenes montados (imagen standalone)
- Período de inicio de 10s antes de health checks

### Uso
```bash
make prod        # Levantar entorno
make build-prod  # Rebuild contenedor
```

---

### 📋 Comandos Disponibles

| Comando | Descripción |
|---------|-------------|
| `make dev` | Levanta entorno de desarrollo |
| `make prod` | Levanta entorno de producción |
| `make build-dev` | Construye imagen de desarrollo |
| `make build-prod` | Construye imagen de producción |
| `make down` | Detiene todos los contenedores |
| `make ps` | Lista contenedores activos |
| `make clean` | Detiene y elimina volúmenes |

---

### 🔄 Diferencias Clave

| Aspecto | Development | Production |
|---------|-------------|------------|
| Container | `elysia-dev` | `elysia-prod` |
| Build Target | `development` | `production` |
| Hot Reload | ✅ Sí | ❌ No |
| Restart | ❌ No | ✅ Always |
| Health Check | ❌ No | ✅ Sí |
| Source Mount | ✅ Volumen | ❌ Baked-in |
| NODE_ENV | `development` | `production` |

---

### 💡 Notas Importantes

- **No mezclar entornos**: Siempre baja con `make down` antes de cambiar de entorno
- **Rebuilds**: Después de cambios en Dockerfile, usa `make build-dev` o `make build-prod`
- **Volúmenes persistentes**: La base de datos usa el volumen `ocean-data` compartido entre entornos
- **Network**: Todos los servicios usan la red `ocean-network` para comunicarse