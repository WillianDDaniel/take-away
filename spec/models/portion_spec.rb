require 'rails_helper'

RSpec.describe Portion, type: :model do
  describe '#valid?' do
    it 'must have a description' do
      portion = Portion.new

      portion.valid?

      expect(portion.errors.include?(:description)).to be true
    end

    it 'must have a price' do
      portion = Portion.new

      portion.valid?

      expect(portion.errors.include?(:price)).to be true
    end

    it 'must have a dish or beverage' do
      portion = Portion.new

      portion.valid?

      expect(portion.errors.include?(:portionable)).to be true
    end

    it 'must be valid with valid attributes' do
      user = User.create!( email: 'johndoe@example.com', name: 'John',
        last_name: 'Doe', password: 'password12345',
        document_number: CPF.generate
      )

      restaurant = Restaurant.create!(brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.new(name: 'Teste', description: 'Teste', calories: 100, restaurant: restaurant)
      beverage = Beverage.new(name: 'Teste2', description: 'Teste2', alcoholic: true, restaurant: restaurant)

      dish_portion = Portion.new(description: 'Teste', price: 10, portionable: dish)
      beverage_portion = Portion.new(description: 'Teste2', price: 15, portionable: beverage)

      expect(dish_portion.valid?).to be true
      expect(beverage_portion.valid?).to be true
    end
  end
end
