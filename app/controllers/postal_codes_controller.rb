class PostalCodesController < ApplicationController
  before_action :set_postal_code, only: [:show]

  # GET /postal_codes
  # GET /postal_codes.json
  def index
  end

  # GET /postal_codes/1
  # GET /postal_codes/1.json
  def show
  end
  
  def search
    redirect_to postal_code_path(params[:code])
  end

  private

  def set_postal_code
    @postal_code = PostalCode.find_by(code: params[:id])
  end
end
