require 'rails_helper'

RSpec.describe PriceHistory, type: :model do
  describe 'when a portion has updated' do
    it 'should create a history if the price is changed' do
      user = User.create!( email: 'johndoe@example.com', name: 'John',
        last_name: 'Doe', password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      dish = Dish.create!(
        name: 'Prato Teste', description: 'Descricão do prato teste',
        calories: 10, restaurant: restaurant
      )

      portion = Portion.create!(
        description: 'Porção teste',
        price: 10.00, portionable: dish
      )

      old_price = portion.price

      portion.update!(price: 20.00)

      expect(PriceHistory.count).to eq 1
      expect(portion.price).to eq 20.00
      expect(portion.price_histories.last.price).to eq old_price
    end

    it 'should save multiple history registers' do
      user = User.create!( email: 'johndoe@example.com', name: 'John',
        last_name: 'Doe', password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      dish = Dish.create!(
        name: 'Prato Teste', description: 'Descricão do prato teste',
        calories: 10, restaurant: restaurant
      )

      portion = Portion.create!(
        description: 'Porção teste',
        price: 10.00, portionable: dish
      )

      first_price = portion.price
      portion.update!(price: 20.00)

      last_price = portion.price
      portion.update!(price: 30.00)

      expect(PriceHistory.count).to eq 2

      expect(portion.price_histories.first.price).to eq first_price

      expect(portion.price_histories.last.price).to eq last_price
    end

    it 'should not register a history if the price is not changed' do
      user = User.create!( email: 'johndoe@example.com', name: 'John',
        last_name: 'Doe', password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Restaurante Teste', corporate_name: 'Teste', email: 'johndoe@example.com',
        phone: '51993831972', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      dish = Dish.create!(
        name: 'Prato Teste', description: 'Descricão do prato teste',
        calories: 10, restaurant: restaurant
      )

      portion = Portion.create!(
        description: 'Porção teste',
        price: 10.00, portionable: dish
      )

      portion.update!(description: 'Porção editada')

      expect(PriceHistory.count).to eq 0
    end
  end
end
