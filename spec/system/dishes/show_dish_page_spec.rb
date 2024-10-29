require 'rails_helper'

describe 'Show Dish Page' do
  context 'when visiting the show dish page' do
    it 'if user is not logged in, should redirect to the signin page' do
      visit dish_path(1)

      expect(current_path).to eq new_user_session_path
    end

    it 'if user not have a restaurant, should redirect to the new restaurant page' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      login_as(user)

      visit dish_path(1)

      expect(current_path).to eq new_restaurant_path
    end

    it 'redirect to the dashboard if dish pertence to other restaurant' do

      first_user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      second_user = User.create!(
        email: 'johndoes2@example.com', name: 'Johnk', last_name: 'Does',
        password: 'password12346', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: first_user
      )

      Restaurant.create!(
        brand_name: 'Restaurante Teste2', corporate_name: 'Teste2', email: 'johndoes2@example.com',
        phone: '51994721972', address: 'Rua Teste2',
        doc_number: CNPJ.generate, user: second_user
      )

      dish = Dish.create!(
        name: 'Prato Teste', description: 'Descrição Teste',
        calories: 100, restaurant: restaurant
      )

      login_as(second_user)

      visit dish_path(dish.id)

      expect(current_path).to eq dashboard_path
    end

    it 'if dish does not exist, should redirect to the dashboard' do
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

      visit dish_path(999)

      expect(current_path).to eq dashboard_path
    end

    it 'should render the show dish page' do
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

      visit dish_path(dish.id)

      expect(page).to have_content dish.name
      expect(page).to have_content dish.description
      expect(page).to have_content dish.calories

      expect(page).to have_link 'Editar Prato'
      expect(page).to have_button 'Excluir Prato'
    end

    it 'should be redirected to the edit dish page when click on edit' do
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

      visit dish_path(dish.id)

      click_on 'Editar Prato'

      expect(current_path).to eq edit_dish_path(dish.id)

      expect(page).to have_field('Nome do Prato')
      expect(page).to have_field('Descrição')
      expect(page).to have_field('Calorias')

      expect(page).to have_button('Atualizar')
    end

    it 'should destroy the dish when click on delete' do
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

      visit dish_path(dish.id)

      click_on 'Excluir Prato'

      expect(current_path).to eq dashboard_path
      expect(page).to have_content 'Prato excluído com sucesso'

      expect(Dish.count).to eq 0
    end

    it 'should have a toggle button to change status to active ou paused' do
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

      visit dish_path(dish.id)

      expect(page).to have_button 'Pausar vendas'

      click_on 'Pausar vendas'

      expect(page).not_to have_button 'Pausar vendas'
      expect(page).to have_button 'Ativar vendas'
    end

    it 'user see a button to add a new portion' do
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

      visit dish_path(dish.id)

      expect(page).to have_link 'Adicionar porção'

      click_on 'Adicionar porção'

      expect(current_path).to eq new_dish_portion_path(dish.id)
    end
  end
end