require 'rails_helper'

describe 'Employees index page' do
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
    visit employees_path

    expect(current_path).to eq dashboard_path
  end
end