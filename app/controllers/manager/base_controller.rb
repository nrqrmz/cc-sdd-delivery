module Manager
  class BaseController < ApplicationController
    before_action :require_manager

    private

    def require_manager
      redirect_to root_path, alert: "No tienes acceso a esa sección." unless current_user.manager?
    end
  end
end
