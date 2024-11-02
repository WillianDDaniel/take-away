require 'rails_helper'

describe 'New Tag Page' do
  context 'when visiting the new tag page' do
    it 'if user is not logged in, should redirect to the signin page' do
      visit new_tag_path

      expect(current_path).to eq new_user_session_path
    end

    it 'if user not have a restaurant, should redirect to the new restaurant page' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      login_as(user)

      visit new_tag_path

      expect(current_path).to eq new_restaurant_path
    end

    it 'if user have a restaurant, must can reach the new tag page' do
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

      click_on 'Marcadores'
      click_on 'Novo Marcador'

      expect(current_path).to eq new_tag_path
    end

    it 'must have the form to create a tag' do
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

      click_on 'Marcadores'
      click_on 'Novo Marcador'

      expect(page).to have_selector('form')

      expect(page).to have_field('Nome do Marcador')

      expect(page).to have_button('Cadastrar')
    end

    it 'user can create a new tag' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      login_as(user)

      visit new_tag_path

      fill_in 'Nome do Marcador', with: 'Sem açúcar'

      click_button 'Cadastrar'

      expect(current_path).to eq tags_path
      expect(page).to have_content('Marcador cadastrado com sucesso')

      expect(page).to have_content('Sem açúcar')
    end
  end
end