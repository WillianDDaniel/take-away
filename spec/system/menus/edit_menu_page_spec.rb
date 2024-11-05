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

  it 'user can update menu' do
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

    fill_in 'Nome do Cardápio', with: 'Teste 2'
    click_on 'Atualizar Cardápio'

    expect(current_path).to eq menus_path
    expect(page).to have_content('Teste 2')
  end

end