require 'rails_helper'

describe 'New Restaurant Page' do
  context 'when visiting the new restaurant page' do
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
  end
end