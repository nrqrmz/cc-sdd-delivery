class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    dashboard_path_for(resource)
  end

  private

  def dashboard_path_for(user)
    user.manager? ? manager_orders_path : rider_orders_path
  end
end
