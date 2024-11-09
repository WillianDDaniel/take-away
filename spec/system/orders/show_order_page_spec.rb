require 'rails_helper'

describe 'Show order page' do
  it 'user see the order details' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )

    login_as(user)

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

    order = Order.create!(customer_name: 'John Doe', customer_phone: '11999999999',
      customer_email: 'johndoe@example.com', customer_doc: CPF.generate,
      order_items: [order_dish, order_beverage], menu: menu
    )

    visit order_path(order)

    expect(page).to have_content('Aguardando confirmação')

    expect(page).to have_content('John Doe')
    expect(page).to have_content('11999999999')
    expect(page).to have_content('johndoe@example.com')

    expect(page).to have_content('Burger')
    expect(page).to have_content('Médio')
    expect(page).to have_content('2')
    expect(page).to have_content('Sem cebola')

    expect(page).to have_content('Coca')
    expect(page).to have_content('Garrafa 1L')
    expect(page).to have_content('1')

    expect(page).to have_content('R$ 40,00')
  end
end