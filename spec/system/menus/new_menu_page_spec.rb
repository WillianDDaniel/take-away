require 'rails_helper'

describe 'Menus' do

  it 'if user is not logged in, should redirect to the signin page' do
    visit new_menu_path

    expect(current_path).to eq new_user_session_path
  end

  it 'if user not have a restaurant, should redirect to the new restaurant page' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )
    login_as(user)

    visit new_menu_path

    expect(current_path).to eq new_restaurant_path
  end

  it 'if user have a restaurant, must can reach the new menu page' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoes@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )

    login_as(user)

    visit new_menu_path

    expect(current_path).to eq new_menu_path
    expect(page).to have_content('Novo Cardápio')
  end

  it 'user can create a new menu' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoes@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )

    login_as(user)

    visit new_menu_path

    fill_in 'Nome do Cardápio', with: 'Teste'
    click_on 'Cadastrar Cardápio'

    expect(current_path).to eq menus_path
    expect(page).to have_link('Teste')
  end

  it 'user can not create a new menu without name' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoes@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )

    login_as(user)

    visit new_menu_path

    fill_in 'Nome do Cardápio', with: ''
    click_on 'Cadastrar Cardápio'

    expect(page).to have_content('Erro ao cadastrar cardápio')
    expect(page).to have_content('Nome do Cardápio não pode ficar em branco')
  end

  it 'user cannot create menus with the same name' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoes@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )

    Menu.create!(
      name: 'Teste', restaurant: Restaurant.first
    )

    login_as(user)

    visit new_menu_path

    fill_in 'Nome do Cardápio', with: 'Teste'
    click_on 'Cadastrar Cardápio'

    expect(page).to have_content('Erro ao cadastrar cardápio')
    expect(page).to have_content('Já existe um menu com esse nome neste restaurante.')
  end
end