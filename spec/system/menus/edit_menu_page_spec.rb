require 'rails_helper'

describe 'Edit menu' do
  it 'if user is not logged in, should redirect to the signin page' do
    visit edit_menu_path(1)

    expect(current_path).to eq new_user_session_path
  end

  it 'if user not have a restaurant, should redirect to the new restaurant page' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    login_as(user)

    visit edit_menu_path(1)

    expect(current_path).to eq new_restaurant_path
  end

  it 'if menu does not exist or is not from his restaurant, should redirect to the menus page' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoes@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )

    login_as(user)

    visit edit_menu_path(999)

    expect(current_path).to eq dashboard_path
  end

  it 'if user have a restaurant, must can reach the edit menu page' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoes@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )

    menu = Menu.create!(
      name: 'Teste', restaurant: restaurant
    )

    login_as(user)

    visit edit_menu_path(menu.id)

    expect(current_path).to eq edit_menu_path(menu.id)
    expect(page).to have_field('Nome do Cardápio', with: 'Teste')
  end

  it 'user can edit menu with success' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoes@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )

    menu = Menu.create!(
      name: 'Café da manhã', restaurant: restaurant
    )

    login_as(user)

    visit edit_menu_path(menu.id)

    fill_in 'Nome do Cardápio', with: 'Almoço'
    click_on 'Atualizar Cardápio'

    expect(current_path).to eq menus_path
    expect(page).to have_content('Almoço')
    expect(page).not_to have_content('Café da manhã')
  end

  it 'user can not edit menu without name' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoes@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )

    menu = Menu.create!(
      name: 'Café da manhã', restaurant: restaurant
    )

    login_as(user)

    visit edit_menu_path(menu.id)

    fill_in 'Nome do Cardápio', with: ''
    click_on 'Atualizar Cardápio'

    expect(page).to have_content('Nome do Cardápio não pode ficar em branco')
    expect(page).to have_content('Erro ao atualizar cardápio')
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

    menu = Menu.create!(
      name: 'Café da manhã', restaurant: restaurant
    )

    staff_document = CPF.generate

    Employee.create!(email: 'employee@example.com', doc_number: staff_document, restaurant: restaurant)

    staff = User.create!(
      email: 'employee@example.com', name: 'Xavier', last_name: 'Doe',
      password: 'password12345', document_number: staff_document
    )

    login_as(staff)
    visit edit_menu_path(menu.id)

    expect(current_path).to eq dashboard_path
  end
end