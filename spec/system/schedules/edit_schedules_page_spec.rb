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
        open_time: '08:00', close_time: '22:00',
        restaurant: Restaurant.first
      )

      visit edit_schedule_path(Schedule.first)

      select 'segunda-feira', from: 'Dia da semana'
      fill_in 'Abertura', with: '08:00'
      fill_in 'Fechamento', with: '22:00'

      click_button 'Salvar'

      expect(page).to have_content('Horário atualizado com sucesso')

      expect(current_path).to eq schedules_path

      expect(page).to have_content('segunda-feira')
      expect(page).to have_content('08:00')
      expect(page).to have_content('22:00')
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
  end
end