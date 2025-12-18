# weather-api
API REST que permite mostrar el clima actual y de los próximos 7 días en distintas ciudades.   

## Alcance

- Sign up y Login de usuarios
- Lista de ciudades
- Clima actual
- Clima de los próximos 7 dias
- Llamadas a OpenWeather con caching
- Manejo de estado y navegacion fluida
- Diseño mobile-friendly (No es necesario pixel perfect, solo usable)

## Tecnologias

Backend: Ruby on Rails
Frontend: React con JS
Nota: Se tomo esta decision ya que tengo conocimientos en ambas tecnologias y son las que se usan en Reservamos.

Arquitectura: 
- Backend: MVC con controllers delgados y servicios.
Nota: Esta decision la tome porque al ser un proyecto pequeno debo utilizar una arquitectura sencilla, sin embargo, seleccione los servicios porque me gusta que mis proyectos sean escalables y limpios.

- Frontend: 

## Proceso

### Backend

- Despues de crear la primera parte del prompt me puse a configurar mis credenciales de PostgreSQL.
- Al terminar los prompts elimine de todos los controllers la linea: skip_before_action :verify_authenticity_token
- Agregue la API_Key sin que el LLM conozca su existencia.
- Probe que todos los endpoints funcionen.

Nota: Durante todo el proceso de generacion de codigo me asegure de supervisar que la logica tuviera sentido.

## Prompts Backend

### Setup de User CRUD y AuthService
Actua como un ingeniero de software senior especializado en Ruby on Rails. 

Contexto:
API REST en Rails 8 con PostgreSQL.
Se usa ActiveRecord como ORM. 
Arquitectura con controllers delgados.
No se usan vistas.
Se acaba de crear el proyecto con: "rails new weather-api --api -d=postgresql -T"

Objetivo:
Implementar autenticacion y manejo de usuarios siguiendo buenas practicas Rails.
Autenticacion.
- Permita login POST /auth/login
- Permita registro POST /auth/register
- Use JWT
- Envie el token en el header: Authorization: Bearer <token>
- Use has_secure_password

Usuarios.
Implementar CRUD para el objeto User:
- GET /users
- GET /users/:id
- PUT /users/:id
- DELETE /users/:id

Validaciones:
- Se espera que el atributo "name" este presente
- Se espera el atributo "email" este presente y sea unico
- Se espera que el atributo "password" este presente solo en register y login

Errores y respuestas:
- Respuestas JSON estandar
- Usar HTTP status codes correctos

Restricciones:
- Controllers deben delegar la logica a services
- No usar logica de negocio en controllers
- No incluir tests

Formato:
1. Explicacion breve
2. Codigo por archivo
3. Ejemplo de request/response JSON

Nivel de detalle:
Asume que soy un ingeniero backend mid

### Creacion del servicio para OpenWeather
Mantén todo lo anterior exactamente igual.

Ahora extiende la solución para:
Crear un servicio en app/services para consumir la API de OpenWeather
- Usar la URL: api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API_KEY}
- El API key debe leerse desde un archivo .env
- Usar Faraday
- El servicio debe exponer un método público que reciba lat y lon
- El servicio debe devolver el JSON parseado
- Manejar errores de red y respuestas no exitosas
- No colocar lógica HTTP en controllers

### Creacion de servicio para la API de Reservamos
Ahora extiende la solucion para:
- Crear un servicio en app/services para consumir la API con URL: https://search.reservamos.mx/api/v2/places
- El servicio debe exponer un metodo publico que:
    - Consuma la API externa
    - Filtre los resultados
    - Devuelva unicamente los objetos cuyo "result_type" sea "city"
- Crear unicamente el endpoint GET /cities
- Usar Faraday
- El servicio debe devolver el JSON parseado
- Manejar errores de red y respuestas no exitosas
- No colocar lógica HTTP en controllers

Contexto:
- La URL devuelve una lista de objetos

Restricciones:
- El controller debe delegar toda la logica al servicio

### Creacion del endpoint para el clima actual y el clima de hoy a 5 dias
Manten todo lo anterior exactamente igual.

Ahora extiende la solucion para:
- Crear un endpoint POST /weather que:
    - El metodo nuevo en open_weather_service.rb reciba la informacion de lat y long de cada ciudad del metodo get_cities del servicio reservamos_cities_service.rb
    - Que el endpoint devuelva temperatura actual de cada ciudad, se espera:
        - Nombre de la ciudad (Reservamos: "display")
        - Temperatura actual por cada objeto en la lista (OpenWeather: "temp")
        - Condicion climatica (Soleado, nubaldo, etc) (OpenWeather: "weather":["main", "description"])
        - lat (Reservamos: "lat")
        - long (Reservamos: "long")
        Nota: Lo agregado entre parentesis son las key de los objetos de donde se accede a la informacion de interes
- Crear un endpoint POST /weather/days que:
    - Reciba lat y long como parametros
    - Permita conocer la temperatura por dia de los proximos 5 dias de una ciudad en especifico, se espera:
        - Dia (OpenWeather: "dt_txt")
        - Temperatura maxima/minima (OpenWeather: "temp_max","temp_min")
        - Condicion climatica (OpenWeather: "weather":["main", "description"])
- Agregar las temperaturas en unidades metricas generales usando: "&units=metric" en la URL de la API de OpenWeather

Contexto:
- La URL de OpenWeather devuelve una lista de objetos con la siguiente estructura:
{
  "cod": "200",
  "message": 0,
  "cnt": 40,
  "list": [
    {
      "dt": 1765951200,
      "main": {
        "temp": 290.87,
        "feels_like": 289.95,
        "temp_min": 290.87,
        "temp_max": 290.88,
        "pressure": 1016,
        "sea_level": 1016,
        "grnd_level": 764,
        "humidity": 48,
        "temp_kf": -0.01
      },
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "description": "light rain",
          "icon": "10n"
        }
      ],
      "clouds": {
        "all": 75
      },
      "wind": {
        "speed": 0.5,
        "deg": 208,
        "gust": 0.88
      },
      "visibility": 10000,
      "pop": 0.32,
      "rain": {
        "3h": 0.14
      },
      "sys": {
        "pod": "n"
      },
      "dt_txt": "2025-12-17 06:00:00"
    },
    {
      "dt": 1765962000,
      "main": {
        "temp": 290.39,
        "feels_like": 289.48,
        "temp_min": 289.43,
        "temp_max": 290.39,
        "pressure": 1016,
        "sea_level": 1016,
        "grnd_level": 763,
        "humidity": 50,
        "temp_kf": 0.96
      },
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "description": "light rain",
          "icon": "10n"
        }
      ],
      "clouds": {
        "all": 68
      },
      "wind": {
        "speed": 1.03,
        "deg": 240,
        "gust": 1.61
      },
      "visibility": 10000,
      "pop": 0.33,
      "rain": {
        "3h": 0.17
      },
      "sys": {
        "pod": "n"
      },
      "dt_txt": "2025-12-17 09:00:00"
    }
],    
"city": {
    "id": 3530597,
    "name": "Mexico City",
    "coord": {
      "lat": 19.4326,
      "lon": -99.1332
    },
    "country": "MX",
    "population": 15000,
    "timezone": -21600,
    "sunrise": 1765890211,
    "sunset": 1765929674
  }
}

Restricciones:
- El controller debe delegar toda la logica al servicio
- Se debe utilizar Rails cache para la informacion obtenida de la API de OpenWeather
- Usar Faraday
- El servicio debe devolver el JSON parseado
- Manejar errores de red y respuestas no exitosas
- No colocar lógica HTTP en controllers