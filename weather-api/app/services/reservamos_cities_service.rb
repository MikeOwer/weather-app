class ReservamosCitiesService
  BASE_URL = "https://search.reservamos.mx/api/v2/places"

  class ServiceError < StandardError; end
  class NetworkError < ServiceError; end
  class ApiError < ServiceError; end

  def get_cities
    response = make_request
    parse_and_filter_response(response)
  rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
    handle_network_error(e)
  rescue Faraday::Error => e
    handle_faraday_error(e)
  end

  private

  def make_request
    connection.get
  end

  def connection
    @connection ||= Faraday.new(url: BASE_URL) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
      faraday.options.timeout = 10
      faraday.options.open_timeout = 5
    end
  end

  def parse_and_filter_response(response)
    case response.status
    when 200, 201
      data = JSON.parse(response.body)
      cities = filter_cities(data)
      {
        success: true,
        data: cities,
        count: cities.size
      }
    when 404
      {
        success: false,
        error: "Resource not found"
      }
    when 500..599
      {
        success: false,
        error: "External API server error (status #{response.status})"
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

  def filter_cities(data)
    return [] unless data.is_a?(Array)

    data.select do |item|
      item.is_a?(Hash) && item["result_type"] == "city"
    end
  end

  def handle_network_error(error)
    {
      success: false,
      error: "Network error: Unable to connect to Reservamos API - #{error.message}"
    }
  end

  def handle_faraday_error(error)
    {
      success: false,
      error: "Request failed: #{error.message}"
    }
  end
end
