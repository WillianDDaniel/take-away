require 'rails_helper'

describe 'Tags Index Page' do
  it 'if user is not logged in, should redirect to the signin page' do
    visit tags_path

    expect(current_path).to eq new_user_session_path
  end

  it 'if user not have a restaurant, should redirect to the new restaurant page' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )
    login_as(user)

    visit tags_path

    expect(current_path).to eq new_restaurant_path
  end

  it 'if user have a restaurant, must can reach the tags index page' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )
    login_as(user)

    visit tags_path

    expect(current_path).to eq tags_path
  end

  it 'user see all tags by your restaurant' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )

    Tag.create!(name: 'Sem Gluten', restaurant: Restaurant.last)
    Tag.create!(name: 'Vegano', restaurant: Restaurant.last)
    Tag.create!(name: 'Jantar', restaurant: Restaurant.last)
    Tag.create!(name: 'Zero Calorias', restaurant: Restaurant.last)

    login_as(user)

    visit tags_path

    expect(page).to have_content('Sem Gluten')
    expect(page).to have_content('Vegano')
    expect(page).to have_content('Jantar')
    expect(page).to have_content('Zero Calorias')
  end

  it 'user can delete a tag' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
      email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
    )

    Tag.create!(name: 'Sem Gluten', restaurant: Restaurant.last)
    Tag.create!(name: 'Vegano', restaurant: Restaurant.last)
    tag = Tag.create!(name: 'Zero Calorias', restaurant: Restaurant.last)

    login_as(user)

    visit tags_path

   within("#tag_#{tag.id}") do
     click_on 'Remover'
   end

   expect(current_path).to eq tags_path
   expect(page).to have_content('Marcador excluído com sucesso')

   expect(page).not_to have_content('Zero Calorias')
   expect(page).to have_content('Sem Gluten')
   expect(page).to have_content('Vegano')
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

    staff_document = CPF.generate

    Employee.create!(email: 'employee@example.com', doc_number: staff_document, restaurant: restaurant)

    staff = User.create!(
      email: 'employee@example.com', name: 'Xavier', last_name: 'Doe',
      password: 'password12345', document_number: staff_document
    )

    login_as(staff)
    visit tags_path

    expect(current_path).to eq dashboard_path
  end
end