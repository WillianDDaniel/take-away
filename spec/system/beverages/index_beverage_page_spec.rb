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
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
      phone: '51993831972', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    beverage_01 = Beverage.create!(
      name: 'Bebida Teste', description: 'Descrição Teste',
      alcoholic: true, restaurant: restaurant
    )

    Portion.create!(
      description: 'Lata 350ml',
      price: 10, portionable: beverage_01
    )

    Portion.create!(
      description: 'Garafa 500ml',
      price: 20, portionable: beverage_01
    )

    beverage_02 = Beverage.create!(
      name: 'Outro Teste', description: 'Outra Descrição',
      alcoholic: false, restaurant: restaurant
    )

    Portion.create!(
      description: 'Lata 350ml',
      price: 25, portionable: beverage_02
    )

    Portion.create!(
      description: 'Garafa 2L',
      price: 35, portionable: beverage_02
    )

    login_as(user)
    visit beverages_path

    expect(page).to have_content('Bebida Teste')
    expect(page).to have_content('Descrição Teste')
    expect(page).to have_content('Lata 350ml')
    expect(page).to have_content('R$ 10,00')
    expect(page).to have_content('Garafa 500ml')
    expect(page).to have_content('R$ 20,00')

    expect(page).to have_content('Outro Teste')
    expect(page).to have_content('Outra Descrição')
    expect(page).to have_content('Lata 350ml')
    expect(page).to have_content('R$ 25,00')
    expect(page).to have_content('Garafa 2L')
    expect(page).to have_content('R$ 35,00')
  end

  it 'should show a message if the beverage have no portion' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
      phone: '51993831972', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    Beverage.create!(
      name: 'Bebida Teste', description: 'Descrição Teste',
      alcoholic: false, restaurant: restaurant
    )

    login_as(user)

    visit beverages_path

    expect(page).to have_content('Nenhuma porção cadastrada para essa bebida.')
    expect(page).to have_content('Clique no botão abaixo para adicionar porções.')
    expect(page).to have_link('Cadastrar porção')
  end

  it 'beverages must show active or paused status' do
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

    expect(page).to have_content('Ativo')
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
