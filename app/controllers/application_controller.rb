class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :ensure_admin!

  private
  
  def ensure_admin!
    if current_user
      redirect_to('/unauthorized') unless current_user.admin?
    end
  end
end
