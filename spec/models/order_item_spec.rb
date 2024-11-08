require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe '#valid?' do
    it 'must be invalid without an order' do
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

      ordem_item = OrderItem.new(
        portion: portion, quantity: 1, note: 'Sem cebola'
      )

      expect(ordem_item.valid?).to be false
      expect(ordem_item.errors.include?(:order)).to be true
    end

    it 'must be invalid without an portion' do
      order = Order.new(
        order_items: [], customer_name: 'John Doe', customer_phone: '11999999999',
        customer_email: 'johndoe@example.com', customer_doc: CPF.generate
      )

      ordem_item = OrderItem.new(
        order: order, quantity: 1, note: 'Sem cebola'
      )

      expect(ordem_item.valid?).to be false
      expect(ordem_item.errors.include?(:portion)).to be true
    end

    it 'must be invalid without a quantity' do
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

      order = Order.new(
        order_items: [], customer_name: 'John Doe', customer_phone: '11999999999',
        customer_email: 'johndoe@example.com', customer_doc: CPF.generate
      )

      ordem_item = OrderItem.new(
        order: order, portion: portion, note: 'Sem cebola'
      )

      expect(ordem_item.valid?).to be false
      expect(ordem_item.errors.include?(:quantity)).to be true
    end

    it 'must be invalid with a non-positive quantity' do
      ordem_item = OrderItem.new(
        quantity: 0, note: 'Sem cebola'
      )

      expect(ordem_item.valid?).to be false
      expect(ordem_item.errors.include?(:quantity)).to be true
    end

  end
end
