require 'rails_helper'

describe 'Edit Dish Page' do
  context 'when visiting the edit dish page' do
    it 'if user is not logged in, should redirect to the signin page' do
      visit edit_dish_path(1)

      expect(current_path).to eq new_user_session_path
    end

    it 'if user not have a restaurant, should redirect to the new restaurant page' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      login_as(user)

      visit edit_dish_path(1)

      expect(current_path).to eq new_restaurant_path
    end

    it 'should redirect to dashboard if dish pertence to other user' do

      first_user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: first_user
      )

      Dish.create!(
        name: 'Prato Teste', description: 'Teste', calories: 100,
        restaurant: restaurant
      )

      second_user = User.create!(
        email: 'johndoe2@example.com', name: 'Johnk', last_name: 'Does',
        password: 'password12346', document_number: CPF.generate
      )

      Restaurant.create!(
        brand_name: 'Restaurante Teste2', corporate_name: 'Teste2', email: 'johndoe2@example.com',
        phone: '51994721972', address: 'Rua Teste2',
        doc_number: CNPJ.generate, user: second_user
      )

      login_as(second_user)

      visit edit_dish_path(Dish.last.id)

      expect(current_path).to eq dashboard_path
    end

    it 'if the dish does not exist, should redirect to the dashboard with an alert' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      login_as(user)

      visit edit_dish_path(999)

      expect(current_path).to eq dashboard_path
    end

    it 'should have a edit dish form' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      dish = Dish.create!(
        name: 'Prato Teste', description: 'Teste', calories: 100,
        restaurant: restaurant
      )

      login_as(user)

      visit edit_dish_path(dish.id)

      expect(current_path).to eq edit_dish_path(dish.id)

      expect(page).to have_selector('form')

      expect(page).to have_field('Nome do Prato')
      expect(page).to have_field('Descrição')
      expect(page).to have_field('Calorias')

      expect(page).to have_button('Atualizar')
    end

    it 'should show an error message with blank fields' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      login_as(user)

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      dish = Dish.create!(
        name: 'Prato Teste', description: 'Teste', calories: 100,
        restaurant: restaurant
      )

      visit edit_dish_path(dish.id)

      fill_in 'Nome do Prato', with: ''

      click_button 'Atualizar'

      expect(page).to have_content('Nome do Prato não pode ficar em branco')
    end

    it 'user can create a tag inside the form' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      login_as(user)

      Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      Dish.create!(
        name: 'Prato Teste', description: 'Teste', calories: 100,
        restaurant: Restaurant.last
      )

      visit edit_dish_path(Dish.last.id)

      fill_in 'dish_tags_attributes_0_name', with: 'Sem Gluten'

      click_button 'Atualizar'

      visit tags_path

      expect(page).to have_content('Sem Gluten')
    end
  end
end