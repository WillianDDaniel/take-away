require 'rails_helper'

describe 'New Dish Page' do
  context 'when visiting the new dish page' do
    it 'if user is not logged in, should redirect to the signin page' do
      visit new_dish_path

      expect(current_path).to eq new_user_session_path
    end

    it 'if user not have a restaurant, should redirect to the new restaurant page' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      login_as(user)

      visit new_dish_path

      expect(current_path).to eq new_restaurant_path
    end

    it 'should have a new dish form' do
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

      visit new_dish_path

      expect(page).to have_selector('form')

      expect(page).to have_field('Nome do Prato')
      expect(page).to have_field('Descrição')
      expect(page).to have_field('Preço')
      expect(page).to have_field('Calorias')

      expect(page).to have_button('Cadastrar')
    end
  end

  context 'when creating a new dish' do
    it 'should create a new dish successfully' do
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

      visit new_dish_path

      fill_in 'Nome do Prato', with: 'Prato Teste'
      fill_in 'Descrição', with: 'Teste'
      fill_in 'Preço', with: '10.00'
      fill_in 'Calorias', with: '100'

      click_button 'Cadastrar'

      expect(page).to have_content('Prato cadastrado com sucesso')
    end

    it 'should show an error message with blank fields' do
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

      visit new_dish_path

      fill_in 'Nome do Prato', with: ''
      fill_in 'Preço', with: ''

      click_button 'Cadastrar'

      expect(page).to have_content('Nome do Prato não pode ficar em branco')
      expect(page).to have_content('Preço não pode ficar em branco')
    end
  end
end