require 'rails_helper'

describe 'Dishes Index Page' do
  context 'when visiting the dishes index page' do
    it 'if user is not logged in, should redirect to the signin page' do
      visit dishes_path

      expect(current_path).to eq new_user_session_path
    end

    it 'if user not have a restaurant, should redirect to the new restaurant page' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      login_as(user)  
      visit dishes_path

      expect(current_path).to eq new_restaurant_path
    end

    it 'should see a button to register a new dish' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      login_as(user)
      visit dishes_path

      expect(page).to have_link('Cadastrar Prato')

      click_on 'Cadastrar Prato'

      expect(current_path).to eq new_dish_path
    end

    it 'should have a list of dishes' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      Dish.create!(
        name: 'Prato Teste', description: 'Descrição Teste', price: 10.0,
        calories: 100, restaurant: restaurant
      )

      Dish.create!(
        name: 'Outro Teste', description: 'Outra Descrição', price: 15.0,
        calories: 200, restaurant: restaurant
      )

      login_as(user)
      visit dishes_path

      expect(page).to have_content('Prato Teste')
      expect(page).to have_content('Descrição Teste')
      expect(page).to have_content('10')

      expect(page).to have_content('Outro Teste')
      expect(page).to have_content('Outra Descrição')
      expect(page).to have_content('15')

    end
  end
end