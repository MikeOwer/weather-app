class OpenWeatherService
  BASE_URL = "https://api.openweathermap.org/data/2.5/forecast"
  CACHE_EXPIRATION = 10.minutes

  class ServiceError < StandardError; end
  class ConfigurationError < ServiceError; end
  class NetworkError < ServiceError; end
  class ApiError < ServiceError; end

  def initialize
    @api_key = ENV["OPENWEATHER_API_KEY"]
    validate_configuration!
  end

  def get_current_weather_for_cities
    cities_result = ReservamosCitiesService.new.get_cities
    return cities_result unless cities_result[:success]

    cities = cities_result[:data]
    weather_data = cities.map do |city|
      get_current_weather_for_city(city)
    end.compact

    {
      success: true,
      data: weather_data,
      count: weather_data.size
    }
  rescue StandardError => e
    {
      success: false,
      error: "Failed to fetch weather data: #{e.message}"
    }
  end

  def get_five_day_forecast(lat:, lon:)
    validate_coordinates!(lat, lon)

    cache_key = "weather_5day_#{lat}_#{lon}"
    cached_data = Rails.cache.read(cache_key)
    return cached_data if cached_data

    response = make_request(lat: lat, lon: lon)
    result = parse_response(response)

    if result[:success]
      forecast_data = process_five_day_forecast(result[:data])
      Rails.cache.write(cache_key, forecast_data, expires_in: CACHE_EXPIRATION)
      forecast_data
    else
      result
    end
  rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
    handle_network_error(e)
  rescue Faraday::Error => e
    handle_faraday_error(e)
  end

  private

  def validate_configuration!
    if @api_key.nil? || @api_key.empty?
      raise ConfigurationError, "OPENWEATHER_API_KEY environment variable is not set"
    end
  end

  def validate_coordinates!(lat, lon)
    unless valid_latitude?(lat) && valid_longitude?(lon)
      raise ArgumentError, "Invalid coordinates: lat must be between -90 and 90, lon must be between -180 and 180"
    end
  end

  def valid_latitude?(lat)
    lat.to_f.between?(-90, 90)
  end

  def valid_longitude?(lon)
    lon.to_f.between?(-180, 180)
  end

  def make_request(lat:, lon:)
    connection.get do |req|
      req.params["lat"] = lat
      req.params["lon"] = lon
      req.params["appid"] = @api_key
      req.params["units"] = "metric"
      req.params["lang"] = "es"
    end
  end

  def get_current_weather_for_city(city)
    cache_key = "weather_current_#{city['lat']}_#{city['long']}"
    cached_data = Rails.cache.read(cache_key)
    return cached_data if cached_data

    response = make_request(lat: city["lat"], lon: city["long"])
    result = parse_response(response)

    if result[:success] && result[:data]["list"]&.first
      current = result[:data]["list"].first
      weather_info = {
        city_name: city["display"],
        temperature: current["main"]["temp"],
        weather_condition: current["weather"].first["main"],
        weather_description: current["weather"].first["description"],
        lat: city["lat"],
        long: city["long"]
      }
      Rails.cache.write(cache_key, weather_info, expires_in: CACHE_EXPIRATION)
      weather_info
    else
      nil
    end
  rescue StandardError => e
    Rails.logger.error("Failed to fetch weather for #{city['display']}: #{e.message}")
    nil
  end

  def process_five_day_forecast(data)
    return { success: false, error: "Invalid data format" } unless data["list"]

    daily_forecasts = group_by_day(data["list"])

    {
      success: true,
      data: daily_forecasts.map do |day, entries|
        temps = entries.map { |e| e["main"]["temp"] }
        {
          date: day,
          temp_max: entries.map { |e| e["main"]["temp_max"] }.max,
          temp_min: entries.map { |e| e["main"]["temp_min"] }.min,
          weather_condition: entries.first["weather"].first["main"],
          weather_description: entries.first["weather"].first["description"]
        }
      end.first(5)
    }
  end

  def group_by_day(forecast_list)
    forecast_list.group_by do |entry|
      DateTime.parse(entry["dt_txt"]).to_date.to_s
    end
  end

  def connection
    @connection ||= Faraday.new(url: BASE_URL) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
      faraday.options.timeout = 10
      faraday.options.open_timeout = 5
    end
  end

  def parse_response(response)
    case response.status
    when 200
      {
        success: true,
        data: JSON.parse(response.body)
      }
    when 401
      {
        success: false,
        error: "Invalid API key. Please check your OPENWEATHER_API_KEY configuration"
      }
    when 404
      {
        success: false,
        error: "Location not found for the provided coordinates"
      }
    when 429
      {
        success: false,
        error: "API rate limit exceeded. Please try again later"
      }
    else
      {
        success: false,
        error: "API returned status #{response.status}: #{response.body}"
      }
    end
  rescue JSON::ParserError => e
    {
      success: false,
      error: "Failed to parse API response: #{e.message}"
    }
  end

  def handle_network_error(error)
    {
      success: false,
      error: "Network error: Unable to connect to OpenWeather API - #{error.message}"
    }
  end

  def handle_faraday_error(error)
    {
      success: false,
      error: "Request failed: #{error.message}"
    }
  end
end
