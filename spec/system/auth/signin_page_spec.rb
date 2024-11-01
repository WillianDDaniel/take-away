require 'rails_helper'

describe 'Signin Page' do
  context 'when visiting the signin page' do
    it 'should have a signin form' do
      visit root_path

      within('nav') do
        click_on 'Entrar'
      end

      expect(current_path).to eq new_user_session_path
      expect(page).to have_selector('form')

      expect(page).to have_field('E-mail')
      expect(page).to have_field('Senha')
      expect(page).to have_field('Lembre-se de mim')

      expect(page).to have_button('Entrar')
    end
  end

  context 'when signing in with invalid values' do
    it 'should show an error message with blank fields' do
      visit new_user_session_path

      fill_in 'E-mail', with: ''
      fill_in 'Senha', with: ''

      within('form') do
        click_button 'Entrar'
      end

      expect(page).to have_content('E-mail ou senha inválidos')
    end

    it 'should show an error message with email that does not exist' do
      visit new_user_session_path

      fill_in 'E-mail', with: 'johndoe@example.com'
      fill_in 'Senha', with: 'password12345'

      within('form') do
        click_button 'Entrar'
      end

      expect(page).to have_content('E-mail ou senha inválidos')
    end

    it 'should show an error message with wrong password' do
      cpf = CPF.generate

      User.create!(
        email: 'johndoe@example.com', document_number: cpf, name: 'John',
        last_name: 'Doe', password: 'password12345'
      )

      visit new_user_session_path

      fill_in 'E-mail', with: 'johndoe@example.com'
      fill_in 'Senha', with: 'wrongpassword'

      within('form') do
        click_button 'Entrar'
      end

      expect(page).to have_content('E-mail ou senha inválidos')
    end
  end

  context 'when signing in with valid values' do
    it 'should sign in successfully' do
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
        expect(page).to have_button('Sair')
        expect(page).not_to have_link('Entrar')
        expect(page).not_to have_link('Criar conta')
      end

      expect(page).to have_content('Login efetuado com sucesso')
    end

    it 'should be redirected to dashboard page after signing in' do
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

      expect(current_path).to eq(dashboard_path)
    end
  end
end