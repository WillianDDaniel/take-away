require 'rails_helper'

RSpec.describe 'Employees index page', type: :system do
  it 'user can see all his employees' do
    user = User.create!(
      email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
      phone: '11999999999', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    doc_number_01 = CPF.generate
    doc_number_02 = CPF.generate

    Employee.create!(email: 'employee@example.com', doc_number: doc_number_01, restaurant: restaurant)
    Employee.create!(email: 'otheremployee@example.com', doc_number: doc_number_02, restaurant: restaurant)

    login_as(user)

    visit employees_path

    expect(page).to have_content('Funcionários')

    expect(page).to have_content('employee@example.com')
    expect(page).to have_content(doc_number_01)

    expect(page).to have_content('otheremployee@example.com')
    expect(page).to have_content(doc_number_02)
  end
end