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

      expect(page).to have_content('domingo')
      expect(page).to have_content('08:00')
      expect(page).to have_content('10:00')

      expect(page).to have_content('segunda-feira')
      expect(page).to have_content('09:00')
      expect(page).to have_content('11:00')

      expect(page).not_to have_link('Cadastrar novo horário')
      expect(page).not_to have_content('Nenhum horário cadastrado')
    end
  end
end
