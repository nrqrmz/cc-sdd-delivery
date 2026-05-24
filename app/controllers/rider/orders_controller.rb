module Rider
  class OrdersController < Rider::BaseController
    STATUS_LABELS = Manager::OrdersController::STATUS_LABELS

    def index
      orders = current_user.assigned_orders.includes(order_items: :product)
      @active_orders = orders.where(status: %i[assigned en_route]).order(created_at: :asc)
      @delivered_orders = orders.delivered.order(updated_at: :desc)
    end
  end
end
