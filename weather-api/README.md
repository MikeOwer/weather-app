# Weather API

API REST desarrollada en Rails 8 con autenticación JWT, manejo de usuarios e integración con APIs externas (OpenWeather y Reservamos).

## Stack Tecnológico

- Ruby on Rails 8.1.1
- PostgreSQL
- JWT para autenticación
- BCrypt para encriptación de passwords
- Faraday para requests HTTP
- dotenv-rails para variables de entorno

## Inicio Rápido

```bash
# Instalar dependencias
bundle install

# Configurar variables de entorno
cp .env.example .env
# Editar .env y agregar OPENWEATHER_API_KEY=tu_api_key

# Configurar base de datos
rails db:create
rails db:migrate

# Iniciar servidor
rails server
```

## Características

- Autenticación JWT con tokens de 24 horas
- Registro y login de usuarios
- CRUD completo de usuarios
- Integración con OpenWeather API (pronóstico del tiempo)
- Integración con Reservamos API (consulta de ciudades)
- Caché de datos meteorológicos (10 minutos)
- Combinación de múltiples APIs en un solo endpoint
- Controllers delgados con Service Layer
- Filtrado inteligente de datos de APIs externas
- Manejo robusto de errores HTTP
- Validaciones robustas
- Respuestas JSON estandarizadas
- HTTP status codes correctos

## Endpoints Principales

### Autenticación (Públicos)
- `POST /auth/register` - Registro de usuario
- `POST /auth/login` - Login de usuario

### Usuarios (Requieren JWT)
- `GET /users` - Listar usuarios
- `GET /users/:id` - Obtener usuario
- `PUT /users/:id` - Actualizar usuario
- `DELETE /users/:id` - Eliminar usuario

### Weather (Requiere JWT)
- `GET /weather/forecast?lat={lat}&lon={lon}` - Pronóstico del tiempo
- `GET /weather/:id?lat={lat}&lon={lon}` - Temperatura de ciudad específica
- `POST /weather` - Temperatura actual de todas las ciudades
- `POST /weather/days` - Pronóstico de 5 días (body: lat, lon)

### Cities (Requiere JWT)
- `GET /cities` - Listar ciudades disponibles

## Documentación

Para ver ejemplos detallados de requests/responses y documentación completa, consulta [API_DOCUMENTATION.md](API_DOCUMENTATION.md)

## Arquitectura

```
app/
├── controllers/
│   ├── auth_controller.rb               # Autenticación
│   ├── users_controller.rb              # CRUD usuarios
│   ├── weather_controller.rb            # Pronóstico del tiempo
│   ├── cities_controller.rb             # Consulta de ciudades
│   └── concerns/authenticable.rb        # JWT concern
├── models/
│   └── user.rb                          # Modelo User
└── services/
    ├── authentication_service.rb        # Lógica de auth
    ├── user_service.rb                  # Lógica de usuarios
    ├── json_web_token.rb                # JWT helper
    ├── open_weather_service.rb          # Cliente HTTP OpenWeather
    └── reservamos_cities_service.rb     # Cliente HTTP Reservamos
```

## Ejemplo de Uso

```bash
# Registro
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com","password":"password123"}'

# Login
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"john@example.com","password":"password123"}'

# Listar usuarios (con token)
curl -X GET http://localhost:3000/users \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Obtener pronóstico del tiempo (con token)
curl -X GET "http://localhost:3000/weather/forecast?lat=40.7128&lon=-74.0060" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Listar ciudades (con token)
curl -X GET http://localhost:3000/cities \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Temperatura actual de todas las ciudades (con token)
curl -X POST http://localhost:3000/weather \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Pronóstico de 5 días (con token)
curl -X POST http://localhost:3000/weather/days \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"lat": 40.7128, "lon": -74.0060}'

# Temperatura de ciudad específica por coordenadas (con token)
curl -X GET "http://localhost:3000/weather/city?lat=20.6737&lon=-103.344" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```
