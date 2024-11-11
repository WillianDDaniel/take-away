require 'rails_helper'

describe 'Signup Page' do
  context 'when visiting the signup page' do
    it 'should have a signup form' do
      visit root_path

      within('nav') do
        click_on 'Criar conta'
      end

      expect(current_path).to eq new_user_registration_path

      expect(page).to have_selector('form')

      expect(page).to have_field('Nome')
      expect(page).to have_field('Sobrenome')
      expect(page).to have_field('CPF')
      expect(page).to have_field('E-mail')
      expect(page).to have_field('Senha')
      expect(page).to have_field('Confirme sua senha')

      expect(page).to have_button('Cadastrar')
    end
  end

  context 'when signing up with invalid values' do
    it 'should show error messages with blank fields' do
      visit new_user_registration_path

      fill_in 'Nome', with: ''
      fill_in 'Sobrenome', with: ''
      fill_in 'CPF', with: ''
      fill_in 'E-mail', with: ''
      fill_in 'Senha', with: ''
      fill_in 'Confirme sua senha', with: ''

      click_button 'Cadastrar'

      expect(page).to have_content('Não foi possível salvar usuário: 6 erros')
      expect(page).to have_content('E-mail não pode ficar em branco')
      expect(page).to have_content('Senha não pode ficar em branco')
      expect(page).to have_content('Nome não pode ficar em branco')
      expect(page).to have_content('Sobrenome não pode ficar em branco')
      expect(page).to have_content('CPF não pode ficar em branco')
      expect(page).to have_content('CPF inválido')
    end

    it 'should show a error message with invalid document_number' do
      visit new_user_registration_path

      fill_in 'Nome', with: 'John'
      fill_in 'Sobrenome', with: 'Doe'
      fill_in 'CPF', with: '12345678'
      fill_in 'E-mail', with: 'johndoe@example.com'
      fill_in 'Senha', with: 'password12345'
      fill_in 'Confirme sua senha', with: 'password12345'

      click_button 'Cadastrar'

      expect(page).to have_content('Não foi possível salvar usuário: 1 erro')
      expect(page).to have_content('CPF inválido')
    end

    it 'should show a error message with invalid email' do
      cpf = CPF.generate

      visit new_user_registration_path

      fill_in 'Nome', with: 'John'
      fill_in 'Sobrenome', with: 'Doe'
      fill_in 'CPF', with: cpf
      fill_in 'E-mail', with: 'johndoe@'
      fill_in 'Senha', with: 'password12345'
      fill_in 'Confirme sua senha', with: 'password12345'

      click_button 'Cadastrar'

      expect(page).to have_content('Não foi possível salvar usuário: 1 erro')
      expect(page).to have_content('E-mail não é válido')
    end

    it 'should show a error message with invalid password' do
      cpf = CPF.generate

      visit new_user_registration_path

      fill_in 'Nome', with: 'John'
      fill_in 'Sobrenome', with: 'Doe'
      fill_in 'CPF', with: cpf
      fill_in 'E-mail', with: 'johndoe@example.com'
      fill_in 'Senha', with: 'password'
      fill_in 'Confirme sua senha', with: 'password'

      click_button 'Cadastrar'

      expect(page).to have_content('Não foi possível salvar usuário: 1 erro')
      expect(page).to have_content('Senha é muito curta (mínimo: 12 caracteres')
    end

    it 'should show a error message with invalid password confirmation' do
      cpf = CPF.generate

      visit new_user_registration_path

      fill_in 'Nome', with: 'John'
      fill_in 'Sobrenome', with: 'Doe'
      fill_in 'CPF', with: cpf
      fill_in 'E-mail', with: 'johndoe@example.com'
      fill_in 'Senha', with: 'password12345'
      fill_in 'Confirme sua senha', with: 'password123456'

      click_button 'Cadastrar'

      expect(page).to have_content('Não foi possível salvar usuário: 1 erro')
      expect(page).to have_content('Confirme sua senha deve ser igual a Senha')
    end

    it 'should show a error message when user already exists' do
      cpf = CPF.generate

      User.create!(
        email: 'johndoe@example.com', document_number: cpf, name: 'John',
        last_name: 'Doe', password: 'password12345'
      )

      visit new_user_registration_path

      fill_in 'Nome', with: 'John'
      fill_in 'Sobrenome', with: 'Doe'
      fill_in 'CPF', with: cpf
      fill_in 'E-mail', with: 'johndoe@example.com'
      fill_in 'Senha', with: 'password12345'
      fill_in 'Confirme sua senha', with: 'password12345'

      click_button 'Cadastrar'

      expect(page).to have_content('Não foi possível salvar usuário: 2 erros')
      expect(page).to have_content('E-mail já está em uso')
      expect(page).to have_content('CPF já está em uso')
    end

    it 'should show a error message when name and last_name are invalid' do
      cpf = CPF.generate

      visit new_user_registration_path

      fill_in 'Nome', with: 'John1'
      fill_in 'Sobrenome', with: 'Doe#'
      fill_in 'CPF', with: cpf
      fill_in 'E-mail', with: 'johndoe@example.com'
      fill_in 'Senha', with: 'password12345'
      fill_in 'Confirme sua senha', with: 'password12345'

      click_button 'Cadastrar'

      expect(page).to have_content('Não foi possível salvar usuário: 2 erros')
      expect(page).to have_content('Nome deve conter apenas letras')
      expect(page).to have_content('Sobrenome deve conter apenas letras')
    end
  end

  context 'when signing up with valid values' do
    it 'should create a new user successfully' do
      cpf = CPF.generate

      visit new_user_registration_path

      fill_in 'Nome', with: 'John'
      fill_in 'Sobrenome', with: 'Doe'
      fill_in 'CPF', with: cpf
      fill_in 'E-mail', with: 'johndoe@example.com'
      fill_in 'Senha', with: 'password12345'
      fill_in 'Confirme sua senha', with: 'password12345'

      click_button 'Cadastrar'

      expect(page).to have_content('Bem vindo! Você realizou seu registro com sucesso')

      expect(User.count).to eq(1)
      expect(User.last.email).to eq('johndoe@example.com')
      expect(User.last.document_number).to eq(cpf)
      expect(User.last.name).to eq('John')
      expect(User.last.last_name).to eq('Doe')
    end

    it 'should redirect to the dashboard page when user is staff' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      staff_document = CPF.generate

      Employee.create!(email: 'employee@example.com', doc_number: staff_document, restaurant: restaurant)

      User.create!(
        email: 'employee@example.com', name: 'Xavier', last_name: 'Doe',
        password: 'password12345', document_number: staff_document
      )

      visit new_user_session_path

      within('form') do
        fill_in 'E-mail', with: 'employee@example.com'
        fill_in 'Senha', with: 'password12345'
        click_button 'Entrar'
      end

      expect(current_path).to eq(dashboard_path)
    end
  end
end