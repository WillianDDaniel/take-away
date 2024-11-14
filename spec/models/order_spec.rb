require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do
    it 'must be invalid without attributes' do
      order = Order.new
      expect(order.valid?).to be false
    end

    it 'must be invalid without a customer_name' do
      order = Order.new(customer_name: nil)
      expect(order.valid?).to be false
      expect(order.errors.include?(:customer_name)).to be true
    end

    it 'must be invalid without a customer_phone or customer_email' do
      order = Order.new(customer_phone: nil, customer_email: nil)
      expect(order.valid?).to be false
      expect(order.errors.include?(:base)).to be true
    end

    it 'must be invalid with invalid phone' do
      order = Order.new(customer_phone: '5199217', customer_email: 'johndoe@example.com')
      expect(order.valid?).to be false
      expect(order.errors.include?(:customer_phone)).to be true
    end

    it 'must be invalid with invalid email' do
      order = Order.new(customer_phone: '11999999999', customer_email: 'johndoe@')
      expect(order.valid?).to be false
      expect(order.errors.include?(:customer_email)).to be true
    end

    it 'must be invalid with a invalid customer_doc' do
      order = Order.new(customer_doc: '123')
      expect(order.valid?).to be false
      expect(order.errors.include?(:customer_doc)).to be true
    end

    it 'must be invalid without at least one menu item' do
      order = Order.new(
        order_items: [], customer_name: 'John Doe', customer_phone: '11999999999',
        customer_email: 'johndoe@example.com', customer_doc: CPF.generate
      )

      expect(order.valid?).to be false
      expect(order.errors.include?(:base)).to be true
    end

    it 'must be valid with valid attributes' do
      user = User.create!(
        email: 'johndoe@example.com', document_number: CPF.generate, name: 'John',
        last_name: 'Doe', password: 'password12345'
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste',
        user: user
      )

      dish = Dish.create!(name: 'Burger', description: 'Teste', calories: 500, restaurant: restaurant)
      portion = Portion.create!(description: 'Descricão da porção teste', price: 10.00, portionable: dish)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)
      menu.dishes << dish

      ordem_item = OrderItem.new(
        portion: portion, quantity: 1, note: 'Sem cebola'
      )

      order = Order.new(
        customer_name: 'John Doe', customer_phone: '11999999999',
        customer_email: 'johndoe@example.com', customer_doc: CPF.generate,
        order_items: [ordem_item], menu: menu
      )

      expect(order.valid?).to be true
    end

    it 'must generate a random code with 8 alphanumeric characters' do
      user = User.create!(
        email: 'johndoe@example.com', document_number: CPF.generate, name: 'John',
        last_name: 'Doe', password: 'password12345'
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste',
        user: user
      )

      dish = Dish.create!(name: 'Burger', description: 'Teste', calories: 500, restaurant: restaurant)
      portion = Portion.create!(description: 'Descricão da porção teste', price: 10.00, portionable: dish)

      menu = Menu.create!(name: 'Janta', restaurant: restaurant)
      menu.dishes << dish

      ordem_item = OrderItem.new(
        portion: portion, quantity: 1, note: 'Sem cebola'
      )

      order = Order.create!(
        customer_name: 'John Doe', customer_phone: '11999999999',
        customer_email: 'johndoe@example.com', customer_doc: CPF.generate,
        order_items: [ordem_item], menu: menu
      )

      expect(order.valid?).to be true
      expect(order.code).not_to be nil
      expect(order.code.length).to eq(8)
      expect(order.code).to match(/\A[a-zA-Z0-9]{8}\z/)
    end

  end
end
