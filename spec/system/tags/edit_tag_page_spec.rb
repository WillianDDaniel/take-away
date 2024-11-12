require 'rails_helper'

describe 'Edit tag page' do
  it 'if user is not logged in, should redirect to the signin page' do
    visit edit_tag_path(1)

    expect(current_path).to eq new_user_session_path
  end

  it 'if user not have a restaurant, should redirect to the new restaurant page' do
    user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )
    login_as(user)

    visit edit_tag_path(1)

    expect(current_path).to eq new_restaurant_path
  end

  it 'if tag does not exist, should redirect to the tags page' do
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

    visit edit_tag_path(999)

    expect(current_path).to eq tags_path
  end

  it 'if tag does not belong to user restaurant, should redirect to the tags page' do
    first_user = User.create!(
      email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
      phone: '11999999999', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: first_user
    )

    tag =Tag.create!(name: 'Promoção', restaurant: restaurant)

    second_user = User.create!(
      email: 'seconduser@example.com', name: 'Maria', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Teste', corporate_name: 'Teste', email: 'seconduser@example.com',
      phone: '11999999982', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: second_user
    )

    login_as(second_user)

    visit edit_tag_path(tag)

    expect(current_path).to eq tags_path
  end

  it 'if user have a restaurant and a tag, must can reach the tags edit page' do
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

    Tag.create!(name: 'Promoção', restaurant: Restaurant.last)
    tag = Tag.create!(name: 'Oferta', restaurant: Restaurant.last)

    visit tags_path

    within "#tag_#{tag.id}" do
      click_on 'Editar'
    end

    expect(current_path).to eq edit_tag_path(tag)
    expect(page).to have_field('Nome do Marcador', with: tag.name)
  end

  it 'user can edit a tag' do
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

    tag = Tag.create!(name: 'Oferta', restaurant: Restaurant.last)

    visit tags_path

    within "#tag_#{tag.id}" do
      click_on 'Editar'
    end

    fill_in 'Nome do Marcador', with: 'Promoção'

    click_on 'Atualizar'

    expect(current_path).to eq tags_path
    expect(page).to have_content('Promoção')
    expect(page).not_to have_content('Oferta')
  end

  it 'user cannot edit a tag with a blank field' do
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

    tag = Tag.create!(name: 'Oferta', restaurant: Restaurant.last)

    visit tags_path

    within "#tag_#{tag.id}" do
      click_on 'Editar'
    end

    fill_in 'Nome do Marcador', with: ''

    click_on 'Atualizar'

    expect(page).to have_content('Erro ao atualizar marcador')
    expect(page).to have_content('Nome do Marcador não pode ficar em branco')
  end

  it 'user cannot edit a tag with a name already in use' do
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

    tag = Tag.create!(name: 'Oferta', restaurant: Restaurant.last)
    Tag.create!(name: 'Promoção', restaurant: Restaurant.last)

    visit tags_path

    within "#tag_#{tag.id}" do
      click_on 'Editar'
    end

    fill_in 'Nome do Marcador', with: 'Promoção'

    click_on 'Atualizar'

    expect(page).to have_content('Erro ao atualizar marcador')
    expect(page).to have_content('Nome do Marcador já está em uso')
  end
end