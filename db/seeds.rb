# Idempotent seeds for PizzApp.
puts "Clearing existing data…"
OrderItem.delete_all
Order.delete_all
Product.delete_all
User.delete_all

puts "Creating users…"
manager = User.create!(email: "manager@pizzapp.test", password: "password123", role: :manager)
riders = [
  User.create!(email: "pedro@pizzapp.test", password: "password123", role: :rider),
  User.create!(email: "jorge@pizzapp.test", password: "password123", role: :rider)
]

puts "Creating products…"
products = {
  margarita: Product.create!(name: "Margarita", price: 150),
  pepperoni: Product.create!(name: "Pepperoni", price: 180),
  hawaiana:  Product.create!(name: "Hawaiana", price: 175),
  coca:      Product.create!(name: "Coca-Cola", price: 30),
  agua:      Product.create!(name: "Agua", price: 20)
}

puts "Creating orders…"
samples = [
  # Addresses on the Paseo de la Reforma skyscraper corridor (Ángel ↔ Diana) for a striking 3D map.
  { name: "Ana Gómez",  phone: "5512345678", address: "Paseo de la Reforma 505, Cuauhtémoc, 06500 Ciudad de México, CDMX", # Torre Mayor
    status: :pending,  rider: nil,        items: [ [ :margarita, 1 ], [ :coca, 1 ] ] },
  { name: "Carla Ruiz", phone: "5512345679", address: "Paseo de la Reforma 483, Cuauhtémoc, 06500 Ciudad de México, CDMX", # Torre Reforma
    status: :pending,  rider: nil,        items: [ [ :pepperoni, 2 ], [ :agua, 1 ] ] },
  { name: "Beto Salas", phone: "5512345680", address: "Paseo de la Reforma 510, Cuauhtémoc, 06500 Ciudad de México, CDMX", # Torre BBVA
    status: :assigned, rider: riders[0],  items: [ [ :hawaiana, 1 ], [ :margarita, 1 ] ] },
  { name: "Luis Mora",  phone: "5512345681", address: "Paseo de la Reforma 509, Cuauhtémoc, 06500 Ciudad de México, CDMX", # Chapultepec Uno
    status: :en_route, rider: riders[0],  items: [ [ :pepperoni, 3 ], [ :coca, 1 ] ] },
  { name: "María Díaz", phone: "5512345682", address: "Av. Paseo de la Reforma 222, Juárez, 06600 Ciudad de México, CDMX", # Reforma 222
    status: :delivered, rider: riders[1], items: [ [ :hawaiana, 1 ], [ :agua, 1 ] ] }
]

samples.each do |s|
  order = Order.new(recipient_name: s[:name], recipient_phone: s[:phone], address: s[:address],
                    status: s[:status], rider: s[:rider])
  s[:items].each { |key, qty| order.order_items.build(product: products[key], quantity: qty) }
  order.save!
end

puts "Done: #{User.count} users, #{Product.count} products, #{Order.count} orders."
