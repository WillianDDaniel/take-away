require 'rails_helper'

describe 'New Order Page' do
  context 'when visiting the new order page' do
    it 'if user is not logged in, should redirect to the signin page' do
      visit new_menu_order_path(1)

      expect(current_path).to eq new_user_session_path
    end

    it 'if user not have a restaurant, should redirect to the new restaurant page' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      login_as(user)

      visit new_menu_order_path(1)

      expect(current_path).to eq new_restaurant_path
    end
  end
end