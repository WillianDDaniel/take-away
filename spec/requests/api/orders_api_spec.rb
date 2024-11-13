require 'rails_helper'

describe 'Orders API' do
  context 'GET /api/v1/restaurants/:code/orders' do
    it 'returns all orders with the correct restaurant code and without status' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      beverage = Beverage.create!(name: 'Coca', description: 'Teste', restaurant: restaurant)

      portion_dish = Portion.create!(description: 'Teste', price: 10, portionable: dish)
      portion_beverage = Portion.create!(description: 'Teste', price: 10, portionable: beverage)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)
      menu.dishes << Dish.first
      menu.beverages << Beverage.first

      ordem_dish = OrderItem.new(portion: portion_dish, quantity: 1, note: 'Sem cebola')
      ordem_beverage = OrderItem.new(portion: portion_beverage, quantity: 1)

      Order.create!(
        customer_name: 'Ana Doe', customer_phone: '11999955555',
        customer_email: 'customer@example.com', customer_doc: CPF.generate,
        order_items: [ordem_dish], menu: menu
      )

      Order.create!(
        customer_name: 'Maria Doe', customer_phone: '11999977777',
        customer_email: 'other-customer@example.com', customer_doc: CPF.generate,
        order_items: [ordem_beverage], menu: menu
      )

      get "/api/v1/restaurants/#{restaurant.code}/orders"

      orders = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(orders.count).to eq 2
    end

    it 'returns correct orders with the correct restaurant code and with correct status' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      beverage = Beverage.create!(name: 'Coca', description: 'Teste', restaurant: restaurant)

      portion_dish = Portion.create!(description: 'Teste', price: 10, portionable: dish)
      portion_beverage = Portion.create!(description: 'Teste', price: 10, portionable: beverage)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)
      menu.dishes << Dish.first
      menu.beverages << Beverage.first

      ordem_dish_01 = OrderItem.new(portion: portion_dish, quantity: 1, note: 'Sem cebola')
      ordem_beverage_01 = OrderItem.new(portion: portion_beverage, quantity: 1)

      ordem_dish_02 = OrderItem.new(portion: portion_dish, quantity: 1, note: 'Com cebola')
      ordem_beverage_02 = OrderItem.new(portion: portion_beverage, quantity: 1)

      Order.create!(
        customer_name: 'Ana Doe', customer_phone: '11999955555',
        customer_email: 'ana@example.com', customer_doc: CPF.generate,
        order_items: [ordem_dish_01], menu: menu, status: :preparing
      )

      Order.create!(
        customer_name: 'Maria Doe', customer_phone: '11999911111',
        customer_email: 'maria@example.com', customer_doc: CPF.generate,
        order_items: [ordem_beverage_01], menu: menu, status: :ready
      )

      Order.create!(
        customer_name: 'João Doe', customer_phone: '11999922222',
        customer_email: 'joao@example.com', customer_doc: CPF.generate,
        order_items: [ordem_dish_02], menu: menu, status: :pending
      )

      Order.create!(
        customer_name: 'Pedro Doe', customer_phone: '11999933333',
        customer_email: 'pedro@example.com', customer_doc: CPF.generate,
        order_items: [ordem_beverage_02], menu: menu, status: :pending
      )

      get "/api/v1/restaurants/#{restaurant.code}/orders", params: { status: 'pending' }

      orders = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(orders.count).to eq 2
    end

    it 'if status is invalid, returns all orders with the correct restaurant code' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      beverage = Beverage.create!(name: 'Coca', description: 'Teste', restaurant: restaurant)

      portion_dish = Portion.create!(description: 'Teste', price: 10, portionable: dish)
      portion_beverage = Portion.create!(description: 'Teste', price: 10, portionable: beverage)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)
      menu.dishes << Dish.first
      menu.beverages << Beverage.first

      ordem_dish_01 = OrderItem.new(portion: portion_dish, quantity: 1, note: 'Sem cebola')
      ordem_beverage_01 = OrderItem.new(portion: portion_beverage, quantity: 1)

      ordem_dish_02 = OrderItem.new(portion: portion_dish, quantity: 1, note: 'Com cebola')
      ordem_beverage_02 = OrderItem.new(portion: portion_beverage, quantity: 1)

      Order.create!(
        customer_name: 'Ana Doe', customer_phone: '11999955555',
        customer_email: 'ana@example.com', customer_doc: CPF.generate,
        order_items: [ordem_dish_01], menu: menu, status: :preparing
      )

      Order.create!(
        customer_name: 'Maria Doe', customer_phone: '11999911111',
        customer_email: 'maria@example.com', customer_doc: CPF.generate,
        order_items: [ordem_beverage_01], menu: menu, status: :ready
      )

      Order.create!(
        customer_name: 'João Doe', customer_phone: '11999922222',
        customer_email: 'joao@example.com', customer_doc: CPF.generate,
        order_items: [ordem_dish_02], menu: menu, status: :cancelled
      )

      Order.create!(
        customer_name: 'Pedro Doe', customer_phone: '11999933333',
        customer_email: 'pedro@example.com', customer_doc: CPF.generate,
        order_items: [ordem_beverage_02], menu: menu, status: :pending
      )

      get "/api/v1/restaurants/#{restaurant.code}/orders", params: { status: 'blablabla' }

      orders = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(orders.count).to eq 4
    end

    it 'if status is blank, returns all orders with the correct restaurant code' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      beverage = Beverage.create!(name: 'Coca', description: 'Teste', restaurant: restaurant)

      portion_dish = Portion.create!(description: 'Teste', price: 10, portionable: dish)
      portion_beverage = Portion.create!(description: 'Teste', price: 10, portionable: beverage)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)
      menu.dishes << Dish.first
      menu.beverages << Beverage.first

      ordem_dish_01 = OrderItem.new(portion: portion_dish, quantity: 1, note: 'Sem cebola')
      ordem_beverage_01 = OrderItem.new(portion: portion_beverage, quantity: 1)

      ordem_dish_02 = OrderItem.new(portion: portion_dish, quantity: 1, note: 'Com cebola')
      ordem_beverage_02 = OrderItem.new(portion: portion_beverage, quantity: 1)

      Order.create!(
        customer_name: 'Ana Doe', customer_phone: '11999955555',
        customer_email: 'ana@example.com', customer_doc: CPF.generate,
        order_items: [ordem_dish_01], menu: menu, status: :preparing
      )

      Order.create!(
        customer_name: 'Maria Doe', customer_phone: '11999911111',
        customer_email: 'maria@example.com', customer_doc: CPF.generate,
        order_items: [ordem_beverage_01], menu: menu, status: :ready
      )

      Order.create!(
        customer_name: 'João Doe', customer_phone: '11999922222',
        customer_email: 'joao@example.com', customer_doc: CPF.generate,
        order_items: [ordem_dish_02], menu: menu, status: :cancelled
      )

      Order.create!(
        customer_name: 'Pedro Doe', customer_phone: '11999933333',
        customer_email: 'pedro@example.com', customer_doc: CPF.generate,
        order_items: [ordem_beverage_02], menu: menu, status: :pending
      )

      get "/api/v1/restaurants/#{restaurant.code}/orders"

      orders = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(orders.count).to eq 4
    end

    it 'should show a error message if the restaurant code is not valid' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      beverage = Beverage.create!(name: 'Coca', description: 'Teste', restaurant: restaurant)

      portion_dish = Portion.create!(description: 'Teste', price: 10, portionable: dish)
      portion_beverage = Portion.create!(description: 'Teste', price: 10, portionable: beverage)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)
      menu.dishes << Dish.first
      menu.beverages << Beverage.first

      ordem_dish = OrderItem.new(portion: portion_dish, quantity: 1, note: 'Sem cebola')
      ordem_beverage = OrderItem.new(portion: portion_beverage, quantity: 1)

      Order.create!(
        customer_name: 'Ana Doe', customer_phone: '11999955555',
        customer_email: 'ana@example.com', customer_doc: CPF.generate,
        order_items: [ordem_dish], menu: menu, status: :preparing
      )

      Order.create!(
        customer_name: 'Maria Doe', customer_phone: '11999911111',
        customer_email: 'maria@example.com', customer_doc: CPF.generate,
        order_items: [ordem_beverage], menu: menu, status: :ready
      )

      get "/api/v1/restaurants/invalid_code/orders"

      res = JSON.parse(response.body)

      expect(response).to have_http_status(404)
      expect(res['error']).to eq('Restaurante não encontrado')
      expect(res['message']).to eq('Verifique o código do restaurante e tente novamente')
    end
  end
end