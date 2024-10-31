require 'rails_helper'

RSpec.describe Dish, type: :model do

  describe '#valid?' do
    it 'must be valid with valid attributes' do
      user = User.create!(
        email: 'johndoe@example.com',
        name: 'John',
        last_name: 'Doe',
        password: 'password12345',
        document_number: CPF.generate
      )

      restaurant = Restaurant.create!(brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.new(name: 'Pizza', description: 'Uma deliciosa refeição', calories: 500, restaurant: restaurant)

      expect(dish.valid?).to be true
    end

    it 'must be invalid without a name' do
      dish = Dish.new(description: 'Uma deliciosa refeição', calories: 100)

      expect(dish.valid?).to be false
      expect(dish.errors.include?(:name)).to be true
    end

    it 'must be invalid without a restaurant_id' do
      dish = Dish.new(name: 'Pizza', description: 'Uma deliciosa refeição', calories: 500)

      expect(dish.valid?).to be false
      expect(dish.errors.include?(:restaurant)).to be true
    end

    it 'has a default status of active' do
      dish = Dish.new(name: 'Pizza', description: 'Uma deliciosa refeição', calories: 500)

      expect(dish.status).to eq('active')
    end
  end

  describe 'status' do
    it 'should only allow valid statuses' do
      dish = Dish.new(name: 'Pizza', description: 'Uma deliciosa refeição', calories: 500)
      expect { dish.status = 'invalid_status' }.to raise_error(ArgumentError)
    end

    it 'should allow active and paused status to be set' do
      dish = Dish.new(name: 'Pizza', description: 'Uma deliciosa refeição', calories: 500)

      dish.status = 'active'
      expect(dish.status).to eq('active')
      expect(dish.errors.include?(:status)).to be false

      dish.status = 'paused'
      expect(dish.status).to eq('paused')
      expect(dish.errors.include?(:status)).to be false
    end
  end

  describe 'calories validation' do
    it 'should have a non-negative number of calories' do
      dish = Dish.new(name: 'Pizza', description: 'Uma deliciosa refeição', calories: -100)

      expect(dish.valid?).to be false
      expect(dish.errors.include?(:calories)).to be true
    end
  end
end
