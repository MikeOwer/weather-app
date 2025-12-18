# 🌤️ Weather App - Frontend

Aplicación React con sistema de autenticación completo (Login/Signup) siguiendo buenas prácticas y arquitectura escalable.

## 🚀 Inicio Rápido

### Prerrequisitos
- Node.js >= 16
- Backend API corriendo en `http://localhost:3000`

### Instalación

```bash
# Instalar dependencias
npm install

# Ejecutar en modo desarrollo
npm run dev
```

La aplicación estará disponible en `http://localhost:5173`

## 📖 Uso

### 1. Crear una cuenta (Signup)
- Navega a la aplicación
- Serás redirigido automáticamente a `/login`
- Haz clic en "Regístrate"
- Completa el formulario con:
  - Nombre
  - Email
  - Contraseña (mínimo 6 caracteres)
  - Confirmar contraseña

### 2. Iniciar sesión (Login)
- Ingresa tu email y contraseña
- Haz clic en "Iniciar Sesión"

### 3. Sesión activa
- Después de autenticarte, verás la página principal
- El navbar mostrará tu nombre y email
- Tu sesión persistirá incluso si recargasla página

### 4. Ver el clima
- Haz clic en "Clima" en el navbar
- Verás una lista de ciudades con su clima actual
- Información mostrada:
  - Nombre de la ciudad
  - Temperatura actual
  - Condición climática con emoji

### 5. Ver pronóstico de 5 días
- En la lista de ciudades, haz clic en cualquier ciudad
- Verás el pronóstico de los próximos 5 días
- Información por día:
  - Fecha y día de la semana
  - Temperatura máxima y mínima
  - Condición climática con emoji
- Botón "Volver" para regresar a la lista

### 6. Cerrar sesión
- Haz clic en "Cerrar Sesión" en el navbar
- Serás redirigido a `/login`

## 🏗️ Arquitectura

### Estructura de Carpetas

```
src/
├── components/
│   ├── auth/         # Login y Signup
│   ├── common/       # Componentes reutilizables (Button, Input, Loading)
│   └── layout/       # Layout y Navbar
├── context/          # AuthContext (estado global)
├── pages/            # Páginas de la app
├── routes/           # Configuración de rutas y protección
├── services/         # Lógica HTTP y autenticación
│   ├── apiService.js    # Cliente HTTP genérico
│   └── authService.js   # Servicio de autenticación
├── App.jsx
└── main.jsx
```

### Tecnologías

- **React 19** - Framework UI
- **Vite** - Build tool y dev server
- **React Router DOM** - Navegación
- **Context API** - Estado global
- **CSS Vanilla** - Estilos

### Características Implementadas

✅ **Autenticación completa**
  - Signup con validación
  - Login con manejo de errores
  - Logout
  - Persistencia de sesión con localStorage

✅ **Visualización de clima**
  - Lista de ciudades con clima actual
  - Pronóstico de 5 días por ciudad
  - Información en tiempo real
  - Estados: loading, error, vacío
  - Cards visuales con emojis climáticos
  - Navegación fluida entre vistas

✅ **Arquitectura escalable**
  - Servicios separados (HTTP, Auth, Weather)
  - Context API para estado global
  - Componentes reutilizables
  - Rutas protegidas

✅ **UX/UI moderna**
  - Diseño limpio e intuitivo
  - Estados visuales (loading, error, success)
  - Responsive (mobile-friendly)
  - Validación en tiempo real
  - Navegación fluida entre vistas

✅ **Buenas prácticas**
  - Separación de responsabilidades
  - Código DRY y limpio
  - Manejo explícito de errores
  - Componentes componibles

## 🔌 API Endpoints Esperados

La aplicación consume los siguientes endpoints del backend:

### POST `/auth/register`
```json
// Request
{
  "name": "Juan Pérez",
  "email": "juan@example.com",
  "password": "password123"
}

// Response 200
{
  "token": "jwt_token_here",
  "user": {
    "id": 1,
    "name": "Juan Pérez",
    "email": "juan@example.com"
  }
}
```

### POST `/auth/login`
```json
// Request
{
  "email": "juan@example.com",
  "password": "password123"
}

// Response 200
{
  "token": "jwt_token_here",
  "user": {
    "id": 1,
    "name": "Juan Pérez",
    "email": "juan@example.com"
  }
}
```

