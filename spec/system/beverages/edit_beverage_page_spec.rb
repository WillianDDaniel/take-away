require 'rails_helper'

describe 'Edit Beverage Page' do
  it 'if user is not logged, should redirect to the signin page' do
    visit edit_beverage_path(1)

    expect(current_path).to eq new_user_session_path
  end

  it 'if user not have a restaurant, should redirect to the new restaurant page' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    login_as(user)
    visit edit_beverage_path(1)

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
    visit edit_beverage_path(999)

    expect(current_path).to eq beverages_path
  end

  it 'if beverage does not pertence to the restaurant, should redirect to beverages page' do
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
      email: 'johndoe2@example.com', name: 'Johnk', last_name: 'Does',
      password: 'password12346', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Restaurante Teste2', corporate_name: 'Teste2', email: 'johndoe2@example.com',
      phone: '51994721972', address: 'Rua Teste2',
      doc_number: CNPJ.generate, user: second_user
    )

    login_as(second_user)

    visit edit_beverage_path(beverage)

    expect(current_path).to eq beverages_path
  end

  it 'should have a form to edit the beverage' do
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
    visit edit_beverage_path(beverage)

    expect(page).to have_field 'Nome', with: beverage.name
    expect(page).to have_field 'Descrição', with: beverage.description
    expect(page).to have_field 'Calorias', with: beverage.calories

    expect(page).to have_button 'Atualizar'
  end

  it 'should update the beverage with success' do
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
    visit edit_beverage_path(beverage)

    fill_in 'Nome da Bebida', with: 'Cerveja litrão'
    fill_in 'Descrição', with: 'Cerveja 1 litro'
    fill_in 'Calorias', with: '300'

    click_on 'Atualizar'

    expect(current_path).to eq beverages_path
    expect(page).to have_content 'Bebida atualizada com sucesso'
    expect(page).to have_content 'Cerveja litrão'
    expect(page).to have_content 'Cerveja 1 litro'
  end

  it 'should not update the beverage with blank fields' do
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
    visit edit_beverage_path(beverage)

    fill_in 'Nome da Bebida', with: ''

    click_on 'Atualizar'

    expect(page).to have_content 'Nome da Bebida não pode ficar em branco'
  end
end