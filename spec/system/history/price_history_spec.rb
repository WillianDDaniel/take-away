require 'rails_helper'

describe 'Price History' do
  it 'user see a price history on dish page details' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
      phone: '51993831972', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    dish = Dish.create!(
      name: 'Prato Teste', description: 'Descricão do prato teste',
      calories: 1000, restaurant: restaurant
    )

    portion = Portion.create!(
      description: 'Descricão da porção teste',
      price: 1000, portionable: dish
    )

    portion.update!(price: 2000)

    login_as(user)

    visit dish_path(dish.id)

    expect(page).to have_selector('h3', text: 'Histórico de Preços')
    within('table') do
      expect(page).to have_content('R$ 10,00')
      expect(page).to have_content(PriceHistory.last.updated_price_date.strftime('%d/%m/%Y'))
    end

  end

  it 'user see a price history on beverage page details' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
      phone: '51993831972', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    beverage = Beverage.create!(
      name: 'Bebida Teste', description: 'Descricão da bebida teste',
      calories: 10, restaurant: restaurant
    )

    portion = Portion.create!(
      description: 'Descricão da porção teste',
      price: 1000, portionable: beverage
    )

    portion.update!(price: 2000)

    login_as(user)

    visit beverage_path(beverage.id)

    expect(page).to have_selector('h3', text: 'Histórico de Preços')
    within('table') do
      expect(page).to have_content('R$ 10,00')
      expect(page).to have_content(PriceHistory.last.updated_at.strftime('%d/%m/%Y'))
    end
  end
end