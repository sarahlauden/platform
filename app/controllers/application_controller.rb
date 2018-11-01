class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :ensure_admin!

  private
  
  def authenticate_user!
    super unless authorized_by_token?
  end
  
  def ensure_admin!
    if current_user
      redirect_to('/unauthorized') unless current_user.admin?
    end
  end
  
  def authorized_by_token?
    return false unless request.format.symbol == :json

    key = params[:access_key] || request.headers['Access-Key']
    return false if key.nil?
    
    !!AccessToken.find_by(key: key)
  end
end
