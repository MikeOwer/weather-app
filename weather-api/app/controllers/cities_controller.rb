class CitiesController < ApplicationController
  include Authenticable

  def index
    result = ReservamosCitiesService.new.get_cities

    if result[:success]
      render json: {
        cities: result[:data],
        count: result[:count]
      }, status: :ok
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: "An unexpected error occurred: #{e.message}" }, status: :internal_server_error
  end
end
