require 'rails_helper'

describe 'Edit Schedule Page' do
  context 'when visiting the edit schedule page' do
    it 'if user is not logged in, should redirect to the signin page' do
      visit edit_schedule_path(1)

      expect(current_path).to eq new_user_session_path
    end

    it 'if user not have a restaurant, should redirect to the new restaurant page' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      login_as(user)
      visit edit_schedule_path(1)

      expect(current_path).to eq new_restaurant_path
    end

    it 'if user not have a schedule or invalid schedule, should redirect to schedules page' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      login_as(user)
      visit edit_schedule_path(1)

      expect(current_path).to eq schedules_path
    end

    it 'should have a edit schedule form' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      login_as(user)

      Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      Schedule.create!(
        week_day: 0,
        open_time: '08:00', close_time: '22:00',
        restaurant: Restaurant.first
      )

      visit edit_schedule_path(Schedule.first)

      expect(page).to have_field('Dia da semana')
      expect(page).to have_field('Abertura')
      expect(page).to have_field('Fechamento')

      expect(page).to have_button('Salvar')
    end
  end

  context 'when editing a schedule' do
    it 'should be edited successfully' do
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

      Schedule.create!(
        week_day: 0,
        open_time: '08:00', close_time: '09:00',
        restaurant: Restaurant.first
      )

      visit edit_schedule_path(Schedule.first)

      select 'segunda-feira', from: 'Dia da semana'
      fill_in 'Abertura', with: '08:00'
      fill_in 'Fechamento', with: '11:00'

      click_button 'Salvar'

      expect(page).to have_content('Horário atualizado com sucesso')

      expect(current_path).to eq schedules_path

      expect(page).to have_content('Segunda-feira')
      expect(page).to have_content('08:00')
      expect(page).to have_content('11:00')
    end

    it 'should show an error message with invalid opening time' do
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

      Schedule.create!(
        week_day: 0,
        open_time: '08:00', close_time: '22:00',
        restaurant: Restaurant.first
      )

      visit edit_schedule_path(Schedule.first)

      select 'segunda-feira', from: 'Dia da semana'
      fill_in 'Abertura', with: '08:00'
      fill_in 'Fechamento', with: '08:00'

      click_button 'Salvar'

      expect(page).to have_content('Abertura deve ser menor que o horário de fechamento')
      expect(page).to have_content('Erro ao atualizar horário')
    end

    it 'should show an error message with blank fields' do
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

      Schedule.create!(
        week_day: 0,
        open_time: '08:00', close_time: '22:00',
        restaurant: Restaurant.first
      )

      visit edit_schedule_path(Schedule.first)

      select 'segunda-feira', from: 'Dia da semana'
      fill_in 'Abertura', with: ''
      fill_in 'Fechamento', with: ''

      click_button 'Salvar'

      expect(page).to have_content('Abertura não pode ficar em branco')
      expect(page).to have_content('Fechamento não pode ficar em branco')
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

      schedule = Schedule.create!(
        week_day: 0,
        open_time: '08:00', close_time: '22:00',
        restaurant: restaurant
      )

      staff_document = CPF.generate

      Employee.create!(email: 'employee@example.com', doc_number: staff_document, restaurant: restaurant)

      staff = User.create!(
        email: 'employee@example.com', name: 'Xavier', last_name: 'Doe',
        password: 'password12345', document_number: staff_document
      )

      login_as(staff)
      visit edit_schedule_path(schedule)

      expect(current_path).to eq dashboard_path
    end
  end
end