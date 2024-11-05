require 'rails_helper'

describe 'Menus' do
  context 'when visiting the menus page' do
    it 'if user is not logged in, should redirect to the signin page' do
      visit menus_path

      expect(current_path).to eq new_user_session_path
    end

    it 'if user not have a restaurant, should redirect to the new restaurant page' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      login_as(user)
      visit menus_path

      expect(current_path).to eq new_restaurant_path
    end

    it 'if user have a restaurant, must can reach the menus index page' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      login_as(user)

      Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoes@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      visit menus_path

      expect(current_path).to eq menus_path

      expect(page).to have_link('Novo Cardápio')
    end

    it 'user can delete menu' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      login_as(user)

      Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoes@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      Menu.create!(
        name: 'Teste', restaurant: Restaurant.last
      )

      visit menus_path

      click_on 'Excluir'

      expect(page).to have_content('Cardápio excluído com sucesso')
    end
  end
end