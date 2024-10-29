require 'rails_helper'

describe 'Search' do
  context 'when visiting dashboard page' do
    it 'user see a search input and a search button' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      login_as(user)

      visit dashboard_path

      within('nav > form') do
        expect(page).to have_field('Buscar Itens')
        expect(page).to have_button('Buscar')
      end
    end

    it 'user can search' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      Dish.create!(
        name: 'Prato Teste', description: 'Teste', calories: 100,
        restaurant: Restaurant.first
      )

      Beverage.create!(
        name: 'Berja Teste', description: 'Cerveja lata',
        calories: 200, alcoholic: true,
        restaurant: Restaurant.first
      )

      login_as(user)

      visit dashboard_path

      within('nav > form') do
        fill_in 'Buscar Itens', with: 'Teste'
        click_on 'Buscar'
      end

      expect(page).to have_content('Prato Teste')
      expect(page).to have_content('Teste')

      expect(page).to have_content('Berja Teste')
      expect(page).to have_content('Cerveja lata')
    end

    it 'if there is no result, should show a message' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      login_as(user)

      visit dashboard_path

      within('nav > form') do
        fill_in 'Buscar Itens', with: 'Teste'
        click_on 'Buscar'
      end

      expect(page).to have_content('Nenhum prato encontrado')
      expect(page).to have_content('Nenhuma bebida encontrada')
    end

    it 'if theres no restaurant, the input should be not visible' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      login_as(user)

      visit dashboard_path

      within('header') do
        expect(page).not_to have_field('Buscar Itens')
        expect(page).not_to have_button('Buscar')
      end
    end
  end
end