module Rider
  class OrdersController < Rider::BaseController
    STATUS_LABELS = Manager::OrdersController::STATUS_LABELS

    def index
      orders = current_user.assigned_orders.includes(order_items: :product)
      @active_orders = orders.where(status: %i[assigned en_route]).order(created_at: :asc)
      @delivered_orders = orders.delivered.order(updated_at: :desc)
    end

    def show
      @order = current_user.assigned_orders.includes(order_items: :product).find(params[:id])
    end

    def update
      @order = current_user.assigned_orders.find(params[:id])
      if advance(@order, params[:transition])
        redirect_to rider_orders_path, notice: "Estado actualizado."
      else
        redirect_to rider_orders_path, alert: "No se pudo cambiar el estado."
      end
    end

    private

    def advance(order, transition)
      case transition
      when "en_route" then order.mark_en_route!
      when "delivered" then order.mark_delivered!
      end
    end
  end
end
