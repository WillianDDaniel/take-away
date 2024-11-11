require 'rails_helper'

describe 'New employee page', type: :system do
  it 'if user is not logged in, should redirect to the signin page' do
    visit new_employee_path

    expect(current_path).to eq new_user_session_path
  end

  it 'if user not have a role, should redirect to the new restaurant page' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    login_as(user)

    visit new_employee_path

    expect(current_path).to eq new_restaurant_path
  end

  it 'if user have a role of owner, must can reach the new employee page' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
      phone: '11999999999', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    login_as(user)

    visit new_employee_path

    expect(current_path).to eq new_employee_path

    expect(page).to have_selector('form')
    expect(page).to have_field('E-mail do Funcionário')
    expect(page).to have_field('CPF do Funcionário')

    expect(page).to have_button('Cadastrar Funcionário')
  end

  it 'must show error messages with blank fields' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
      phone: '11999999999', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    login_as(user)

    visit new_employee_path

    click_button 'Cadastrar Funcionário'

    expect(page).to have_content('Erro ao cadastrar funcionário')
    expect(page).to have_content('E-mail do Funcionário não pode ficar em branco')
    expect(page).to have_content('CPF do Funcionário não pode ficar em branco')
  end

  it 'must show error messages with invalid document_number' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
      phone: '11999999999', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    login_as(user)

    visit new_employee_path

    fill_in 'E-mail do Funcionário', with: 'johndoes@example.com'
    fill_in 'CPF do Funcionário', with: '11111111111'

    click_button 'Cadastrar Funcionário'

    expect(page).to have_content('Erro ao cadastrar funcionário')
    expect(page).to have_content('CPF do Funcionário inválido')
  end

  it 'must show error messages with invalid email' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
      phone: '11999999999', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    login_as(user)

    visit new_employee_path

    fill_in 'E-mail do Funcionário', with: 'johndoes@'
    fill_in 'CPF do Funcionário', with: CPF.generate

    click_button 'Cadastrar Funcionário'

    expect(page).to have_content('Erro ao cadastrar funcionário')
    expect(page).to have_content('E-mail do Funcionário inválido')
  end

  it 'must show error messages with email already in use' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
      phone: '11999999999', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    login_as(user)

    visit new_employee_path

    fill_in 'E-mail do Funcionário', with: 'johndoes@example.com'
    fill_in 'CPF do Funcionário', with: CPF.generate

    click_button 'Cadastrar Funcionário'

    expect(page).to have_content('Erro ao cadastrar funcionário')
    expect(page).to have_content('E-mail do Funcionário já está em uso')
  end

  it 'must show error messages with document_number already in use' do
    doc_number = CPF.generate
    User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: doc_number
    )

    user = User.create!(
      email: 'user@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', email: 'restaurant@example.com',
      phone: '11999999999', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    login_as(user)

    visit new_employee_path

    fill_in 'E-mail do Funcionário', with: 'employee@example.com'
    fill_in 'CPF do Funcionário', with: doc_number

    click_button 'Cadastrar Funcionário'

    expect(page).to have_content('Erro ao cadastrar funcionário')
    expect(page).to have_content('CPF do Funcionário já está em uso')
  end

  it 'user can add a new employee' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
      phone: '11999999999', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: user
    )

    login_as(user)

    visit new_employee_path

    fill_in 'E-mail do Funcionário', with: 'employee@example.com'
    fill_in 'CPF do Funcionário', with: CPF.generate

    click_button 'Cadastrar Funcionário'

    expect(page).to have_content('Funcionário cadastrado com sucesso')
  end
end