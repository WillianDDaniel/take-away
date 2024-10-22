require 'rails_helper'

describe 'Singout Feature' do
  it 'should signout the user' do
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

      within('nav') do
        click_button 'Sair'

        expect(page).not_to have_button('Sair')
        expect(page).to have_link('Entrar')
        expect(page).to have_link('Criar conta')
      end

      expect(page).to have_content('Logout efetuado com sucesso')
  end
end