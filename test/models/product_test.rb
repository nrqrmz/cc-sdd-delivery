require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "valid with name and price" do
    assert Product.new(name: "Margarita", price: 150).valid?
  end

  test "requires a name" do
    product = Product.new(price: 150)
    assert_not product.valid?
    assert_includes product.errors[:name], "can't be blank"
  end

  test "requires a non-negative price" do
    assert_not Product.new(name: "Margarita", price: nil).valid?
    assert_not Product.new(name: "Margarita", price: -1).valid?
  end
end
