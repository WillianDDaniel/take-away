require 'rails_helper'

describe 'Edit Dish' do
  it 'when user is not a owner, should redirect to the dashboard' do
    first_user = User.create!(
      email: 'ana@example.com', name: 'Ana', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'anadoe@example.com',
      phone: '51993456123', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: first_user
    )

    dish = Dish.create!(
      name: 'Prato Teste', description: 'Descrição Teste',
      calories: 100, restaurant: restaurant
    )

    second_user = User.create!(
      email: 'john@example.com', name: 'John', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    Restaurant.create!(
      brand_name: 'Outro Restaurante Teste', corporate_name: 'Outro Teste', email: 'johndoe@example.com',
      phone: '51993831972', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: second_user
    )

    login_as(second_user)

    patch(dish_path(dish.id), params: { dish: { name: 'Prato Editado', description: 'Descrição Editada' } })

    expect(response).to redirect_to(dishes_path)
  end

  it 'if user is not logged in, should redirect to the signin page' do
    User.create!(
      email: 'ana@example.com', name: 'Ana', last_name: 'Doe',
      password: 'password12345', document_number: CPF.generate
    )

    restaurant = Restaurant.create!(
      brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'anadoe@example.com',
      phone: '51993456123', address: 'Rua Teste',
      doc_number: CNPJ.generate, user: User.last
    )

    dish = Dish.create!(
      name: 'Prato Teste', description: 'Descrição Teste',
      calories: 100, restaurant: restaurant
    )

    patch(dish_path(dish.id), params: { dish: { name: 'Prato Editado', description: 'Descrição Editada' } })

    expect(response).to redirect_to(new_user_session_path)
  end
end