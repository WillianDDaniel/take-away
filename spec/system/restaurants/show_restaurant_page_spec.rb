require 'rails_helper'

describe 'Show Restaurant Page' do
  it 'if user is not signed in should redirect to the signin page' do
    visit restaurant_path(1)

    expect(current_path).to eq new_user_session_path
  end

  it 'if user not have a restaurant, should redirect to the new restaurant page' do
    User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    login_as(User.last)

    visit restaurant_path(99)

    expect(current_path).to eq new_restaurant_path
  end

  it 'if user have a restaurant, should see the restaurant information' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoes@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )

    login_as(user)

    visit restaurant_path(restaurant.id)

    expect(page).to have_content restaurant.brand_name
    expect(page).to have_content restaurant.corporate_name
    expect(page).to have_content restaurant.code
    expect(page).to have_content restaurant.doc_number
    expect(page).to have_content restaurant.email
    expect(page).to have_content restaurant.phone
    expect(page).to have_content restaurant.address
  end
end