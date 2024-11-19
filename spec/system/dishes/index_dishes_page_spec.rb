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

      expect(page).to have_content('Nenhum prato cadastrado!')
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

      dish_01 = Dish.create!(
        name: 'Prato Teste', description: 'Descrição Teste',
        calories: 100, restaurant: restaurant
      )

      Portion.create!(
        description: 'Pequeno',
        price: 1000, portionable: dish_01
      )

      Portion.create!(
        description: 'Grande',
        price: 2000, portionable: dish_01
      )

      dish_02 = Dish.create!(
        name: 'Outro Teste', description: 'Outra Descrição',
        calories: 200, restaurant: restaurant
      )

      Portion.create!(
        description: 'Pequeno',
        price: 2500, portionable: dish_02
      )

      Portion.create!(
        description: 'Grande',
        price: 3500, portionable: dish_02
      )

      login_as(user)
      visit dishes_path

      expect(page).to have_content('Prato Teste')
      expect(page).to have_content('Descrição Teste')
      expect(page).to have_content('Pequeno')
      expect(page).to have_content('R$ 10,00')
      expect(page).to have_content('Grande')
      expect(page).to have_content('R$ 20,00')

      expect(page).to have_content('Outro Teste')
      expect(page).to have_content('Outra Descrição')
      expect(page).to have_content('Pequeno')
      expect(page).to have_content('R$ 25,00')
      expect(page).to have_content('Grande')
      expect(page).to have_content('R$ 35,00')
    end

    it 'should show a message if the dish have no portion' do
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

      expect(page).to have_content('Nenhuma porção cadastrada para esse prato.')
      expect(page).to have_content('Clique no botão abaixo para adicionar porções.')
      expect(page).to have_link('Cadastrar porção')
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

    it 'should not to be visible to staff users' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)

      staff_document = CPF.generate

      Employee.create!(email: 'employee@example.com', doc_number: staff_document, restaurant: restaurant)

      staff = User.create!(
        email: 'employee@example.com', name: 'Xavier', last_name: 'Doe',
        password: 'password12345', document_number: staff_document
      )

      login_as(staff)
      visit dishes_path

      expect(current_path).to eq dashboard_path
    end

    it 'should not show discarded beverages' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      Dish.create!(name: 'Hamburguer', description: 'Descrição Hamburguer',
        calories: 200, restaurant: restaurant
      )

      dish = Dish.create!(name: 'Cachorro Quente', description: 'Descrição Cachorro Quente',
        calories: 100, restaurant: restaurant
      )

      login_as(user)

      visit dishes_path

      within("#dish_#{dish.id}") do
        click_on 'Excluir'
      end

      expect(page).not_to have_link 'Cachorro Quente'
      expect(page).not_to have_content('Descrição Cachorro Quente')
    end
  end
end