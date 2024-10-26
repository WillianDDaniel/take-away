require 'rails_helper'

describe 'Index Beverage Page' do
  it 'if user is not logged, should redirect to the signin page' do
    visit beverages_path

    expect(current_path).to eq new_user_session_path
  end

  it 'if user not have a restaurant, should redirect to the new restaurant page' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    login_as(user)
    visit beverages_path

    expect(current_path).to eq new_restaurant_path
  end

  it 'should have a list of beverages' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
      phone: '51993831972', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    login_as(user)

    Beverage.create!(
      name: 'Cerveja', description: 'Cerveja lata', price: 5,
      calories: 200, alcoholic: true,
      restaurant: Restaurant.last
    )

    Beverage.create!(
      name: 'Refrigerante', description: 'Refrigerante lata', price: 5,
      calories: 200, alcoholic: true,
      restaurant: Restaurant.last
    )

    visit beverages_path

    expect(page).to have_link 'Cerveja'
    expect(page).to have_content('Cerveja lata')
    expect(page).to have_content('5')

    expect(page).to have_link 'Refrigerante'
    expect(page).to have_content('Refrigerante lata')
    expect(page).to have_content('5')
  end
end
