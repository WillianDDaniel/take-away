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
        order_items: [ordem_dish_02], menu: menu, status: :cancelled, cancel_reason: 'cliente desistiu'
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
        order_items: [ordem_dish_02], menu: menu, status: :cancelled, cancel_reason: 'cliente desistiu'
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

  context 'GET /api/v1/restaurants/:code/orders/:code' do
    it 'should show a order with the correct codes' do
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

      order = Order.create!(
        customer_name: 'Ana Doe', customer_phone: '11999955555',
        customer_email: 'ana@example.com', customer_doc: CPF.generate,
        order_items: [ordem_dish, ordem_beverage], menu: menu, status: :pending
      )

      get "/api/v1/restaurants/#{restaurant.code}/orders/#{order.code}"

      res = JSON.parse(response.body)

      expect(response).to have_http_status(200)

      expect(res['code']).to eq(order.code)
      expect(res['customer_name']).to eq(order.customer_name)
      expect(res['status']).to eq(order.status)
      expect(res['total_price']).to eq(order.total_price)

      expect(res['items'].count).to eq(2)

      expect(res['items'][0]['name']).to eq(dish.name)
      expect(res['items'][0]['quantity']).to eq(1)
      expect(res['items'][0]['note']).to eq('Sem cebola')

      expect(res['items'][1]['name']).to eq(beverage.name)
      expect(res['items'][1]['quantity']).to eq(1)
      expect(res['items'][1]['note']).to eq(nil)
    end

    it 'should show a error message if the order code is not valid' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      get "/api/v1/restaurants/#{restaurant.code}/orders/invalid_code"

      res = JSON.parse(response.body)

      expect(response).to have_http_status(404)

      expect(res['error']).to eq('Código de pedido inválido ou inexistente')
      expect(res['message']).to eq('Verifique o código do pedido e tente novamente')
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
      portion_dish = Portion.create!(description: 'Teste', price: 10, portionable: dish)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)
      menu.dishes << Dish.first

      ordem_dish = OrderItem.new(portion: portion_dish, quantity: 1, note: 'Sem cebola')

      order = Order.create!(
        customer_name: 'Ana Doe', customer_phone: '11999955555',
        customer_email: 'ana@example.com', customer_doc: CPF.generate,
        order_items: [ordem_dish], menu: menu
      )

      get "/api/v1/restaurants/invalid_code/orders/#{order.code}"

      res = JSON.parse(response.body)

      expect(response).to have_http_status(404)

      expect(res['error']).to eq('Restaurante não encontrado')
      expect(res['message']).to eq('Verifique o código do restaurante e tente novamente')
    end
  end

  context 'PATCH /api/v1/restaurants/:restaurant_code/orders/:code' do
    it 'should not update a order with status out of pending or preparing' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      portion = Portion.create!(description: 'Teste', price: 10, portionable: dish)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)
      menu.dishes << dish

      order_item = OrderItem.new(portion: portion, quantity: 1, note: 'Sem cebola')

      order = Order.create!(
        customer_name: 'Ana Doe', customer_phone: '11999955555',
        customer_email: 'ana@example.com', customer_doc: CPF.generate,
        order_items: [order_item], menu: menu, status: :delivered
      )

      patch "/api/v1/restaurants/#{restaurant.code}/orders/#{order.code}"

      res = JSON.parse(response.body)

      expect(response).to have_http_status(403)

      expect(res['error']).to eq('Pedido não pode ser alterado')
      expect(res['message']).to eq('Alteração de pedido não autorizada')
    end

    it 'should update a order with status pending' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      portion = Portion.create!(description: 'Teste', price: 10, portionable: dish)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)
      menu.dishes << dish

      order_item = OrderItem.new(portion: portion, quantity: 1, note: 'Sem cebola')

      order = Order.create!(
        customer_name: 'Ana Doe', customer_phone: '11999955555',
        customer_email: 'ana@example.com', customer_doc: CPF.generate,
        order_items: [order_item], menu: menu, status: :pending
      )

      patch "/api/v1/restaurants/#{restaurant.code}/orders/#{order.code}"

      res = JSON.parse(response.body)

      expect(response).to have_http_status(200)

      expect(res['code']).to eq(order.code)
      expect(res['customer_name']).to eq(order.customer_name)
      expect(res['status']).to eq("preparing")
    end

    it 'should update a order with status preparing' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      portion = Portion.create!(description: 'Teste', price: 10, portionable: dish)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)
      menu.dishes << dish

      order_item = OrderItem.new(portion: portion, quantity: 1, note: 'Sem cebola')

      order = Order.create!(
        customer_name: 'Ana Doe', customer_phone: '11999955555',
        customer_email: 'ana@example.com', customer_doc: CPF.generate,
        order_items: [order_item], menu: menu, status: :preparing
      )

      patch "/api/v1/restaurants/#{restaurant.code}/orders/#{order.code}"

      res = JSON.parse(response.body)

      expect(response).to have_http_status(200)

      expect(res['code']).to eq(order.code)
      expect(res['customer_name']).to eq(order.customer_name)
      expect(res['status']).to eq("ready")
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
      portion_dish = Portion.create!(description: 'Teste', price: 10, portionable: dish)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)
      menu.dishes << Dish.first

      ordem_dish = OrderItem.new(portion: portion_dish, quantity: 1, note: 'Sem cebola')

      order = Order.create!(
        customer_name: 'Ana Doe', customer_phone: '11999955555',
        customer_email: 'ana@example.com', customer_doc: CPF.generate,
        order_items: [ordem_dish], menu: menu
      )

      patch "/api/v1/restaurants/invalid_code/orders/#{order.code}"

      res = JSON.parse(response.body)

      expect(response).to have_http_status(404)

      expect(res['error']).to eq('Restaurante não encontrado')
      expect(res['message']).to eq('Verifique o código do restaurante e tente novamente')
    end

    it 'should show a error message if the order code is not valid' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      patch "/api/v1/restaurants/#{restaurant.code}/orders/invalid_code"

      res = JSON.parse(response.body)

      expect(response).to have_http_status(404)
      expect(res['error']).to eq('Código de pedido inválido ou inexistente')
      expect(res['message']).to eq('Verifique o código do pedido e tente novamente')
    end
  end

  context 'PATCH /api/v1/restaurants/:restaurant_code/orders/:code/cancel' do
    it 'should not cancel a order delivered' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      portion = Portion.create!(description: 'Teste', price: 10, portionable: dish)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)
      menu.dishes << dish

      order_item = OrderItem.new(portion: portion, quantity: 1, note: 'Sem cebola')

      order = Order.create!(
        customer_name: 'Ana Doe', customer_phone: '11999955555',
        customer_email: 'ana@example.com', customer_doc: CPF.generate,
        order_items: [order_item], menu: menu, status: :delivered
      )

      patch "/api/v1/restaurants/#{restaurant.code}/orders/#{order.code}/cancel"

      res = JSON.parse(response.body)

      expect(response).to have_http_status(:forbidden)
      expect(res['error']).to eq('Cancelamento de pedido não autorizado')
      expect(res['message']).to eq('O pedido já foi entregue')
    end

    it 'should not cancel a order without reason' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      portion = Portion.create!(description: 'Teste', price: 10, portionable: dish)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)
      menu.dishes << dish

      order_item = OrderItem.new(portion: portion, quantity: 1, note: 'Sem cebola')

      order = Order.create!(
        customer_name: 'Ana Doe', customer_phone: '11999955555',
        customer_email: 'ana@example.com', customer_doc: CPF.generate,
        order_items: [order_item], menu: menu, status: :pending
      )

      patch "/api/v1/restaurants/#{restaurant.code}/orders/#{order.code}/cancel", params: { cancel_reason: '' }

      res = JSON.parse(response.body)

      expect(response).to have_http_status(:bad_request)
      expect(res['error']).to eq('Cancelamento de pedido não autorizado')
      expect(res['message']).to eq('Cancelamento de pedido requer motivo')
    end

    it 'should cancel a order' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      portion = Portion.create!(description: 'Teste', price: 10, portionable: dish)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)
      menu.dishes << dish

      order_item = OrderItem.new(portion: portion, quantity: 1, note: 'Sem cebola')

      order = Order.create!(
        customer_name: 'Ana Doe', customer_phone: '11999955555',
        customer_email: 'ana@example.com', customer_doc: CPF.generate,
        order_items: [order_item], menu: menu, status: :pending
      )

      patch "/api/v1/restaurants/#{restaurant.code}/orders/#{order.code}/cancel",
        params: { cancel_reason: 'Cliente desistiu' }

      res = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(res['status']).to eq('cancelled')
      expect(res['cancel_reason']).to eq('Cliente desistiu')
    end
  end
end