class WeatherController < ApplicationController
  include Authenticable

  def forecast
    lat = params[:lat]
    lon = params[:lon]

    if lat.blank? || lon.blank?
      return render json: {
        error: "Missing required parameters: lat and lon are required"
      }, status: :bad_request
    end

    result = OpenWeatherService.new.get_forecast(lat: lat, lon: lon)

    if result[:success]
      render json: result[:data], status: :ok
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  rescue ArgumentError => e
    render json: { error: e.message }, status: :bad_request
  rescue OpenWeatherService::ConfigurationError => e
    render json: { error: "Server configuration error: #{e.message}" }, status: :internal_server_error
  rescue StandardError => e
    render json: { error: "An unexpected error occurred: #{e.message}" }, status: :internal_server_error
  end

  def current_weather
    result = OpenWeatherService.new.get_current_weather_for_cities

    if result[:success]
      render json: {
        weather: result[:data],
        count: result[:count]
      }, status: :ok
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: "An unexpected error occurred: #{e.message}" }, status: :internal_server_error
  end

  def five_day_forecast
    lat = params[:lat]
    lon = params[:lon]

    if lat.blank? || lon.blank?
      return render json: {
        error: "Missing required parameters: lat and lon are required"
      }, status: :bad_request
    end

    result = OpenWeatherService.new.get_five_day_forecast(lat: lat, lon: lon)

    if result[:success]
      render json: result[:data], status: :ok
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  rescue ArgumentError => e
    render json: { error: e.message }, status: :bad_request
  rescue OpenWeatherService::ConfigurationError => e
    render json: { error: "Server configuration error: #{e.message}" }, status: :internal_server_error
  rescue StandardError => e
    render json: { error: "An unexpected error occurred: #{e.message}" }, status: :internal_server_error
  end

  def show
    lat = params[:lat]
    lon = params[:lon]

    if lat.blank? || lon.blank?
      return render json: {
        error: "Missing required parameters: lat and lon are required"
      }, status: :bad_request
    end

    result = OpenWeatherService.new.get_weather_by_coordinates(lat: lat, lon: lon)

    if result[:success]
      render json: result[:data], status: :ok
    else
      render json: { error: result[:error] }, status: :not_found
    end
  rescue ArgumentError => e
    render json: { error: e.message }, status: :bad_request
  rescue OpenWeatherService::ConfigurationError => e
    render json: { error: "Server configuration error: #{e.message}" }, status: :internal_server_error
  rescue StandardError => e
    render json: { error: "An unexpected error occurred: #{e.message}" }, status: :internal_server_error
  end
end
