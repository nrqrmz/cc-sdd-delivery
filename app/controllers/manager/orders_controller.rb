module Manager
  class OrdersController < Manager::BaseController
    def index
      @orders = []
    end
  end
end
