require 'rails_helper'

describe 'Show Menu Page' do
  it 'if user is not logged in, should redirect to the signin page' do
    visit menu_path(1)

    expect(current_path).to eq new_user_session_path
  end

  it 'if user not have a restaurant, should redirect to the new restaurant page' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    login_as(user)

    visit menu_path(1)

    expect(current_path).to eq new_restaurant_path
  end

  it 'should see the menu name and all items' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )
    restaurant = Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoes@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )
    menu = Menu.create!(name: 'Lanches', restaurant: restaurant)

    dish_01 = Dish.create!(name: 'X-Burguer', description: 'Um Burguer', restaurant: restaurant)
    dish_02 = Dish.create!(name: 'X-Salada', description: 'Um com X com Salada', restaurant: restaurant)

    beverage_01 = Beverage.create!(name: 'Cerveja', description: 'Cerveja lata', restaurant: restaurant)
    beverage_02 = Beverage.create!(name: 'Refrigerante', description: 'Refrigerante lata', restaurant: restaurant)

    menu.dishes << dish_01
    menu.dishes << dish_02
    menu.beverages << beverage_01
    menu.beverages << beverage_02

    login_as(user)

    visit menu_path(menu.id)

    expect(page).to have_content('Lanches')

    expect(page).to have_content('X-Burguer')
    expect(page).to have_content('Um Burguer')

    expect(page).to have_content('X-Salada')
    expect(page).to have_content('Um com X com Salada')

    expect(page).to have_content('Cerveja')
    expect(page).to have_content('Cerveja lata')

    expect(page).to have_content('Refrigerante')
    expect(page).to have_content('Refrigerante lata')
  end
end