### GET `/weather/current`
```json
// Headers
Authorization: Bearer <token>

// Response 200
{
  "weather": [
    {
      "city_name": "Guadalajara",
      "temperature": 22.5,
      "weather_condition": "Clear",
      "weather_description": "clear sky",
      "lat": 20.6737,
      "long": -103.344
    }
  ],
  "count": 1
}
```

### GET `/weather/days?lat=20.6737&lon=-103.344`
```json
// Headers
Authorization: Bearer <token>

// Response 200
[
  {
    "date": "2025-12-17",
    "temp_max": 23.5,
    "temp_min": 15.2,
    "weather_condition": "Rain",
    "weather_description": "light rain"
  },
  {
    "date": "2025-12-18",
    "temp_max": 25.1,
    "temp_min": 16.8,
    "weather_condition": "Clear",
    "weather_description": "clear sky"
  }
  // ... 3 días más
]
```

## 🛡️ Flujo de Autenticación

```
1. Usuario completa formulario de Login/Signup
2. Componente llama a useAuth() hook
3. AuthContext ejecuta authService.login/signup()
4. authService llama a apiService con credentials
5. apiService hace fetch a http://localhost:3000/auth/*
6. Si es exitoso:
   - Token y user se guardan en localStorage
   - Estado global se actualiza en AuthContext
   - Usuario es redirigido a página protegida
   - Navbar muestra información del usuario
```

## 🔒 Seguridad

### Token Management
- Token JWT guardado en `localStorage` con key `'token'`
- Incluido automáticamente en header `Authorization: Bearer <token>`
- Limpiado al hacer logout

### Protected Routes
Las rutas protegidas verifican:
1. Si el usuario está autenticado (`isAuthenticated`)
2. Si hay un token válido en localStorage
3. Si no está autenticado, redirige a `/login`

### Validación
- **Cliente**: Validación de formato y campos requeridos (UX)
- **Servidor**: Debe validar todos los datos (Seguridad)

## 🎨 Componentes Principales

### `<Login />` y `<Signup />`
- Formularios con validación en tiempo real
- Estados de loading y error
- Navegación entre pantallas
- Feedback visual inmediato

### `<Weather />`
- Lista de ciudades con clima actual
- Estados: loading, error, vacío
- Integración con weatherService
- Botón de reintentar en caso de error

### `<WeatherCard />`
- Card visual para cada ciudad
- Muestra temperatura, condición y emoji
- Hover effects
- Responsive design

### `<Navbar />`
- Muestra avatar con inicial del nombre
- Información del usuario (nombre y email)
- Links de navegación (Inicio, Clima)
- Botón de logout
- Responsive design

### `<ProtectedRoute />`
- HOC que protege rutas privadas
- Verifica autenticación antes de renderizar
- Redirige a login si no está autenticado
- Muestra loading mientras verifica sesión

### Componentes Reutilizables
- `<Input />` - Input con label y manejo de errores
- `<Button />` - Botón con estados (loading, disabled)
- `<Loading />` - Spinner de carga

## 📚 Documentación Adicional

Para más detalles sobre las decisiones de arquitectura y cómo escalar la aplicación, consulta:

📖 **[ARCHITECTURE.md](./ARCHITECTURE.md)** - Documentación técnica completa

## 🧪 Scripts Disponibles

```bash
# Desarrollo
npm run dev

# Build para producción
npm run build

# Preview del build
npm run preview

# Linter
npm run lint
```

## 🐛 Troubleshooting

### Error de conexión
```
Error de conexión. Verifica que el servidor esté activo.
```
**Solución**: Asegúrate de que el backend esté corriendo en `http://localhost:3000`

### Token expirado
Si el token expira, el usuario debe hacer login nuevamente.  
**Mejora futura**: Implementar refresh tokens

### LocalStorage no disponible
La app requiere localStorage habilitado en el navegador.

## 🚀 Próximos Pasos (Expansión)

Esta base está lista para agregar:
- [x] Funcionalidades de clima ✅
- [ ] Búsqueda de ciudades específicas
- [ ] Pronóstico extendido (7 días)
- [ ] Dashboard con gráficos
- [ ] Perfil de usuario editable
- [ ] Forgot password
- [ ] Refresh tokens
- [ ] Tests unitarios y e2e
- [ ] Temas claro/oscuro

## 📝 Licencia

MIT

---

**Desarrollado con** ❤️ **siguiendo principios SOLID y Clean Architecture**
