require "test_helper"

class OrderItemTest < ActiveSupport::TestCase
  setup do
    @order = Order.new(recipient_name: "Ana", recipient_phone: "55", address: "CDMX")
    @product = Product.create!(name: "Margarita", price: 150)
  end

  test "copies unit_price from product on create when blank" do
    item = OrderItem.new(order: @order, product: @product, quantity: 2)
    item.valid?
    assert_equal 150, item.unit_price
  end

  test "keeps an explicitly set unit_price (snapshot)" do
    item = OrderItem.new(order: @order, product: @product, quantity: 1, unit_price: 99)
    item.valid?
    assert_equal 99, item.unit_price
  end

  test "subtotal is unit_price times quantity" do
    item = OrderItem.new(order: @order, product: @product, quantity: 3, unit_price: 150)
    assert_equal 450, item.subtotal
  end

  test "quantity must be a positive integer" do
    item = OrderItem.new(order: @order, product: @product, quantity: 0)
    assert_not item.valid?
    assert_includes item.errors[:quantity], "must be greater than 0"
  end
end
