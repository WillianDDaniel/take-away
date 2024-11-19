require 'rails_helper'

describe 'New Order Page' do

  context 'when visiting the new order page' do
    it 'if user is not logged in, should redirect to the signin page' do
      visit new_order_path(menu_id: 1)

      expect(current_path).to eq new_user_session_path
    end

    it 'if user not have a restaurant, should redirect to the new restaurant page' do
      user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )
      login_as(user)

      visit new_order_path(menu_id: 1)

      expect(current_path).to eq new_restaurant_path
    end

    it 'can not see new order page with no menu or menu not belong to user' do
      first_user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: first_user
      )

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)

      second_user = User.create!(
        email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoes@example.com', phone: '11999999999', address: 'Rua Teste', user: second_user
      )


      login_as(second_user)
      visit new_order_path(menu_id: menu.id)

      expect(current_path).to eq dashboard_path
    end

    it 'user can add a new order with success' do
      Capybara.current_driver = :cuprite

      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      Beverage.create!(name: 'Coca', description: 'Teste', restaurant: restaurant)

      Portion.create!(description: 'Teste', price: 1000, portionable: Dish.first)
      Portion.create!(description: 'Teste', price: 1000, portionable: Beverage.first)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)

      menu.dishes << Dish.first
      menu.beverages << Beverage.first

      login_as(user)

      visit new_order_path(menu_id: menu.id)

      fill_in 'Nome do Cliente', with: 'John Doe'
      fill_in 'Telefone', with: '51999999999'
      fill_in 'E-mail', with: 'johndoe@example.com'

      within "#order_portion_#{Portion.first.id}" do
        click_on 'Adicionar'
      end

      within "#order_portion_#{Portion.last.id}" do
        click_on 'Adicionar'
      end

      click_on 'Finalizar Pedido'

      expect(current_path).to eq order_path(Order.last)

      expect(page).to have_content('Pedido cadastrado com sucesso')

      expect(page).to have_content('John Doe')
      expect(page).to have_content('51999999999')
      expect(page).to have_content('johndoe@example.com')

      expect(page).to have_content('Burger')
      expect(page).to have_content('Coca')
      expect(page).to have_content('R$ 20,00')

      Capybara.use_default_driver
    end

    it 'user can not add a new order with blank fields' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      Beverage.create!(name: 'Coca', description: 'Teste', restaurant: restaurant)

      Portion.create!(description: 'Teste', price: 1000, portionable: Dish.first)
      Portion.create!(description: 'Teste', price: 1000, portionable: Beverage.first)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)

      menu.dishes << Dish.first
      menu.beverages << Beverage.first

      login_as(user)

      visit new_order_path(menu_id: menu.id)

      fill_in 'Nome do Cliente', with: ''
      fill_in 'Telefone', with: ''
      fill_in 'E-mail', with: ''

      click_on 'Finalizar Pedido'

      expect(page).to have_content('Nome do Cliente não pode ficar em branco')
      expect(page).to have_content('Pelo menos um contato deve ser preenchido (telefone ou email).')

      expect(page).to have_content('Erro ao cadastrar pedido')
    end

    it 'user can not add a new order with invalid fields' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      Beverage.create!(name: 'Coca', description: 'Teste', restaurant: restaurant)

      Portion.create!(description: 'Teste', price: 1000, portionable: Dish.first)
      Portion.create!(description: 'Teste', price: 1000, portionable: Beverage.first)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)

      menu.dishes << Dish.first
      menu.beverages << Beverage.first

      login_as(user)

      visit new_order_path(menu_id: menu.id)

      fill_in 'Nome do Cliente', with: 'John Doe'
      fill_in 'Telefone', with: '5199999999999'
      fill_in 'E-mail', with: 'johndoe@'
      fill_in 'CPF', with: '515151'

      click_on 'Finalizar Pedido'

      expect(page).to have_content('CPF inválido')
      expect(page).to have_content('Telefone inválido')
      expect(page).to have_content('E-mail inválido')
    end

    it 'user can not add new orders with no menu items' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      Beverage.create!(name: 'Coca', description: 'Teste', restaurant: restaurant)

      Portion.create!(description: 'Teste', price: 1000, portionable: Dish.first)
      Portion.create!(description: 'Teste', price: 1000, portionable: Beverage.first)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)

      menu.dishes << Dish.first
      menu.beverages << Beverage.first

      login_as(user)

      visit new_order_path(menu_id: menu.id)

      fill_in 'Nome do Cliente', with: 'John Doe'
      fill_in 'Telefone', with: '51999999999'
      fill_in 'E-mail', with: 'johndoe@example.com'

      click_on 'Finalizar Pedido'

      expect(page).to have_content('Erro ao cadastrar pedido')
      expect(page).to have_content('Nenhum item adicionado ao pedido')
    end

    it 'user can not see inactive items on new order page' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      beverage = Beverage.create!(name: 'Coca', description: 'Teste', restaurant: restaurant)

      Portion.create!(description: 'Prato Teste', price: 1000, portionable: dish)
      Portion.create!(description: 'Bebida Teste', price: 1000, portionable: beverage)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)

      menu.dishes << dish
      menu.beverages << beverage

      dish.update(status: "paused")
      beverage.update(status: "paused")

      login_as(user)

      visit new_order_path(menu_id: menu.id)

      expect(page).not_to have_content('Burger')
      expect(page).not_to have_content('Prato Teste')

      expect(page).not_to have_content('Coca')
      expect(page).not_to have_content('Bebida Teste')
    end
  end

  context 'stage area' do
    it 'if user send a request with invalid fields, should recover order_items on stage area' do
      Capybara.current_driver = :cuprite

      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      beverage = Beverage.create!(name: 'Coca', description: 'Teste', restaurant: restaurant)

      Portion.create!(description: 'Prato Teste', price: 1000, portionable: dish)
      Portion.create!(description: 'Bebida Teste', price: 1000, portionable: beverage)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)

      menu.dishes << dish
      menu.beverages << beverage

      login_as(user)

      visit new_order_path(menu_id: menu.id)

      fill_in 'E-mail', with: 'johndoe@example.com'

      within "#order_portion_#{Portion.first.id}" do
        click_on 'Adicionar'
      end

      within "#order_portion_#{Portion.last.id}" do
        click_on 'Adicionar'
      end

      click_on 'Finalizar Pedido'

      within '#order-items' do
        expect(page).to have_content('Burger')
        expect(page).to have_content('Prato Teste - R$ 10')

        expect(page).to have_content('Coca')
        expect(page).to have_content('Bebida Teste - R$ 10')
      end

      Capybara.use_default_driver
    end

    it 'user can add items to stage area and see total' do
      Capybara.current_driver = :cuprite

      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      beverage = Beverage.create!(name: 'Coca', description: 'Teste', restaurant: restaurant)

      dish_portion = Portion.create!(description: 'Prato Teste', price: 1000, portionable: dish)
      beverage_portion = Portion.create!(description: 'Bebida Teste', price: 1000, portionable: beverage)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)

      menu.dishes << dish
      menu.beverages << beverage

      login_as(user)

      visit new_order_path(menu_id: menu.id)

      fill_in 'E-mail', with: 'johndoe@example.com'

      within "#order_portion_#{dish_portion.id}" do
        click_on 'Adicionar'
      end

      within "#order_portion_#{beverage_portion.id}" do
        click_on 'Adicionar'
      end

      within '#order-items' do
        expect(page).to have_content('Burger')
        expect(page).to have_content('Prato Teste - R$ 10,00')

        expect(page).to have_content('Coca')
        expect(page).to have_content('Bebida Teste - R$ 10,00')
      end

      expect(page).to have_content('Total: R$ 20,00')

      Capybara.use_default_driver
    end

    it 'user can remove items from stage area and see total' do
      Capybara.current_driver = :cuprite

      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.create!(name: 'Burger', description: 'Teste', restaurant: restaurant)
      beverage = Beverage.create!(name: 'Coca', description: 'Teste', restaurant: restaurant)

      dish_portion = Portion.create!(description: 'Prato Teste', price: 1000, portionable: dish)
      beverage_portion = Portion.create!(description: 'Bebida Teste', price: 1000, portionable: beverage)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)

      menu.dishes << dish
      menu.beverages << beverage

      login_as(user)

      visit new_order_path(menu_id: menu.id)


      within "#order_portion_#{dish_portion.id}" do
        click_on 'Adicionar'
      end

      within "#order_portion_#{beverage_portion.id}" do
        click_on 'Adicionar'
      end

      within "#selected_portion_#{dish_portion.id}" do
        click_on 'Remover'
      end

      within '#order-items' do
        expect(page).to have_content('Coca')
        expect(page).to have_content('Bebida Teste - R$ 10,00')
      end

      expect(page).to have_content('Total: R$ 10,00')

      Capybara.use_default_driver
    end
  end
end