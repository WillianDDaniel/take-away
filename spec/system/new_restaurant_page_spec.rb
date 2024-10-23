require 'rails_helper'

describe 'New Restaurant Page' do
  context 'when visiting the new restaurant page' do
    it 'if user is not logged, must be redicted to the signin page' do
      visit new_restaurant_path

      expect(current_path).to eq new_user_session_path
    end

    it 'should have a new restaurant form' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      login_as(user)

      visit new_restaurant_path

      expect(page).to have_selector('form')

      expect(page).to have_field('Nome Fantasia')
      expect(page).to have_field('Razão Social')
      expect(page).to have_field('CNPJ')
      expect(page).to have_field('Endereço')
      expect(page).to have_field('Telefone')
      expect(page).to have_field('E-mail')

      expect(page).to have_button('Cadastrar')
    end

    it 'shold be redirected to dashboard if user is already has a restaurant' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      login_as(user)

      Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
        doc_number: CNPJ.generate, phone: '11999999999', address: 'Rua Teste',
        user_id: user.id
      )

      visit new_restaurant_path

      expect(current_path).to eq dashboard_path
    end
  end

  context 'when creating a new restaurant' do
    it 'should create a new restaurant successfully' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      login_as(user)

      visit new_restaurant_path

      fill_in 'Nome Fantasia', with: 'Teste'
      fill_in 'Razão Social', with: 'Teste'
      fill_in 'CNPJ', with: CNPJ.generate
      fill_in 'Endereço', with: 'Rua Teste'
      fill_in 'Telefone', with: '11999999999'
      fill_in 'E-mail', with: 'johndoe@example.com'

      click_button 'Cadastrar'

      expect(page).to have_content('Restaurante cadastrado com sucesso')

      expect(current_path).to eq new_schedule_path
      expect(page).not_to have_content('Nenhum restaurante cadastrado')
      expect(page).not_to have_link('Cadastrar restaurante')
    end

    it 'if information is blank, must show an error message' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      login_as(user)

      visit new_restaurant_path

      fill_in 'Nome Fantasia', with: ''
      fill_in 'Razão Social', with: ''
      fill_in 'CNPJ', with: ''
      fill_in 'Endereço', with: ''
      fill_in 'Telefone', with: ''
      fill_in 'E-mail', with: ''

      click_button 'Cadastrar'

      expect(page).to have_content('Nome Fantasia não pode ficar em branco')
      expect(page).to have_content('Razão Social não pode ficar em branco')
      expect(page).to have_content('CNPJ não pode ficar em branco')
      expect(page).to have_content('Endereço não pode ficar em branco')
      expect(page).to have_content('Telefone não pode ficar em branco')
      expect(page).to have_content('E-mail não pode ficar em branco')
    end

    it 'if doc_number, email and phone are invalid, must show error messages' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      login_as(user)

      visit new_restaurant_path

      fill_in 'Nome Fantasia', with: 'Teste'
      fill_in 'Razão Social', with: 'Teste'
      fill_in 'CNPJ', with: '11111111111111'
      fill_in 'Endereço', with: 'Rua Teste'
      fill_in 'Telefone', with: '119999999999'
      fill_in 'E-mail', with: 'johndoe@teste'

      click_button 'Cadastrar'

      expect(page).to have_content('CNPJ inválido')
      expect(page).to have_content('E-mail inválido')
      expect(page).to have_content('Telefone inválido')
    end

    it 'should be redirected to new_schedule page after creating' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      login_as(user)

      visit new_restaurant_path

      fill_in 'Nome Fantasia', with: 'Teste'
      fill_in 'Razão Social', with: 'Teste'
      fill_in 'CNPJ', with: CNPJ.generate
      fill_in 'Endereço', with: 'Rua Teste'
      fill_in 'Telefone', with: '11999999999'
      fill_in 'E-mail', with: 'johndoe@example.com'

      click_button 'Cadastrar'

      expect(page).to have_content('Restaurante cadastrado com sucesso')
      expect(current_path).to eq new_schedule_path
    end
  end
end