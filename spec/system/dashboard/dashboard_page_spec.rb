require 'rails_helper'

describe 'Dashboard Page' do
  context 'when visiting the dashboard page' do
    it 'if user is not logged in, should redirect to the signin page' do
      visit dashboard_path

      expect(current_path).to eq new_user_session_path
    end

    it 'if user is logged in, must can reach the dashboard' do
      cpf = CPF.generate

      User.create!(
        email: 'johndoe@example.com', document_number: cpf, name: 'John',
        last_name: 'Doe', password: 'password12345'
      )

      Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
        phone: '11999999999', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: User.last
      )

      visit new_user_session_path

      fill_in 'E-mail', with: 'johndoe@example.com'
      fill_in 'Senha', with: 'password12345'

      within('form') do
        click_button 'Entrar'
      end

      expect(current_path).to eq dashboard_path
    end

    it 'user see all link of the site menus aside' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      login_as(user)

      visit dashboard_path

      within 'aside' do
        expect(page).to have_link('Inicio')
        expect(page).to have_link('Pedidos')
        expect(page).to have_link('Cardápios')
        expect(page).to have_link('Pratos')
        expect(page).to have_link('Bebidas')
        expect(page).to have_link('Marcadores')
        expect(page).to have_link('Funcionários')
        expect(page).to have_link('Horários')
      end
    end

    it 'user can see the menus of his restaurants' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      Dish.create!(name: 'Dog', description: 'Teste', restaurant: restaurant)
      Beverage.create!(name: 'Coca', description: 'Teste', restaurant: restaurant)
      Beverage.create!(name: 'Fanta', description: 'Teste', restaurant: restaurant)

      menu_01 = Menu.create!(name: 'Janta', restaurant: restaurant)
      menu_02 = Menu.create!(name: 'Café', restaurant: restaurant)
      menu_03 = Menu.create!(name: 'Almoço', restaurant: restaurant)

      menu_01.dishes << Dish.first
      menu_01.beverages << Beverage.first

      menu_02.dishes << Dish.last
      menu_02.beverages << Beverage.last

      menu_03.dishes << Dish.first
      menu_03.beverages << Beverage.last

      login_as(user)

      visit dashboard_path

      expect(page).to have_content('Cardápios Cadastrados')

      within "#menu_#{menu_01.id}" do
        expect(page).to have_content('Cardápio: Janta')
        expect(page).to have_link('Criar Pedido')
      end

      within "#menu_#{menu_02.id}" do
        expect(page).to have_content('Cardápio: Café')
        expect(page).to have_link('Criar Pedido')
      end

      within "#menu_#{menu_03.id}" do
        expect(page).to have_content('Cardápio: Almoço')
        expect(page).to have_link('Criar Pedido')
      end
    end
  end
end