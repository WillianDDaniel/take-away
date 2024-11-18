require 'rails_helper'

describe 'Index Schedules Page' do
  context 'when visiting the index schedules page' do
    it 'if user is not logged in, should redirect to the signin page' do
      visit schedules_path

      expect(current_path).to eq new_user_session_path
    end

    it 'if user not have a restaurant, should redirect to the new restaurant page' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      login_as(user)

      visit schedules_path

      expect(current_path).to eq new_restaurant_path
    end

    it 'if user not have a schedule, show show a message' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      login_as(user)

      Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      visit schedules_path

      expect(page).to have_content('Nenhum horário cadastrado')
      expect(page).to have_link('Cadastrar novo horário')
    end

    it 'if user have a schedule, should show a list of schedules' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      login_as(user)

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      Schedule.create!(
        week_day: 0,
        open_time: '08:00', close_time: '10:00',
        restaurant: restaurant
      )

      Schedule.create!(
        week_day: 1,
        open_time: '09:00', close_time: '11:00',
        restaurant: restaurant
      )

      visit schedules_path

      expect(page).to have_content('Domingo')
      expect(page).to have_content('08:00')
      expect(page).to have_content('10:00')

      expect(page).to have_content('Segunda-feira')
      expect(page).to have_content('09:00')
      expect(page).to have_content('11:00')

      expect(page).not_to have_link('Cadastrar novo horário')
      expect(page).not_to have_content('Nenhum horário cadastrado')
    end

    it 'should not to be visible to staff users' do
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

      staff = User.create!(
        email: 'employee@example.com', name: 'Xavier', last_name: 'Doe',
        password: 'password12345', document_number: staff_document
      )

      login_as(staff)
      visit schedules_path

      expect(current_path).to eq dashboard_path
    end
  end
end
