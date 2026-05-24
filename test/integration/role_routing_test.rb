require "test_helper"

class RoleRoutingTest < ActionDispatch::IntegrationTest
  setup do
    @manager = User.create!(email: "boss@example.com", password: "password123", role: :manager)
    @rider = User.create!(email: "rider@example.com", password: "password123", role: :rider)
  end

  test "manager signing in lands on the manager board" do
    sign_in @manager
    get root_path
    assert_redirected_to manager_orders_path
  end

  test "rider signing in lands on rider deliveries" do
    sign_in @rider
    get root_path
    assert_redirected_to rider_orders_path
  end

  test "rider cannot access the manager namespace" do
    sign_in @rider
    get manager_orders_path
    assert_redirected_to root_path
  end

  test "manager cannot access the rider namespace" do
    sign_in @manager
    get rider_orders_path
    assert_redirected_to root_path
  end
end
