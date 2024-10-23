require 'rails_helper'

describe 'New Schedule Page' do
  context 'when visiting the new schedule page' do
    it 'if user is not logged in, should redirect to login' do
      visit new_schedule_path

      expect(current_path).to eq new_user_session_path
    end

    it 'shold be redirected to dashboard if user is already has a schedule' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      (0..6).each do |day|
        Schedule.create!(week_day: day, restaurant: restaurant)
      end

      login_as(user)

      visit new_schedule_path

      expect(current_path).to eq dashboard_path
    end

    it 'should have a new schedule form' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      login_as(user)

      visit new_schedule_path

      expect(page).to have_selector('form')

      expect(page).to have_content('Domingo')
      expect(page).to have_content('Segunda-feira')
      expect(page).to have_content('Terça-feira')
      expect(page).to have_content('Quarta-feira')
      expect(page).to have_content('Quinta-feira')
      expect(page).to have_content('Sexta-feira')
      expect(page).to have_content('Sábado')

      expect(page).to have_button('Cadastrar horário')
    end

    it 'should be able to create a new schedule' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      login_as(user)

      visit new_schedule_path

      click_button 'Cadastrar horários'

      expect(current_path).to eq dashboard_path
    end
  end
end