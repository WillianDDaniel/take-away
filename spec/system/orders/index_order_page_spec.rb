require 'rails_helper'

describe 'Index orders page' do
 it 'if user is not logged in, should redirect to the signin page' do
    visit orders_path

    expect(current_path).to eq new_user_session_path
  end

  it 'if user not have a restaurant, should redirect to the new restaurant page' do
    User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    visit new_user_session_path

    fill_in 'E-mail', with: 'johndoes@example.com'
    fill_in 'Senha', with: 'password12345'

    within('form') do
      click_button 'Entrar'
    end

    visit orders_path

    expect(current_path).to eq new_restaurant_path
  end

  it 'if user is logged in and have a restaurant, must can reach the orders page' do
    User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
      phone: '11999999999', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: User.last
    )

    login_as(User.last)

    visit orders_path

    expect(current_path).to eq orders_path
    expect(page).to have_content('Pedidos')
    expect(page).to have_link('Novo Pedido')
  end

  it 'if user not have orders yet, should show a message' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
      phone: '11999999999', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    login_as(user)

    visit orders_path

    expect(page).to have_content('Nenhum pedido cadastrado')
  end

  it 'if user have orders, should show all orders' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )

    dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
    Portion.create!(description: 'Médio', price: 1500, portionable: dish)

    beverage = Beverage.create!(name: 'Coca', description: 'Teste', restaurant: restaurant)
    Portion.create!(description: 'Garrafa 1L', price: 1000, portionable: beverage)

    menu = Menu.create!(name: 'Janta', restaurant: restaurant)

    menu.dishes << dish
    menu.beverages << beverage

    order_dish = OrderItem.new(
      portion: Portion.first, quantity: 2, note: 'Sem cebola'
    )

    order_beverage = OrderItem.new(
      portion: Portion.last, quantity: 1
    )

    first_order = Order.create!(customer_name: 'John Doe', customer_phone: '11999997777',
      customer_email: 'customer@example.com', customer_doc: CPF.generate,
      order_items: [order_beverage], menu: menu
    )

    second_order = Order.create!(customer_name: 'John Doe', customer_phone: '11999999999',
      customer_email: 'othercustomer@example.com', customer_doc: CPF.generate,
      order_items: [order_dish], menu: menu
    )

    login_as(user)

    visit orders_path

    within "#order_#{first_order.id}" do
      expect(page).to have_content("Pedido ##{first_order.code} - #{first_order.customer_name}")
      expect(page).to have_content("Status: #{first_order.status_i18n}")
      expect(page).to have_content("Data: #{first_order.created_at.strftime('%d/%m/%Y')}")
      expect(page).to have_content("Total: R$ 10,00")
      expect(page).to have_link("Ver Pedido")
    end

    within "#order_#{second_order.id}" do
      expect(page).to have_content("Pedido ##{second_order.code} - #{second_order.customer_name}")
      expect(page).to have_content("Status: #{second_order.status_i18n}")
      expect(page).to have_content("Data: #{second_order.created_at.strftime('%d/%m/%Y')}")
      expect(page).to have_content("Total: R$ 30,00")
      expect(page).to have_link("Ver Pedido")
    end
  end

  it 'if user click on a order link, should be redirected to order details' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )

    dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
    Portion.create!(description: 'Médio', price: 15, portionable: dish)

    beverage = Beverage.create!(name: 'Coca', description: 'Teste', restaurant: restaurant)
    Portion.create!(description: 'Garrafa 1L', price: 10, portionable: beverage)

    menu = Menu.create!(name: 'Janta', restaurant: restaurant)

    menu.dishes << dish
    menu.beverages << beverage

    order_dish = OrderItem.new(
      portion: Portion.first, quantity: 2, note: 'Sem cebola'
    )

    order_beverage = OrderItem.new(
      portion: Portion.last, quantity: 1
    )

    order = Order.create!(customer_name: 'John Doe', customer_phone: '11999997777',
      customer_email: 'customer@example.com', customer_doc: CPF.generate,
      order_items: [order_beverage, order_dish], menu: menu
    )

    login_as(user)

    visit orders_path

    within "#order_#{order.id}" do
      click_on 'Ver Pedido'
    end

    expect(current_path).to eq order_path(order)
    expect(page).to have_content("##{order.code}")
  end

  it 'user can see only his orders' do
    first_user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    first_restaurant = Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: first_user
    )

    dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: first_restaurant)
    Portion.create!(description: 'Médio', price: 15, portionable: dish)
    first_menu = Menu.create!(name: 'Janta', restaurant: first_restaurant)
    first_menu.dishes << dish

    order_dish = OrderItem.new(
      portion: Portion.first, quantity: 2, note: 'Sem cebola'
    )

    first_order = Order.create!(customer_name: 'John Doe', customer_phone: '11999997777',
      customer_email: 'customer@example.com', customer_doc: CPF.generate,
      order_items: [order_dish], menu: first_menu
    )

    second_user = User.create!(
      email: 'second_johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    second_restaurant = Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: second_user
    )

    beverage = Beverage.create!(name: 'Coca', description: 'Teste', restaurant: second_restaurant)
    Portion.create!(description: 'Garrafa 1L', price: 10, portionable: beverage)
    second_menu = Menu.create!(name: 'Janta', restaurant: second_restaurant)
    second_menu.beverages << beverage

    order_beverage = OrderItem.new(
      portion: Portion.last, quantity: 1
    )

    second_order = Order.create!(customer_name: 'Ana Doe', customer_phone: '11999992222',
      customer_email: 'second_customer@example.com', customer_doc: CPF.generate,
      order_items: [order_beverage], menu: second_menu
    )

    login_as(first_user)

    visit orders_path

    expect(page).to have_content("##{first_order.code}")
    expect(page).to have_content(first_order.customer_name)

    expect(page).not_to have_content("##{second_order.code}")
    expect(page).not_to have_content(second_order.customer_name)
  end
end