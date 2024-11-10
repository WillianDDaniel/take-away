require 'rails_helper'

describe 'Manage Menu Page' do
  it 'if user is not logged in, should redirect to the signin page' do
    visit manage_menu_path(1)

    expect(current_path).to eq new_user_session_path
  end

  it 'if user not have a restaurant, should redirect to the new restaurant page' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    login_as(user)

    visit manage_menu_path(1)

    expect(current_path).to eq new_restaurant_path
  end

  it 'if user have a menu he can add items' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoes@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )

    dish = Dish.create!(
      name: 'Pizza', description: 'Uma deliciosa refeição', calories: 500, restaurant: Restaurant.last
    )

    beverage = Beverage.create!(
      name: 'Coca Cola', description: 'Refrigerante', restaurant: Restaurant.last
    )

    Menu.create!(
      name: 'Teste', restaurant: Restaurant.last
    )

    login_as(user)

    visit manage_menu_path(Menu.last.id)

    check "#{dish.name}", id: "checkbox_dish_#{dish.id}"
    check "#{beverage.name}", id: "checkbox_beverage_#{beverage.id}"

    click_on 'Salvar'

    expect(page).to have_content('Itens do cardápio atualizados com sucesso!')
  end

  it 'if there is no dishes or/and a beverage should show a message' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoes@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )

    Menu.create!(
      name: 'Teste', restaurant: Restaurant.last
    )

    login_as(user)

    visit dashboard_path

    click_on 'Cardápios'

    within "#content_menu_#{Menu.last.id}" do
      click_on 'Gerenciar Itens'
    end

    expect(page).to have_content('Nenhum prato cadastrado')
    expect(page).to have_content('Nenhuma bebida cadastrada')
  end

end