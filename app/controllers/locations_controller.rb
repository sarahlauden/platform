class LocationsController < ApplicationController
  before_action :set_location, only: [:show]

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.paginate(page: params[:page])
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
  end

  private
  
  def set_location
    @location = Location.find(params[:id])
  end
end
