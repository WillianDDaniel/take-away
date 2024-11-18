require 'rails_helper'

describe 'Edit Portion Page' do
  it 'if user is not logged in, should redirect to the signin page' do
    visit edit_beverage_portion_path(1, 1)

    expect(current_path).to eq new_user_session_path
  end

  it 'if user not have a restaurant, should redirect to the new restaurant page' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    login_as(user)

    visit edit_beverage_portion_path(1, 1)

    expect(current_path).to eq new_restaurant_path
  end

  it 'if user not have a beverage, should redirect to dashboard' do
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

    visit edit_beverage_portion_path(1, 1)

    expect(current_path).to eq dashboard_path
  end

  it 'if user not have a portion, should redirect to dashboard' do
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
      name: 'Cerveja Teste', description: 'Descricão da cerveja teste',
      alcoholic: true, restaurant: restaurant
    )

    login_as(user)

    visit edit_beverage_portion_path(beverage.id, 1)

    expect(current_path).to eq dashboard_path
  end

  it 'if the portion not pertence to user, should redirect to dashboard' do
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
      name: 'Cerveja Teste', description: 'Descricão da cerveja teste',
      alcoholic: true, restaurant: restaurant
    )

    portion = Portion.create!(
      description: 'Descricão da porção teste',
      price: 10, portionable: beverage
    )

    second_user = User.create!(
      email: 'johnpkoes@example.com', name: 'Johan', last_name: 'San',
      password: 'password12345', document_number: CPF.generate
    )

    second_restaurant = Restaurant.create!(
      brand_name: 'Restaurante Teste2', corporate_name: 'Teste2', email: 'johndoe2@example.com',
      phone: '51993830000', address: 'Rua Teste2',
      doc_number: CNPJ.generate, user: second_user
    )

    Beverage.create!(
      name: 'Cerveja Teste2', description: 'Descricão da cerveja teste2',
      alcoholic: true, restaurant: second_restaurant
    )

    login_as(second_user)

    visit edit_beverage_portion_path(beverage.id, portion.id)

    expect(current_path).to eq dashboard_path
  end

  it 'should see a form to edit a portion' do
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
      name: 'Cerveja Teste', description: 'Descricão da cerveja teste',
      alcoholic: true, restaurant: restaurant
    )

    portion = Portion.create!(
      description: 'Descricão da porção teste',
      price: 10, portionable: beverage
    )

    login_as(user)

    visit edit_beverage_portion_path(beverage.id, portion.id)

    expect(page).to have_content('Editar porção de Cerveja Teste')
    expect(page).to have_field('Descrição', with: 'Descricão da porção teste')
    expect(page).to have_field('Preço', with: '10')
    expect(page).to have_button('Atualizar')
  end

  it 'should edit a portion' do
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
      name: 'Cerveja Teste', description: 'Descricão da cerveja teste',
      alcoholic: true, restaurant: restaurant
    )

    portion = Portion.create!(
      description: 'Descricão da porção teste',
      price: 10, portionable: beverage
    )

    login_as(user)

    visit edit_beverage_portion_path(beverage.id, portion.id)

    fill_in 'Descrição', with: 'Descricão da porção editada'
    fill_in 'Preço', with: 20
    click_on 'Atualizar'

    expect(current_path).to eq beverage_path(beverage.id)
    expect(page).to have_content('Descricão da porção editada')
    expect(page).to have_content('20')
  end

  it 'should not edit a portion with blank fields' do
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
      name: 'Cerveja Teste', description: 'Descricão da cerveja teste',
      alcoholic: true, restaurant: restaurant
    )

    portion = Portion.create!(
      description: 'Descricão da porção teste',
      price: 10, portionable: beverage
    )

    login_as(user)

    visit edit_beverage_portion_path(beverage.id, portion.id)

    fill_in 'Descrição', with: ''
    click_on 'Atualizar'

    expect(page).to have_content('Erro ao atualizar porção.')
    expect(page).to have_content('Descrição não pode ficar em branco')
  end

  it 'should not to be visible to staff users' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )

    beverage = Beverage.create!(name: 'Coca', description: 'Teste', restaurant: restaurant)
    portion =  Portion.create!(description: 'Descricão da porção teste', price: 10, portionable: beverage)

    staff_document = CPF.generate

    Employee.create!(email: 'employee@example.com', doc_number: staff_document, restaurant: restaurant)

    staff = User.create!(
      email: 'employee@example.com', name: 'Xavier', last_name: 'Doe',
      password: 'password12345', document_number: staff_document
    )

    login_as(staff)
    visit edit_beverage_portion_path(beverage.id, portion.id)

    expect(current_path).to eq dashboard_path
  end
end