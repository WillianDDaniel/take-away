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

  it 'if user not have a beverage, should show a message' do
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
    visit beverages_path

    expect(page).to have_content('Nenhuma bebida cadastrada.')
  end

  it 'should see a button to register a new beverage' do
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
    visit beverages_path

    expect(page).to have_link 'Cadastrar Bebida'
    click_on 'Cadastrar Bebida'

    expect(current_path).to eq new_beverage_path
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
      name: 'Cerveja', description: 'Cerveja lata',
      calories: 200, alcoholic: true,
      restaurant: Restaurant.last
    )

    Beverage.create!(
      name: 'Refrigerante', description: 'Refrigerante lata',
      calories: 200, alcoholic: true,
      restaurant: Restaurant.last
    )

    visit beverages_path

    expect(page).to have_link 'Cerveja'
    expect(page).to have_content('Cerveja lata')

    expect(page).to have_link 'Refrigerante'
    expect(page).to have_content('Refrigerante lata')
  end

  it 'should delete a beverage' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
      phone: '51993831972', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    login_as(user)

    Beverage.create!(
      name: 'Cerveja', description: 'Cerveja lata',
      calories: 200, alcoholic: true,
      restaurant: restaurant
    )

    visit beverages_path

    expect(page).to have_link 'Cerveja'
    expect(page).to have_content('Cerveja lata')

    click_on 'Excluir'

    expect(page).not_to have_link 'Cerveja'
    expect(page).not_to have_content('Cerveja lata')
  end
end
