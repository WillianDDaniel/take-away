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

    it 'user can see all of your menus' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      login_as(user)

      Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoes@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      menu = Menu.create!(
        name: 'Teste', restaurant: Restaurant.last
      )

      second_menu = Menu.create!(
        name: 'Teste2', restaurant: Restaurant.last
      )

      visit menus_path

      within "#content_menu_#{menu.id}" do
        expect(page).to have_content('Teste')
      end

      within "#content_menu_#{second_menu.id}" do
        expect(page).to have_content('Teste2')
      end
    end

    it 'user can delete a menu' do
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

    it 'user click on add new itens on menu' do
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

      within "#content_menu_#{Menu.last.id}" do
        click_on 'Gerenciar Cardápio'
      end

      expect(current_path).to eq manage_menu_path(Menu.last)
      expect(page).to have_content('Gerenciar Itens do Cardápio: Teste')
    end
  end
end