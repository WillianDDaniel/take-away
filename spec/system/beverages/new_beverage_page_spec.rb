require 'rails_helper'

describe 'New Beverage Page' do

  context 'when visiting the new beverage page' do
    it 'if user is not logged, must be redicted to the signin page' do
      visit new_beverage_path

      expect(current_path).to eq new_user_session_path
    end

    it 'if user not have a restaurant, should redirect to the new restaurant page' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      login_as(user)
      visit new_beverage_path

      expect(current_path).to eq new_restaurant_path
    end

    it 'should have a new beverage form' do
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
      visit new_beverage_path

      expect(page).to have_selector('form')

      expect(page).to have_field('Nome da Bebida')
      expect(page).to have_field('Descrição')
      expect(page).to have_field('Calorias')

      expect(page).to have_button('Cadastrar')
    end
  end

  context 'when creating a new beverage' do
    it 'should be created with success' do
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
      visit new_beverage_path

      fill_in 'Nome da Bebida', with: 'Cerveja'
      fill_in 'Descrição', with: 'Cerveja lata'
      fill_in 'Calorias', with: 200
      choose('beverage_alcoholic_true')

      click_button 'Cadastrar'

      expect(current_path).to eq beverages_path
      expect(page).to have_content('Bebida cadastrada com sucesso')
    end

    it 'should show error messages with blank fields' do
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
      visit new_beverage_path

      fill_in 'Nome da Bebida', with: ''

      click_button 'Cadastrar'

      expect(page).to have_content('Erro ao cadastrar bebida')

      expect(page).to have_content('Nome da Bebida não pode ficar em branco')
    end
  end
end