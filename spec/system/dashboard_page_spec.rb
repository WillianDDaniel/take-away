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

      visit new_user_session_path

      fill_in 'E-mail', with: 'johndoe@example.com'
      fill_in 'Senha', with: 'password12345'

      within('form') do
        click_button 'Entrar'
      end

      expect(current_path).to eq dashboard_path
    end

    it 'when user has no restaurants, must see a message to create a restaurant' do
      cpf = CPF.generate

      user = User.create!(
        email: 'johndoe@example.com', document_number: cpf, name: 'John',
        last_name: 'Doe', password: 'password12345'
      )

      login_as(user, scope: :user)

      visit dashboard_path

      expect(page).to have_content('Nenhum restaurante cadastrado')
    end
  end
end