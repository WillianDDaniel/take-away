require 'rails_helper'

describe 'Show Beverage Page' do
  it 'if user is not logged, should redirect to the signin page' do
    visit beverage_path(1)

    expect(current_path).to eq new_user_session_path
  end

  it 'if user not have a restaurant, should redirect to the new restaurant page' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    login_as(user)

    visit beverage_path(1)

    expect(current_path).to eq new_restaurant_path
  end

  it 'if user not have a beverage or invalid beverage, should redirect to beverages page' do
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

    visit beverage_path(999)

    expect(current_path).to eq beverages_path
  end

  it 'if beverage not pertence to the restaurant, should redirect to beverages page' do
    first_user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
      phone: '51993831972', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: first_user
    )

    beverage = Beverage.create!(
      name: 'Cerveja', description: 'Cerveja lata',
      calories: 200, alcoholic: true,
      restaurant: restaurant
    )

    second_user = User.create!(
      email: 'johnwick@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Restaurante Teste2', corporate_name: 'Teste2', email: 'johnwick@example.com',
      phone: '51994721972', address: 'Rua Teste2',
      doc_number: CNPJ.generate, user: second_user
    )

    login_as(second_user)

    visit beverage_path(beverage.id)

    expect(current_path).to eq beverages_path
  end

  it 'should show a beverage' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
      phone: '51993831972', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    Beverage.create!(
      name: 'Cerveja', description: 'Cerveja lata',
      calories: 200, alcoholic: true,
      restaurant: Restaurant.last
    )

    login_as(user)

    visit beverage_path(1)

    expect(page).to have_content('Cerveja')
    expect(page).to have_content('Cerveja lata')
    expect(page).to have_content('200')
    expect(page).to have_content('Alcoólica')
  end

  it 'should have a button to pause the beverage' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
      phone: '51993831972', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    beverage = Beverage.create!(
      name: 'Cerveja', description: 'Cerveja lata',
      calories: 200, alcoholic: true,
      restaurant: Restaurant.last
    )

    login_as(user)

    visit beverage_path(beverage.id)

    expect(page).to have_button('Pausar vendas')
  end

  it 'when clicking on pause button, should pause the beverage' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
      phone: '51993831972', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    beverage = Beverage.create!(
      name: 'Cerveja', description: 'Cerveja lata',
      calories: 200, alcoholic: true,
      restaurant: Restaurant.last
    )

    login_as(user)

    visit beverage_path(beverage.id)

    click_on 'Pausar vendas'

    expect(page).to have_content('Status: Pausado')
    expect(page).not_to have_button('Pausar vendas')

    expect(page).to have_button('Ativar vendas')
  end

  it 'user see a button to add a new portion' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
      phone: '51993831972', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    beverage = Beverage.create!(
      name: 'Bebida Teste', description: 'Descricão da bebida teste',
      alcoholic: true, restaurant: restaurant
    )

    login_as(user)

    visit beverage_path(beverage.id)

    expect(page).to have_link 'Adicionar porção'

    click_on 'Adicionar porção'

    expect(current_path).to eq new_beverage_portion_path(beverage.id)
  end

  it 'user see a button to edit a portion' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
      phone: '51993831972', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    beverage = Beverage.create!(
      name: 'Bebida Teste', description: 'Descricão da bebida teste',
      alcoholic: true, restaurant: restaurant
    )

    portion = Portion.create!(
      description: 'Porção teste',
      price: 10.0, portionable: beverage
    )

    login_as(user)

    visit beverage_path(beverage.id)

    expect(page).to have_link 'Editar porção'

    click_on 'Editar porção'

    expect(current_path).to eq edit_beverage_portion_path(beverage.id, portion.id)
  end
end