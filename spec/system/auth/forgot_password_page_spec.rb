require 'rails_helper'

describe 'Forgot Password Page' do
  it 'should see a question' do
    visit new_user_password_path

    expect(page).to have_content('Esqueceu sua senha?')
  end

  it 'should see a submit button' do
    visit new_user_password_path

    expect(page).to have_button('Redefinir senha')
  end
end