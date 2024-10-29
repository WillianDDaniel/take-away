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

    it 'if user restaurant not have a dish should show a message' do
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

      expect(page).to have_content('Nenhum prato encontrado.')
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
        name: 'Prato Teste', description: 'Descrição Teste',
        calories: 100, restaurant: restaurant
      )

      Dish.create!(
        name: 'Outro Teste', description: 'Outra Descrição',
        calories: 200, restaurant: restaurant
      )

      login_as(user)
      visit dishes_path

      expect(page).to have_content('Prato Teste')
      expect(page).to have_content('Descrição Teste')

      expect(page).to have_content('Outro Teste')
      expect(page).to have_content('Outra Descrição')

    end

    it 'should delete a dish' do
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
        name: 'Prato Teste', description: 'Descrição Teste',
        calories: 100, restaurant: restaurant
      )

      login_as(user)
      visit dishes_path

      expect(page).to have_content('Prato Teste')
      expect(page).to have_content('Descrição Teste')

      click_on 'Excluir'

      expect(page).not_to have_content('Prato Teste')
      expect(page).not_to have_content('Descrição Teste')
    end

    it 'should redirect to edit a dish' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      dish = Dish.create!(
        name: 'Prato Teste', description: 'Descrição Teste',
        calories: 100, restaurant: restaurant
      )

      login_as(user)
      visit dishes_path

      click_on 'Editar'

      expect(current_path).to eq edit_dish_path(dish)

      expect(page).to have_field('Nome do Prato', with: 'Prato Teste')
      expect(page).to have_field('Calorias', with: '100')
    end

    it 'should show a active status when created' do
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
        name: 'Prato Teste', description: 'Descrição Teste',
        calories: 100, restaurant: restaurant
      )

      login_as(user)
      visit dishes_path

      expect(page).to have_content('Ativo')
    end
  end
end