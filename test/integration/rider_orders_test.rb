require "test_helper"

class RiderOrdersTest < ActionDispatch::IntegrationTest
  setup do
    @rider = User.create!(email: "rider@example.com", password: "password123", role: :rider)
    @other_rider = User.create!(email: "other@example.com", password: "password123", role: :rider)
    @product = Product.create!(name: "Margarita", price: 150)
    sign_in @rider
  end

  def create_order(rider:, status: :assigned)
    order = Order.new(recipient_name: "Ana", recipient_phone: "55", address: "CDMX", rider: rider, status: status)
    order.order_items.build(product: @product, quantity: 1)
    order.save!
    order
  end

  test "index shows only my active deliveries" do
    create_order(rider: @rider, status: :assigned)
    create_order(rider: @other_rider, status: :assigned)
    get rider_orders_path
    assert_response :success
    # Two assigned orders exist but only the current rider's own one is listed.
    assert_select ".order-card", 1
  end
end
