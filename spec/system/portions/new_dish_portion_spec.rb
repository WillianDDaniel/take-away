require 'rails_helper'

describe 'New Portion Page' do
  it 'if user is not logged, should redirect to the signin page' do
    visit new_dish_portion_path(1)

    expect(current_path).to eq new_user_session_path
  end

  it 'if user not have a restaurant, should redirect to the new restaurant page' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    login_as(user)

    visit new_dish_portion_path(1)

    expect(current_path).to eq new_restaurant_path
  end

  it 'if user not have a dish, should redirect to dashboard' do
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

    visit new_dish_portion_path(1)

    expect(current_path).to eq dashboard_path
  end

  it 'if a dish pertence to other user restaurant, should redirect to dashboard' do
    first_user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    second_user = User.create!(
      email: 'johnpkoes@example.com', name: 'Johan', last_name: 'San',
      password: 'password12345', document_number: CPF.generate
    )

    first_restaurant = Restaurant.create!(
      brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
      phone: '51993831972', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: first_user
    )

    Restaurant.create!(
      brand_name: 'Restaurante Teste2', corporate_name: 'Teste2', email: 'johndoe2@example.com',
      phone: '51993830000', address: 'Rua Teste2',
      doc_number: CNPJ.generate, user: second_user
    )

    dish = Dish.create!(
      name: 'Prato Teste', description: 'Descricão do prato teste',
      calories: 100, restaurant: first_restaurant
    )

    login_as(second_user)

    visit new_dish_portion_path(dish.id)

    expect(current_path).to eq dashboard_path
  end

  it 'user see a phrase with the dish name' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant =Restaurant.create!(
      brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
      phone: '51993831972', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    dish = Dish.create!(
      name: 'Prato Teste', description: 'Descricão do prato teste',
      calories: 100, restaurant: restaurant
    )

    login_as(user)

    visit new_dish_portion_path(dish.id)

    expect(current_path).to eq new_dish_portion_path(dish.id)
    expect(page).to have_content('Cadastro de porção para Prato Teste')
  end

 it 'should see a form to create a new portion' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant =Restaurant.create!(
      brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
      phone: '51993831972', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    dish = Dish.create!(
      name: 'Prato Teste', description: 'Descricão do prato teste',
      calories: 100, restaurant: restaurant
    )

    login_as(user)

    visit new_dish_portion_path(dish.id)

    expect(current_path).to eq new_dish_portion_path(dish.id)

    expect(page).to have_field('Descrição')
    expect(page).to have_field('Preço')
    expect(page).to have_button('Cadastrar')
  end

  it 'should create a new dish portion' do
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
      calories: 100, restaurant: restaurant
    )

    login_as(user)

    visit new_dish_portion_path(dish.id)

    fill_in 'Descrição', with: 'Porção Teste'
    fill_in 'Preço', with: 1000
    click_on 'Cadastrar'

    expect(current_path).to eq dish_path(dish.id)
    expect(page).to have_content('Porção Teste')
    expect(page).to have_content('R$ 10,00')
    expect(page).to have_content('Porção cadastrada com sucesso')
  end

  it 'should not create a new dish portion with blank fields' do
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
      calories: 100, restaurant: restaurant
    )

    login_as(user)

    visit new_dish_portion_path(dish.id)

    fill_in 'Descrição', with: ''
    click_on 'Cadastrar'

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

    dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)

    staff_document = CPF.generate

    Employee.create!(email: 'employee@example.com', doc_number: staff_document, restaurant: restaurant)

    staff = User.create!(
      email: 'employee@example.com', name: 'Xavier', last_name: 'Doe',
      password: 'password12345', document_number: staff_document
    )

    login_as(staff)
    visit new_dish_portion_path(dish.id)

    expect(current_path).to eq dashboard_path
  end
end