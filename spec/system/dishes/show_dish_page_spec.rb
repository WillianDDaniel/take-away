require 'rails_helper'

describe 'Show Dish Page' do
  context 'when visiting the show dish page' do
    it 'if user is not logged in, should redirect to the signin page' do
      visit dish_path(1)

      expect(current_path).to eq new_user_session_path
    end

    it 'if user not have a restaurant, should redirect to the new restaurant page' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      login_as(user)

      visit dish_path(1)

      expect(current_path).to eq new_restaurant_path
    end

    it 'redirect to the dashboard if dish pertence to other restaurant' do

      first_user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      second_user = User.create!(
        email: 'johndoes2@example.com', name: 'Johnk', last_name: 'Does',
        password: 'password12346', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: first_user
      )

      Restaurant.create!(
        brand_name: 'Restaurante Teste2', corporate_name: 'Teste2', email: 'johndoes2@example.com',
        phone: '51994721972', address: 'Rua Teste2',
        doc_number: CNPJ.generate, user: second_user
      )

      dish = Dish.create!(
        name: 'Prato Teste', description: 'Descrição Teste',
        calories: 100, restaurant: restaurant
      )

      login_as(second_user)

      visit dish_path(dish.id)

      expect(current_path).to eq dishes_path
    end

    it 'if dish does not exist, should redirect to the dashboard' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      login_as(user)

      visit dish_path(999)

      expect(current_path).to eq dishes_path
    end

    it 'should render the show dish page' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      dish = Dish.create!(
        name: 'Prato Teste', description: 'Descrição Teste',
        calories: 100, restaurant: restaurant
      )

      login_as(user)

      visit dish_path(dish.id)

      expect(page).to have_content dish.name
      expect(page).to have_content dish.description
      expect(page).to have_content dish.calories

      expect(page).to have_link 'Editar Prato'
      expect(page).to have_button 'Excluir Prato'
    end

    it 'should be redirected to the edit dish page when click on edit' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      dish = Dish.create!(
        name: 'Prato Teste', description: 'Descrição Teste',
        calories: 100, restaurant: restaurant
      )

      login_as(user)

      visit dish_path(dish.id)

      click_on 'Editar Prato'

      expect(current_path).to eq edit_dish_path(dish.id)

      expect(page).to have_field('Nome do Prato')
      expect(page).to have_field('Descrição')
      expect(page).to have_field('Calorias')

      expect(page).to have_button('Atualizar')
    end

    it 'should destroy the dish when click on delete' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      dish = Dish.create!(
        name: 'Prato Teste', description: 'Descrição Teste',
        calories: 100, restaurant: restaurant
      )

      login_as(user)

      visit dish_path(dish.id)

      click_on 'Excluir Prato'

      expect(current_path).to eq dishes_path
      expect(page).to have_content 'Prato excluído com sucesso'
    end

    it 'should have a toggle button to change status to active ou paused' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      dish = Dish.create!(
        name: 'Prato Teste', description: 'Descrição Teste',
        calories: 100, restaurant: restaurant
      )

      login_as(user)

      visit dish_path(dish.id)

      expect(page).to have_button 'Pausar vendas'

      click_on 'Pausar vendas'

      expect(page).not_to have_button 'Pausar vendas'
      expect(page).to have_button 'Ativar vendas'
    end

    it 'user see a button to add a new portion' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      dish = Dish.create!(
        name: 'Prato Teste', description: 'Descrição Teste',
        calories: 100, restaurant: restaurant
      )

      login_as(user)

      visit dish_path(dish.id)

      expect(page).to have_link 'Adicionar porção'

      click_on 'Adicionar porção'

      expect(current_path).to eq new_dish_portion_path(dish.id)
    end

    it 'user see a button to edit a portion' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      dish = Dish.create!(
        name: 'Prato Teste', description: 'Descrição Teste',
        calories: 100, restaurant: restaurant
      )

      portion = Portion.create!(
        description: 'Porção teste',
        price: 10.0, portionable: dish
      )

      login_as(user)

      visit dish_path(dish.id)

      expect(page).to have_link 'Editar porção'

      click_on 'Editar porção'

      expect(current_path).to eq edit_dish_portion_path(dish.id, portion.id)
    end

    it 'user can see the tags on the page' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      dish = Dish.create!(
        name: 'Prato Teste', description: 'Descrição Teste',
        calories: 100, restaurant: restaurant
      )

      dish.tags << Tag.create!(name: 'Vegano', restaurant: restaurant)
      dish.tags << Tag.create!(name: 'Sem Gluten', restaurant: restaurant)

      login_as(user)

      visit dish_path(dish.id)

      expect(page).to have_content 'Vegano'
      expect(page).to have_content 'Sem Gluten'
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

      Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)

      staff_document = CPF.generate

      Employee.create!(email: 'employee@example.com', doc_number: staff_document, restaurant: restaurant)

      staff = User.create!(
        email: 'employee@example.com', name: 'Xavier', last_name: 'Doe',
        password: 'password12345', document_number: staff_document
      )

      login_as(staff)
      visit dish_path(Dish.first.id)

      expect(current_path).to eq dashboard_path
    end

    it 'if beverage is discarded should redirect to dishes page' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.create!(name: 'Cachorro Quente', description: 'Descrição Cachorro Quente',
        calories: 100, restaurant: restaurant
      )

      login_as(user)
      visit dishes_path

      within("#dish_#{dish.id}") do
        click_on 'Excluir'
      end

      visit dish_path(dish.id)

      expect(current_path).to eq dishes_path
    end
  end

  context 'discard portions' do
    it 'user can discard a portion and should not see the portion' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoes@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      dish = Dish.create!(
        name: 'Prato Teste', description: 'Descrição Teste',
        calories: 100, restaurant: restaurant
      )

      Portion.create!(
        description: 'Porção teste',
        price: 100, portionable: dish
      )

      login_as(user)

      visit dish_path(dish.id)

      click_on 'Excluir porção'

      expect(current_path).to eq dish_path(dish.id)
      expect(page).to have_content('Porção excluída com sucesso')
      expect(page).not_to have_content('Porção teste')
      expect(Portion.last.discarded?).to be true
    end
  end
end